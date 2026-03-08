FROM opentripplanner/opentripplanner:2.5.0

USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

# OTP 2.x picks up any .zip as GTFS — name it clearly
RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o oc-transpo-gtfs.zip

COPY otp-config.json .
COPY router-config.json .

# Verify files are present before building
RUN echo "=== Files in /var/opentripplanner ===" && ls -lah

RUN /docker-entrypoint.sh --build --save

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
