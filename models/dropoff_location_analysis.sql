WITH ny_taxi_zones AS (

  SELECT * 
  
  FROM {{ ref('ny_taxi_zones')}}

),

filter_null_dropoff_borough AS (

  {#Filters New York taxi zones by borough, excluding those with unknown or N/A borough values.#}
  SELECT * 
  
  FROM ny_taxi_zones AS in0
  
  WHERE DOBorough not in ('N/A', 'Unknown')

),

filter_January_dropoff_dates AS (

  {#Filters data by borough and dropoff date within a specific time range.#}
  SELECT * 
  
  FROM filter_null_dropoff_borough AS in0
  
  WHERE dropoff_date >= '2024-01-01' AND dropoff_date <= '2024-01-31'

),

aggregate_by_dropoff_date_and_borough AS (

  {#Aggregates the number of rides by dropoff date and borough.#}
  SELECT 
    any_value(dropoff_date) AS dropoff_date,
    any_value(DOBorough) AS DOBorough,
    COUNT(*) AS Rides
  
  FROM filter_January_dropoff_dates AS in0
  
  GROUP BY 
    dropoff_date, DOBorough

),

order_by_dropoff_date AS (

  {#Sorts rides by drop-off date in ascending order.#}
  SELECT * 
  
  FROM aggregate_by_dropoff_date_and_borough AS in0
  
  ORDER BY dropoff_date ASC

)

SELECT *

FROM order_by_dropoff_date
