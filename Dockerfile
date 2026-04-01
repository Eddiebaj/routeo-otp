FROM opentripplanner/opentripplanner:2.5.0

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/opentripplanner
WORKDIR /var/opentripplanner

COPY graph.obj .
COPY otp-config.json .
COPY router-config.json .

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh", "--load", "--serve"]
