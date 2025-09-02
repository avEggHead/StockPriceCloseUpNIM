import asynchttpserver, asyncdispatch, httpclient, os, strformat

# Base URL for Finnhub
const finnhubBase = "https://finnhub.io/api/v1"

proc addCORSHeaders(headers: var HttpHeaders) =
  headers["Access-Control-Allow-Origin"] = "*"
  headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
  headers["Access-Control-Allow-Headers"] = "Content-Type"

proc handleRequest(req: Request) {.async, gcsafe.} =
  let finnhubApiKey = getEnv("FINNHUB_API_KEY")  # local for GC-safety
  var headers = newHttpHeaders([("Content-Type","application/json")])
  addCORSHeaders(headers)

  # Handle preflight OPTIONS requests
  if req.reqMethod == HttpOptions:
    await req.respond(Http204, "", headers)
    return

  if req.url.path == "/api/stocks/search":
    let queryStr = req.url.query  # e.g. "q=apple"
    let targetUrl = finnhubBase & "/search?" & queryStr & "&token=" & finnhubApiKey

    try:
      let client = newHttpClient()
      let body = client.getContent(targetUrl)
      await req.respond(Http200, body, headers)
    except Exception as e:
      let err = fmt"""{{"error":"Failed to reach Finnhub","details":"{e.msg}"}}"""
      await req.respond(Http500, err, headers)

  elif req.url.path == "/api/stocks/quote":
    let queryStr = req.url.query  # e.g. "symbol=AAPL"
    let targetUrl = finnhubBase & "/quote?" & queryStr & "&token=" & finnhubApiKey

    try:
      let client = newHttpClient()
      let body = client.getContent(targetUrl)
      await req.respond(Http200, body, headers)
    except Exception as e:
      let err = fmt"""{{"error":"Failed to reach Finnhub","details":"{e.msg}"}}"""
      await req.respond(Http500, err, headers)

  else:
    let err = """{"error":"Not Found"}"""
    await req.respond(Http404, err, headers)

when isMainModule:
  let server = newAsyncHttpServer()
  waitFor server.serve(Port(5000), handleRequest)
