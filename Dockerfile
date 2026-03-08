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

# Print the existing ENTRYPOINT script so we know what it calls
RUN echo "=== /docker-entrypoint.sh ===" && cat /docker-entrypoint.sh 2>/dev/null; \
    echo "=== /entrypoint.sh ===" && cat /entrypoint.sh 2>/dev/null; \
    echo "=== /usr/local/bin ===" && ls -la /usr/local/bin/ 2>/dev/null; \
    echo "=== /opt ===" && ls -la /opt/ 2>/dev/null; \
    echo "=== find jars ===" && find / -name "*.jar" -not -path "*/proc/*" -not -path "*/sys/*" 2>/dev/null; \
    echo "=== find sh scripts ===" && find /usr /opt /app -name "*.sh" 2>/dev/null; \
    echo "DONE"

EXPOSE 8080
