FROM opentripplanner/opentripplanner:2.5.0@sha256:a8e8fa2dc7c97c48e0ed22c77cbc5c0b4dc7a31b9d72c4cc83a0ad953fcb61dd

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf
RUN curl -L "https://download.geofabrik.de/north-america/canada/quebec-latest.osm.pbf" \
    -o quebec.osm.pbf

ARG CACHE_BUST=3
COPY google_transit.zip oc-transpo-gtfs.zip
COPY sto-gtfs.zip sto-gtfs.zip
COPY otp-config.json .
COPY router-config.json .
COPY build-config.json .

# Patch STO GTFS: replace America/Montreal with America/Toronto in agency.txt
# OTP 2.5.0 treats them as different timezones despite identical offsets,
# which causes a build conflict when merged with OC Transpo's Canada/Eastern feed.
RUN apt-get update && apt-get install -y unzip zip && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /tmp/sto-patch \
 && unzip -q sto-gtfs.zip -d /tmp/sto-patch \
 && sed -i 's/America\/Montreal/America\/Toronto/g' /tmp/sto-patch/agency.txt \
 && (cd /tmp/sto-patch && zip -q -r /var/opentripplanner/sto-gtfs.zip .) \
 && rm -rf /tmp/sto-patch

ENV JAVA_OPTS="-Xmx12g"
RUN /docker-entrypoint.sh --build --save

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
