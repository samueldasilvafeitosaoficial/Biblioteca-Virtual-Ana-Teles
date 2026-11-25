# Biblioteca Virtual Ana Teles

Aplicação web responsiva em Python/Flask baseada no protótipo de 17 telas.

## Requisitos

- Python 3.10 ou superior

## Executar

```powershell
python -m pip install -r requirements.txt
python app.py
```

Acesse http://127.0.0.1:5000

Para abrir pelo VS Code Live Server na porta 5500, gere primeiro o HTML estático:

```powershell
npm run browser:prepare
```

Depois abra http://127.0.0.1:5500. Esse modo mantém a moldura simulada para apresentação.

## Contas

Crie uma conta pela tela de cadastro. A autenticação usa o Supabase configurado em `.env`.

## Gerar APK Android

Requisitos: Node.js, Java/JDK e Android SDK.

```powershell
npm install
npm run android:init
npm run android:apk
```

O APK de depuração será criado em `android/app/build/outputs/apk/debug/app-debug.apk`.
Ele pode ser instalado para testes em um aparelho Android. Para distribuição pública,
gere uma versão de lançamento assinada no Android Studio.
