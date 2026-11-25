import os
import secrets
from pathlib import Path

from dotenv import load_dotenv
from flask import Flask, render_template

BASE_DIR = Path(__file__).resolve().parent
load_dotenv(BASE_DIR / ".env")

app = Flask(__name__)
app.secret_key = secrets.token_hex(32)

SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY", "")


@app.route("/")
def home():
    return render_template(
        "index.html",
        supabase_url=SUPABASE_URL,
        supabase_anon_key=SUPABASE_ANON_KEY,
    )


if __name__ == "__main__":
    app.run(debug=False, host="127.0.0.1", port=5000)
