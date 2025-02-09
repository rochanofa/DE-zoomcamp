--BQ SETUP
CREATE EXTERNAL TABLE `dezoomcamp-447712.ny_taxi.yellow_tripdata`
OPTIONS ( 
  format = 'PARQUET',
  uris = ['gs://parquet2gcp-bucket-rocha/yellow_tripdata_2024-*.parquet']
);

--Q1 HW
SELECT count(*) FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`;


--Q2 HW
CREATE OR REPLACE TABLE `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`
AS SELECT * FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`;


SELECT COUNT(DISTINCT(PULocationID)) FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`;
SELECT COUNT(DISTINCT(PULocationID)) FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;

--Q3 HW
SELECT PULocationID FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;
SELECT PULocationID,DOLocationID FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;

--Q4 HW
SELECT COUNT (fare_amount) 
FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`
WHERE fare_amount = 0;

--Q5 HW
CREATE OR REPLACE TABLE `dezoomcamp-447712.ny_taxi.yellow_partitioned_tripdata`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS (
  SELECT * FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`
);

--Q6 HW
SELECT DISTINCT(VendorID) 
FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT(VendorID) 
FROM `dezoomcamp-447712.ny_taxi.yellow_partitioned_tripdata`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';


SELECT count(*) FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;
