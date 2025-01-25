## Question 1. Understanding docker first run
Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.
What's the version of pip in the image?

```
Run this following command to run docker

$docker run -it --entrypoint bash python:3.12.8

Once inside docker container run:
$pip --version

```

**Answer: 24.2.1**

## Question 2. Understanding Docker networking and docker-compose
Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?
```
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

**Answer: postgres:5432**

## Question 3. Trip Segmentation Count
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

Up to 1 mile
In between 1 (exclusive) and 3 miles (inclusive),
In between 3 (exclusive) and 7 miles (inclusive),
In between 7 (exclusive) and 10 miles (inclusive),
Over 10 miles

**SQL code**
```
SELECT 
    CASE
        WHEN trip_distance <= 1 THEN '0-1 mile'
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1-3 miles'
        WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3-7 miles'
        WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7-10 miles'
        ELSE 'Over 10 miles'
    END AS distance_category,
    COUNT(*) AS trip_count
FROM green_taxi_trips t
WHERE CAST(lpep_dropoff_datetime AS DATE) >= '2019-10-01' 
  AND CAST(lpep_dropoff_datetime AS DATE) < '2019-11-01'
GROUP BY 
    CASE
        WHEN trip_distance <= 1 THEN '0-1 mile'
        WHEN trip_distance > 1 AND trip_distance <= 3 THEN '1-3 miles'
        WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3-7 miles'
        WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7-10 miles'
        ELSE 'Over 10 miles'
    END
ORDER BY distance_category;

```

**Answer: 104,802; 198,924; 109,603; 27,678; 35,189**

## Question 4. Trip Segmentation Count
Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.
**SQL Code**
```
SELECT
    CAST(lpep_pickup_datetime AS DATE) AS "pickday",
    MAX(trip_distance) AS longest_trip_distance
FROM 
    green_taxi_trips t
GROUP BY
    CAST(lpep_pickup_datetime AS DATE)
ORDER BY
    longest_trip_distance DESC
LIMIT 1;

```
**Answer: 2019-10-31**

## Question 5. Three biggest pickup zones
Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

**SQL code**

```
SELECT
    zpu."Zone",
    SUM(t.total_amount) AS total_amount_sum
FROM
    green_taxi_trips t
JOIN 
    zones zpu ON t."PULocationID" = zones."LocationID"
WHERE 
    DATE(t.lpep_pickup_datetime) = '2019-10-18'
GROUP BY 
	zpu."Zone"
HAVING 
    SUM(t.total_amount) > 13000
ORDER BY 
    total_amount_sum DESC;

```
**Answer: East Harlem North, East Harlem South, Morningside Heights**

## Question 6. Largest tip
For the passengers picked up in October 2019 in the zone named "East Harlem North" which was the drop off zone that had the largest tip?
**SQL code**

```
SELECT
    zpu."Zone" AS pickup_zone,
	zdo."Zone" AS dropoff_zone,
    MAX(t.tip_amount) AS max_tip
FROM
    green_taxi_trips t
JOIN
    zones zpu ON t."PULocationID" = zpu."LocationID"
JOIN
	zones zdo ON t."DOLocationID" = zdo."LocationID"
WHERE
    DATE(t.lpep_pickup_datetime) BETWEEN '2019-10-01' AND '2019-10-31'
	AND zpu."Zone"='East Harlem North'
GROUP BY
	pickup_zone,
    dropoff_zone
ORDER BY
    max_tip DESC;
```

**Answer: JFK Airport**

## Question 7. Terraform Workflow
Which of the following sequences, respectively, describes the workflow for:

Downloading the provider plugins and setting up backend,
Generating proposed changes and auto-executing the plan
Remove all resources managed by terraform`


```
#Run command
# Refresh service-account's auth-token for this session
gcloud auth application-default login

# Initialize state file (.tfstate)
terraform init

# Check changes to new infra plan
terraform plan -var="project=terraform-trial-448907"

#Output:
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/google versions matching "6.17.0"...
- Installing hashicorp/google v6.17.0...
- Installed hashicorp/google v6.17.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.
```
```
# Create new infra
terraform apply --auto-approve -var="project=terraform-trial-448907"

#Output:
Terraform used the      
selected providers to   
generate the following  
execution plan.
Resource actions are    
indicated with the      
following symbols:      
  + create

Terraform will perform the following actions:   

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + force_destroy               = true      
      + id              
            = (known after apply)
      + location                    = "US"      
      + name            
            = "terraform-trial-448907-terra-bucket"
      + project         
            = (known after apply)
      + project_number              = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo             
            = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + uniform_bucket_level_access = (known after apply)
      + url             
            = (known after apply)

      + lifecycle_rule {
          + action {    
              + type          = "Delete"        
                # (1 unchanged attribute hidden)
            }
          + condition { 
              + age                    = 3      
              + matches_prefix         = []     
              + matches_storage_class  = []     
              + matches_suffix         = []     
              + with_state             = (known after apply)
                # (3 unchanged attributes hidden)
            }
        }
      + lifecycle_rule {
          + action {    
              + type          = "AbortIncompleteMultipartUpload"        
                # (1 unchanged attribute hidden)
            }
          + condition { 
              + age                    = 1      
              + matches_prefix         = []     
              + matches_storage_class  = []     
              + matches_suffix         = []     
              + with_state             = (known after apply)
                # (3 unchanged attributes hidden)
            }
        }

      + soft_delete_policy (known after apply)  

      + versioning (known after apply)

      + website (known after apply)
    }

```
```
# Delete infra after your work, to avoid costs on any running services
terraform destroy

#Output:
google_storage_bucket.demo-bucket: Destroying... [id=terraform-trial-448907-terra-bucket]
google_storage_bucket.demo-bucket: Destruction complete after 1s
```

**Answer: terraform init, terraform apply -auto-approve, terraform destroy**
