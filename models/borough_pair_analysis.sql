WITH ny_taxi_zones AS (

  SELECT * 
  
  FROM {{ ref('ny_taxi_zones')}}

),

taxi_zones_not_na_unknown AS (

  {#Filters out taxi zones with boroughs labeled as 'N/A' or 'Unknown'.#}
  SELECT * 
  
  FROM ny_taxi_zones AS in0
  
  WHERE PUBorough not in ('N/A', 'Unknown') AND DOBorough not in ('N/A', 'Unknown')

),

taxi_ride_details AS (

  {#Calculates ride details including ride time and speed for taxi rides.#}
  SELECT 
    PUBorough AS PUBorough,
    DOBorough AS DOBorough,
    ((UNIX_TIMESTAMP(dropoff_datetime) - UNIX_TIMESTAMP(pickup_datetime)) / 60) AS ride_time,
    trip_distance AS trip_distance,
    trip_distance / (((UNIX_TIMESTAMP(dropoff_datetime) - UNIX_TIMESTAMP(pickup_datetime)) / 60) / 60) AS ride_speed
  
  FROM taxi_zones_not_na_unknown AS in0

),

avg_ride_details_by_boroughs AS (

  {#Calculates average ride details (time, distance, speed) for each combination of pickup and drop-off boroughs.#}
  SELECT 
    any_value(PUBorough) AS PUBorough,
    any_value(DOBorough) AS DOBorough,
    avg(ride_time) AS avg_time,
    avg(trip_distance) AS avg_distance,
    avg(ride_speed) AS avg_speed
  
  FROM taxi_ride_details AS in0
  
  GROUP BY 
    PUBorough, DOBorough

)

SELECT *

FROM avg_ride_details_by_boroughs
