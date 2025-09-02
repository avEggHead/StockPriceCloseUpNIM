const apiBase = "http://localhost:5000/api";

async function searchStocks() {
  const query = document.getElementById("searchInput").value;
  const resp = await fetch(`${apiBase}/stocks/search?q=${encodeURIComponent(query)}`);
  const data = await resp.json();
  document.getElementById("output").textContent = JSON.stringify(data, null, 2);
}

async function getQuote() {
  const symbol = document.getElementById("quoteInput").value;
  const resp = await fetch(`${apiBase}/stocks/quote?symbol=${encodeURIComponent(symbol)}`);
  const data = await resp.json();
  document.getElementById("output").textContent = JSON.stringify(data, null, 2);
}
