FROM opentripplanner/opentripplanner:2.5.0

USER root

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /var/opentripplanner

RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o google_transit.zip

COPY otp-config.json .
COPY router-config.json .

# Write startup script: build graph then serve
RUN printf '#!/bin/sh\nset -e\notp --build --save /var/opentripplanner\nexec otp --load --serve /var/opentripplanner\n' > /start.sh \
    && chmod +x /start.sh

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "/start.sh"]
