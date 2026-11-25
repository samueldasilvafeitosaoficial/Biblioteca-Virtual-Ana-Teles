create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text,
  email text,
  indicated_by text,
  heard_from text,
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can insert their own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', ''),
    new.email
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create table if not exists public.reading_list (
  user_id uuid references auth.users(id) on delete cascade,
  book_id text not null,
  title text not null,
  author text not null,
  progress integer not null default 0 check (progress between 0 and 100),
  updated_at timestamptz default now(),
  primary key (user_id, book_id)
);

alter table public.reading_list enable row level security;

create policy "Users manage their own reading list"
  on public.reading_list for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create table if not exists public.favorites (
  user_id uuid references auth.users(id) on delete cascade,
  book_id text not null,
  title text not null,
  author text not null,
  primary key (user_id, book_id)
);

alter table public.favorites enable row level security;

create policy "Users manage their own favorites"
  on public.favorites for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
