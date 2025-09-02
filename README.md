📈 Stock Price Close-Up — Nim API + Plain Frontend

This project demonstrates Way #3 of the “Website Three Ways” series:
a stock lookup app built with a Nim API backend + a plain HTML/JS frontend, deployed serverlessly on Azure Container Apps.

🗂 Repo Structure
StockPriceCloseUpNIM/
│
├── nim-api/           # Nim backend API
│   ├── main.nim
│   ├── Dockerfile
│
├── web-frontend/      # Plain HTML + JS frontend
│   ├── index.html
│   ├── script.js
│
└── .github/
    └── workflows/
        ├── infra.yml   # One-time setup (Azure resources)
        └── deploy.yml  # Build & deploy Nim API

🚀 Features

✅ Nim API (asynchttpserver + httpclient)

✅ Connects to Finnhub API for live stock data

✅ Endpoints:

/api/stocks/search?q=apple

/api/stocks/quote?symbol=AAPL

✅ Dockerized and deployed to Azure Container Apps

✅ Frontend: Plain HTML + JavaScript fetch() demo

✅ CI/CD via GitHub Actions

🔑 Setup
1. Prerequisites

Docker Desktop

Azure CLI

GitHub account
 + Docker Hub account

Finnhub API key (sign up free: https://finnhub.io
)

2. Configure Secrets in GitHub

Go to: Repo → Settings → Secrets and variables → Actions → New repository secret

Add the following:

DOCKERHUB_USER → your Docker Hub username

DOCKERHUB_TOKEN → Docker Hub personal access token

Docker Hub → Account Settings → Security → New Access Token

AZURE_CREDENTIALS → JSON output from:

az ad sp create-for-rbac \
  --name nim-api-sp \
  --role contributor \
  --scopes /subscriptions/<your-subscription-id> \
  --sdk-auth


AZURE_RESOURCE_GROUP → e.g. nim-api-rg

AZURE_CONTAINER_ENV → e.g. nim-api-env

FINNHUB_API_KEY → your private Finnhub API key

3. Run Infrastructure Workflow

Manually trigger infra.yml in GitHub Actions.
This will create:

Azure Resource Group

Azure Container Apps Environment

4. Build & Deploy Nim API

On push to main (or manual trigger), deploy.yml will:

Build Docker image for Nim API

Push to Docker Hub

Deploy to Azure Container Apps with your Finnhub key injected

5. Test the Live API

Your API will be available at:

https://nim-api.<region>.azurecontainerapps.io/api/stocks/search?q=apple
https://nim-api.<region>.azurecontainerapps.io/api/stocks/quote?symbol=AAPL

🌐 Local Development

To run locally with Nim:

cd nim-api
nim c -r -d:ssl main.nim


Test in browser:

http://localhost:5000/api/stocks/search?q=apple
http://localhost:5000/api/stocks/quote?symbol=AAPL

💻 Frontend Demo

Located in web-frontend/.

index.html — basic UI with search + quote inputs

script.js — calls Nim API via fetch()

Open index.html directly in your browser.
When deployed to Azure Static Web Apps or Storage Static Website, point it at your live Nim API URL.

💰 Costs

Azure Container Apps → Free tier covers 180k vCPU-seconds, 360k GiB-seconds, and 2M requests/month.

Docker Hub → free for public repos.

Total cost: ~$0–5/month depending on usage.

📚 References

Nim Programming Language

Azure Container Apps

Finnhub Stock API

Docker Hub