const API_BASE = "https://nim-api.happywater-349b476f.eastus.azurecontainerapps.io";

async function doSearch() {
  const query = document.getElementById("searchBox").value;
  const data = await searchStocks(query);

  const list = document.getElementById("searchResults");
  list.innerHTML = ""; // clear old

  if (data.error) {
    list.innerHTML = `<li style="color:red">Error: ${data.error}</li>`;
    return;
  }

  if (data.result && data.result.length > 0) {
    data.result.forEach(item => {
      const li = document.createElement("li");
      li.textContent = `${item.symbol} — ${item.description}`;
      list.appendChild(li);
    });
  } else {
    list.innerHTML = "<li>No results found.</li>";
  }
}

async function doQuote() {
  const symbol = document.getElementById("quoteInput").value;
  const data = await getQuote(symbol);

  const div = document.getElementById("quoteResult");
  div.innerHTML = ""; // clear old

  if (data.error) {
    div.innerHTML = `<p style="color:red">Error: ${data.error}</p>`;
    return;
  }

  // Build a clean table for key fields
  div.innerHTML = `
    <table class="quote-table">
      <tr><th>Symbol</th><td>${symbol}</td></tr>
      <tr><th>Open</th><td>${data.o}</td></tr>
      <tr><th>Current</th><td>${data.c}</td></tr>
      <tr><th>Change %</th><td>${data.dp}%</td></tr>
      <tr><th>High</th><td>${data.h}</td></tr>
      <tr><th>Low</th><td>${data.l}</td></tr>
      <tr><th>Prev Close</th><td>${data.pc}</td></tr>
    </table>
  `;
}

// existing backend calls
async function searchStocks(query) {
  const res = await fetch(`${API_BASE}/api/stocks/search?q=${encodeURIComponent(query)}`);
  const data = await res.json();
  data.result = data.result.filter(item => !item.symbol.includes(".")); // filter out invalid
  return data;
}

async function getQuote(symbol) {
    symbol = symbol.trim().toUpperCase();
  const res = await fetch(`${API_BASE}/api/stocks/quote?symbol=${encodeURIComponent(symbol)}`);
  return await res.json();
}
