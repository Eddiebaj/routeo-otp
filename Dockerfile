FROM opentripplanner/opentripplanner:2.5.0

USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# OTP requires /var/opentripplanner to exist
RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o google_transit.zip

COPY otp-config.json .
COPY router-config.json .

# Build the graph at image build time
RUN /docker-entrypoint.sh --build --save /var/opentripplanner

EXPOSE 8080

# At runtime, just load and serve the pre-built graph
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve", "/var/opentripplanner"]
