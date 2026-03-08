FROM opentripplanner/opentripplanner:2.5.0 AS builder

USER root

# Install curl for downloading data
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /var/opentripplanner

# Download Ottawa OSM street data (Geofabrik - Ottawa region extract)
RUN curl -L "https://download.geofabrik.de/north-america/canada/ontario-latest.osm.pbf" \
    -o ontario.osm.pbf

# Download OC Transpo GTFS feed (-k bypasses self-signed cert issue)
RUN curl -kL "https://www.octranspo.com/files/google_transit.zip" \
    -o google_transit.zip

# Find the OTP jar and build the routing graph
RUN OTP_JAR=$(find / -name "otp-*.jar" 2>/dev/null | head -1) && \
    echo "Found OTP jar at: $OTP_JAR" && \
    java -Xmx2G -jar "$OTP_JAR" --build --save .

# ── Final image ──
FROM opentripplanner/opentripplanner:2.5.0

USER root
WORKDIR /var/opentripplanner

# Copy the built graph from builder stage
COPY --from=builder /var/opentripplanner/graph.obj .

# Expose OTP port
EXPOSE 8080

# Start OTP in serve mode (graph already built)
CMD ["--load", "--serve"]
