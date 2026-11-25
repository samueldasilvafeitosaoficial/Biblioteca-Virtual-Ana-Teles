PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    indicated_by TEXT DEFAULT '',
    heard_from TEXT DEFAULT ''
);

CREATE TABLE books (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    category TEXT NOT NULL,
    rating TEXT,
    synopsis TEXT
);

CREATE TABLE reading_list (
    user_id INTEGER NOT NULL,
    book_id TEXT NOT NULL,
    progress INTEGER NOT NULL DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

CREATE TABLE favorites (
    user_id INTEGER NOT NULL,
    book_id TEXT NOT NULL,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (book_id) REFERENCES books(id)
);

INSERT OR IGNORE INTO books (id, title, author, category, rating, synopsis) VALUES
('culpa-estrelas', 'A Culpa e das Estrelas', 'John Green', 'Romance', '4,9',
 'Hazel Grace Lancaster e Augustus Waters se conhecem em um grupo de apoio para pacientes com cancer.'),
('1984', '1984', 'George Orwell', 'Educacao', '4,8',
 'Winston Smith vive em uma sociedade totalitaria controlada pelo Grande Irmao.'),
('orgulho-preconceito', 'Orgulho e Preconceito', 'Jane Austen', 'Romance', '4,9',
 'Elizabeth Bennet enfrenta as pressoes sociais pelo casamento e conhece o orgulhoso Sr. Darcy.'),
('pequeno-principe', 'O Pequeno Principe', 'Antoine de Saint-Exupery', 'Fantasia', '4,9',
 'Um piloto encontra no deserto um pequeno principe de outro planeta.'),
('harry-potter', 'Harry Potter e a Pedra Filosofal', 'J.K. Rowling', 'Fantasia', '4,9',
 'Harry descobre que e um bruxo e inicia seus estudos em Hogwarts.');
