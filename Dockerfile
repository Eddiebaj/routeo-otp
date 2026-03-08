FROM opentripplanner/opentripplanner:2.5.0

USER root

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Use /data (not /var/opentripplanner which is a VOLUME and gets wiped)
WORKDIR /data

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o google_transit.zip

COPY otp-config.json .
COPY router-config.json .

# Build graph at build time into /data (not the VOLUME path)
RUN /docker-entrypoint.sh --build --save /data

# Write startup script that copies graph then serves
RUN printf '#!/bin/sh\ncp -r /data/* /var/opentripplanner/\nexec /docker-entrypoint.sh --load --serve\n' \
    > /start.sh && chmod +x /start.sh

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "/start.sh"]
