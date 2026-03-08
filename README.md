# routeo-otp

OpenTripPlanner instance for RouteO — Ottawa transit trip planning.

## What this does

Runs [OpenTripPlanner](https://www.opentripplanner.org/) with:
- OC Transpo GTFS feed (bus + O-Train routes)
- Ontario OSM street data (walking directions)

Deployed on Railway. Provides a REST API used by the RouteO app for real transit routing.

## API

Once deployed, the trip planning endpoint is:

```
GET /otp/routers/default/plan
  ?fromPlace={lat},{lng}
  &toPlace={lat},{lng}
  &time={HH:mm}
  &date={MM-dd-yyyy}
  &mode=TRANSIT,WALK
  &numItineraries=5
```

## Deployment

Deployed via Railway using this repo. Railway builds the Docker image which:
1. Downloads OC Transpo GTFS + Ontario OSM data
2. Builds the OTP routing graph (~10-15 min build time)
3. Serves the OTP REST API on port 8080
