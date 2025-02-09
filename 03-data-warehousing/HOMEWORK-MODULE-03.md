## Question 1. 
What is count of records for the 2024 Yellow Taxi Data?

#### Answer: 20,332,093

**SQL QUERY**
```
SELECT count(*) FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`;
```

## Question 2. 
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

#### Answer: 0 MB for the External Table and 155.12 MB for the Materialized Table

It is due to an external table is not stored within BigQuery.
**SQL QUERY**
```
--create regular table
CREATE OR REPLACE TABLE `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`
AS SELECT * FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`;

--count distinct
SELECT COUNT(DISTINCT(PULocationID)) FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`;
SELECT COUNT(DISTINCT(PULocationID)) FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;
```


## Question 3. 
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

#### Answer: BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

**SQL QUERY**
```
SELECT PULocationID FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;
SELECT PULocationID,DOLocationID FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`;
```

## Question 4. 
How many records have a fare_amount of 0?

#### Answer: 8,333

**SQL QUERY**
```
SELECT COUNT (fare_amount) 
FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`
WHERE fare_amount = 0;

```

## Question 5. 
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

#### Answer: Partition by tpep_dropoff_datetime and Cluster on VendorID

**SQL QUERY**
```
CREATE OR REPLACE TABLE `dezoomcamp-447712.ny_taxi.yellow_partitioned_tripdata`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS (
  SELECT * FROM `dezoomcamp-447712.ny_taxi.yellow_tripdata`
);
```

## Question 6. 
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

Choose the answer which most closely matches

#### Answer: 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

**SQL QUERY**

```
SELECT DISTINCT(VendorID) 
FROM `dezoomcamp-447712.ny_taxi.yellow_nonpartitioned_tripdata`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT(VendorID) 
FROM `dezoomcamp-447712.ny_taxi.yellow_partitioned_tripdata`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
```
## Question 7. 
Where is the data stored in the External Table you created?

#### Answer: GCP Bucket

## Question 8. 
It is best practice in Big Query to always cluster your data:

#### Answer: False
Not always, for small size table the benefit for clustering is not significant, also to reduce cost once partitioning is sufficient, clustering is not necessary.

## Question 9 (bonus). 
Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
#### Answer: 0 byte

WHY? 
Because when executing ``SELECT COUNT (*)`` BigQuery retrieves the row count from metadata, which costs 0 bytes.



