FROM opentripplanner/opentripplanner:2.5.0

USER root
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

# Download GTFS with retry and verify it's a valid zip
RUN curl -L --retry 3 --retry-delay 5 \
    "https://www.octranspo.com/files/google_transit.zip" \
    -o oc-transpo-gtfs.zip \
    && echo "Downloaded $(du -sh oc-transpo-gtfs.zip)" \
    && unzip -t oc-transpo-gtfs.zip \
    && echo "ZIP is valid"

COPY otp-config.json .
COPY router-config.json .

RUN /docker-entrypoint.sh --build --save

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
