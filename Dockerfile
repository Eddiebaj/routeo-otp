FROM opentripplanner/opentripplanner:2.5.0

USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# OTP image expects everything in /var/opentripplanner
RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o google_transit.zip

COPY otp-config.json .
COPY router-config.json .

# Build graph at image build time (no directory arg — entrypoint uses /var/opentripplanner)
RUN /docker-entrypoint.sh --build --save

EXPOSE 8080

# At runtime, load the pre-built graph and serve
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
