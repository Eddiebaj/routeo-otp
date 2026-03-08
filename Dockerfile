FROM opentripplanner/opentripplanner:2.5.0

USER root

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /var/opentripplanner

# Download Ottawa OSM street data
RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

# Download OC Transpo GTFS feed
RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o google_transit.zip

# Copy OTP config files
COPY otp-config.json .
COPY router-config.json .

EXPOSE 8080

# Diagnostic: show what the existing entrypoint does, find jars/scripts
RUN cat /docker-entrypoint.sh 2>/dev/null || \
    cat /entrypoint.sh 2>/dev/null || \
    find / -name "*.sh" -not -path "*/proc/*" 2>/dev/null | head -20 && \
    find / -name "*.jar" -not -path "*/proc/*" 2>/dev/null | head -10
