const API_BASE = "https://nim-api.happywater-349b476f.eastus.azurecontainerapps.io";

async function searchStocks(query) {
  const res = await fetch(`${API_BASE}/api/stocks/search?q=${encodeURIComponent(query)}`);
  return await res.json();
}

async function getQuote(symbol) {
  const res = await fetch(`${API_BASE}/api/stocks/quote?symbol=${encodeURIComponent(symbol)}`);
  return await res.json();
}
