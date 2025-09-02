# ---- Build stage ----
FROM nimlang/nim:2.2.0 as build

WORKDIR /app

# Copy source code
COPY . .

# Build with SSL support for HTTPS (Finnhub requires it)
RUN nim c -d:ssl -d:release --opt:speed --gc:orc -o:main main.nim

# ---- Runtime stage ----
FROM debian:bullseye-slim

WORKDIR /app

# Install OpenSSL runtime libraries (needed for HTTPS)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libssl1.1 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy binary from build stage
COPY --from=build /app/main /app/main

# Expose Nim API port
EXPOSE 5000

# Run the server
CMD ["./main"]
