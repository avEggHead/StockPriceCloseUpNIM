import asynchttpserver, asyncdispatch, httpclient, os, json, strformat

# Base URL for Finnhub
const finnhubBase = "https://finnhub.io/api/v1"

proc handleRequest(req: Request) {.async, gcsafe.} =
  let finnhubApiKey = getEnv("FINNHUB_API_KEY")  # local for GC-safety

  if req.url.path == "/api/stocks/search":
    var queryStr = req.url.query  # e.g. "q=apple"
    var targetUrl = finnhubBase & "/search?" & queryStr & "&token=" & finnhubApiKey

    try:
      let client = newHttpClient()
      let body = client.getContent(targetUrl)
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http200, body, headers)
    except Exception as e:
      let err = fmt"""{{"error":"Failed to reach Finnhub","details":"{e.msg}"}}"""
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http500, err, headers)

  elif req.url.path == "/api/stocks/quote":
    var queryStr = req.url.query  # e.g. "symbol=AAPL"
    var targetUrl = finnhubBase & "/quote?" & queryStr & "&token=" & finnhubApiKey

    try:
      let client = newHttpClient()
      let body = client.getContent(targetUrl)
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http200, body, headers)
    except Exception as e:
      let err = fmt"""{{"error":"Failed to reach Finnhub","details":"{e.msg}"}}"""
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http500, err, headers)

  else:
    await req.respond(Http404, "Not Found")

proc main() {.async.} =
  let server = newAsyncHttpServer()
  echo "Nim Finnhub API running at http://localhost:5000"
  await server.serve(Port(5000), proc (req: Request): Future[void] {.async, gcsafe.} =
    await handleRequest(req)
  )

waitFor main()
