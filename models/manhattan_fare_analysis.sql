WITH ny_taxi_zones AS (

  SELECT * 
  
  FROM {{ ref('ny_taxi_zones')}}

),

manhattan_zones AS (

  {#Filters and selects all taxi zones located in Manhattan.#}
  SELECT * 
  
  FROM ny_taxi_zones AS in0
  
  WHERE PUBorough = 'Manhattan'

),

Aggregate_1 AS (

  {#Calculates the number of rides and average total amount per borough in Manhattan.#}
  SELECT 
    any_value(DOBorough) AS DOBorough,
    COUNT(*) AS rides,
    AVG(total_amount) AS avg_total_amount
  
  FROM manhattan_zones AS in0
  
  GROUP BY DOBorough

)

SELECT *

FROM Aggregate_1
