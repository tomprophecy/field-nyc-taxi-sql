WITH ny_taxi_zones AS (

  SELECT * 
  
  FROM {{ ref('ny_taxi_zones')}}

),

filter_null_pickup_locations AS (

  {#Filters out null or unknown pickup locations from the New York taxi zones dataset.#}
  SELECT * 
  
  FROM ny_taxi_zones AS in0
  
  WHERE PUBorough not in ('N/A', 'Unknown')

),

filter_January_2024 AS (

  {#Filters records with non-null pickup locations for the month of January 2024.#}
  SELECT * 
  
  FROM filter_null_pickup_locations AS in0
  
  WHERE pickup_date >= '2024-01-01' AND pickup_date <= '2024-01-31'

),

rides_per_month AS (

  {#Calculates the number of rides per month for each pickup date and public borough.#}
  SELECT 
    any_value(pickup_date) AS pickup_date,
    any_value(PUBorough) AS PUBorough,
    COUNT(*) AS rides
  
  FROM filter_January_2024 AS in0
  
  GROUP BY 
    pickup_date, PUBorough

),

rides_per_month_ordered AS (

  {#Orders the rides per month data by pickup date in ascending order.#}
  SELECT * 
  
  FROM rides_per_month AS in0
  
  ORDER BY pickup_date ASC

)

SELECT *

FROM rides_per_month_ordered
