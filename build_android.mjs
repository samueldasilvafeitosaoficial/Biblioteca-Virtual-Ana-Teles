import { cp, mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";

const root = process.cwd();
const envText = await readFile(path.join(root, ".env"), "utf8");
const env = Object.fromEntries(
  envText.split(/\r?\n/).flatMap(line => {
    const match = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*?)\s*$/);
    return match ? [[match[1], match[2].replace(/^(['"])(.*)\1$/, "$2")]] : [];
  })
);

const supabaseUrl = process.env.SUPABASE_URL || env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY || env.SUPABASE_ANON_KEY;
if (!supabaseUrl || !supabaseKey) {
  throw new Error("Defina SUPABASE_URL e SUPABASE_ANON_KEY no arquivo .env.");
}

let browserHtml = await readFile(path.join(root, "templates", "index.html"), "utf8");
browserHtml = browserHtml
  .replace("{{ url_for('static', filename='style.css') }}", "/static/style.css")
  .replace("{{ url_for('static', filename='manifest.json') }}", "/static/manifest.json")
  .replace("{{ supabase_url|tojson }}", JSON.stringify(supabaseUrl))
  .replace("{{ supabase_anon_key|tojson }}", JSON.stringify(supabaseKey));

if (browserHtml.includes("{{")) {
  throw new Error("Ainda há marcações de template Flask não resolvidas no HTML.");
}

await writeFile(path.join(root, "index.html"), browserHtml, "utf8");

const androidHtml = browserHtml.replace(/<body class="([^"]*)"/, '<body class="$1 native-app"');
if (!androidHtml.includes('<body class="') || !androidHtml.includes("native-app")) {
  throw new Error("Não foi possível aplicar o layout nativo do aplicativo Android.");
}

const webDir = path.join(root, "www");
await mkdir(webDir, { recursive: true });
await writeFile(path.join(webDir, "index.html"), androidHtml, "utf8");
await cp(path.join(root, "static"), path.join(webDir, "static"), { recursive: true });
console.log("Index do navegador e arquivos web preparados.");
