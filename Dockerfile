FROM opentripplanner/opentripplanner:2.5.0

USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

COPY google_transit.zip oc-transpo-gtfs.zip
COPY otp-config.json .
COPY router-config.json .

RUN /docker-entrypoint.sh --build --save

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
