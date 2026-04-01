FROM opentripplanner/opentripplanner:2.5.0@sha256:a8e8fa2dc7c97c48e0ed22c77cbc5c0b4dc7a31b9d72c4cc83a0ad953fcb61dd

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

# Download pre-built graph from GitHub Release
RUN curl -L \
    "https://github.com/Eddiebaj/routeo-otp/releases/download/v1.0-graph/graph.obj" \
    -o graph.obj

COPY otp-config.json .
COPY router-config.json .

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
