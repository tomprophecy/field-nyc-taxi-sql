

WITH pu_zones AS (

  SELECT * 
  
  FROM {{ source('tom.ny_taxi', 'zones') }}

),

combined_taxi_data AS (

  SELECT * 
  
  FROM {{ source('tom.ny_taxi', 'combined_taxi_data') }}

),

taxi_data_with_zones AS (

  {#Combines taxi trip data with corresponding pickup zone information for analysis and reporting.#}
  SELECT 
    in0.VendorID AS VendorID,
    in0.pickup_datetime AS pickup_datetime,
    in0.dropoff_datetime AS dropoff_datetime,
    in0.passenger_count AS passenger_count,
    in0.trip_distance AS trip_distance,
    in0.RatecodeID AS RatecodeID,
    in0.store_and_fwd_flag AS store_and_fwd_flag,
    in0.PULocationID AS PULocationID,
    in1.Borough AS PUBorough,
    in1.Zone AS PUZone,
    in1.service_zone AS PUservice_zone,
    in0.DOLocationID AS DOLocationID,
    in0.payment_type AS payment_type,
    in0.fare_amount AS fare_amount,
    in0.extra AS extra,
    in0.mta_tax AS mta_tax,
    in0.tip_amount AS tip_amount,
    in0.tolls_amount AS tolls_amount,
    in0.improvement_surcharge AS improvement_surcharge,
    in0.total_amount AS total_amount,
    in0.congestion_surcharge AS congestion_surcharge,
    in0.taxi_type AS taxi_type,
    in0.year AS year,
    in0.month AS month,
    in0.pickup_date AS pickup_date,
    in0.dropoff_date AS dropoff_date,
    in1.LocationID AS LocationID,
    in1.Borough AS Borough,
    in1.Zone AS Zone,
    in1.service_zone AS service_zone
  
  FROM combined_taxi_data AS in0
  INNER JOIN pu_zones AS in1
     ON in0.PULocationID = in1.LocationID

),

do_zones AS (

  SELECT * 
  
  FROM {{ source('tom.ny_taxi', 'zones') }}

),

taxi_data_with_zones_and_do_zones AS (

  {#Combines taxi trip data with pickup and drop-off zone information for further analysis.#}
  SELECT 
    in0.VendorID AS VendorID,
    in0.pickup_datetime AS pickup_datetime,
    in0.dropoff_datetime AS dropoff_datetime,
    in0.passenger_count AS passenger_count,
    in0.trip_distance AS trip_distance,
    in0.RatecodeID AS RatecodeID,
    in0.store_and_fwd_flag AS store_and_fwd_flag,
    in0.PULocationID AS PULocationID,
    in0.PUBorough AS PUBorough,
    in0.PUZone AS PUZone,
    in0.PUservice_zone AS PUservice_zone,
    in0.DOLocationID AS DOLocationID,
    in1.Borough AS DOBorough,
    in1.Zone AS DOZone,
    in1.service_zone AS DOservice_zone,
    in0.payment_type AS payment_type,
    in0.fare_amount AS fare_amount,
    in0.extra AS extra,
    in0.mta_tax AS mta_tax,
    in0.tip_amount AS tip_amount,
    in0.tolls_amount AS tolls_amount,
    in0.improvement_surcharge AS improvement_surcharge,
    in0.total_amount AS total_amount,
    in0.congestion_surcharge AS congestion_surcharge,
    in0.taxi_type AS taxi_type,
    in0.year AS year,
    in0.month AS month,
    in0.pickup_date AS pickup_date,
    in0.dropoff_date AS dropoff_date
  
  FROM taxi_data_with_zones AS in0
  INNER JOIN do_zones AS in1
     ON in0.DOLocationID = in1.LocationID

)

SELECT *

FROM taxi_data_with_zones_and_do_zones
