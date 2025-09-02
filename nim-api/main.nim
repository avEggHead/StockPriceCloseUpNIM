import asynchttpserver, asyncdispatch, httpclient
import strformat  # add this at the top

# Get the Finnhub API key from environment variables
const finnhubApiKey = "d2pk6dpr01qnf9nlehi0d2pk6dpr01qnf9nlehig"

# Base URL for Finnhub
const finnhubBase = "https://finnhub.io/api/v1"

# Normal async proc (GC-safe, creates its own HttpClient each time)
proc handleRequest(req: Request) {.async, gcsafe.} =
  if req.url.path == "/api/stocks/search":
    var queryStr = req.url.query  # e.g. "q=apple"
    var targetUrl = finnhubBase & "/search?" & queryStr & "&token=" & finnhubApiKey

    try:
      let client = newHttpClient()  # local client, safe in async context
      let body = client.getContent(targetUrl)
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http200, body, headers)
    except Exception as e:
      let err = fmt"""{{"error":"Failed to reach Finnhub","details":"{e.msg}"}}"""
      let headers = newHttpHeaders([("Content-Type","application/json")])
      await req.respond(Http500, err, headers)
  else:
    await req.respond(Http404, "Not Found")

# Main entry: wrap handler in a closure for serve()
proc main() {.async.} =
  let server = newAsyncHttpServer()
  echo "Nim Finnhub proxy running at http://localhost:5000"
  await server.serve(Port(5000), proc (req: Request): Future[void] {.async, gcsafe.} =
    await handleRequest(req)
  )

waitFor main()
