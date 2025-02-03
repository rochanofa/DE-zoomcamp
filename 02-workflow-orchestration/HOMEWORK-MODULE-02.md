## Question 1. 
Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

#### Answer: 128.3 MB

- Output of CSV was generated after executing ``02_postgres_taxi.yaml`` flow
- To allow file preview and storing CSV disable the purge-files task
- To see the file size go to Outputs tab - Task - extract - output files - CSV file
```
Debug outputs:
kestra:///zoomcamp/02-postgres-taxi/executions/3sOn2C8KidVcKWyqkjdyGe/tasks/extract/12P2R2j65zshAvljx0FjAF/1XKWRJdLCVrKZFvjqobAHt-yellow_tripdata_2020-12.csv

```
![ketra-output-filesize](https://github.com/user-attachments/assets/ab7c27b4-bc2e-42d6-89d9-e0367a702ece)


## Question 2. 
What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

#### Answer: green_tripdata_2020-04.csv

Kestra variable on ``02_postgres_taxi.yaml`` :
```
variables:
  file: "{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv"
  staging_table: "public.{{inputs.taxi}}_tripdata_staging"
  table: "public.{{inputs.taxi}}_tripdata"
  data: "{{outputs.extract.outputFiles[inputs.taxi ~ '_tripdata_' ~ inputs.year ~ '-' ~ inputs.month ~ '.csv']}}"
```


## Question 3. 
How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

#### Answer: 24,648,499
- Execute flow of ``02_postgres_taxi_scheduled.yaml`` file and add **backfill** trigger for 2020 yellow taxi data (add label ``backfill=true`` to distinguish backfill and real time dataflow)

![backfill-yellow-2020](https://github.com/user-attachments/assets/b17c0cb2-bb2f-4635-a76c-ca68193133f2)

- Once the data is ingested to Postgres run the SQL code (i used PgAdmin)

**SQL code**
```
SELECT COUNT (*) FROM public.yellow_tripdata
WHERE filename LIKE 'yellow_tripdata_2020-%';

```

## Question 4. 
How many rows are there for the Green Taxi data for all CSV files in the year 2020?

#### Answer: 1,734,051
- Execute flow of ``02_postgres_taxi_scheduled.yaml`` file and add **backfill** trigger for 2020 green taxi data (add label ``backfill=true`` to distinguish backfill and real time dataflow)

![backfill-green2020](https://github.com/user-attachments/assets/9de686ab-8a61-44b8-b358-863ed969c1f3)


- Once the data is ingested to Postgres run the SQL code (i used PgAdmin)

**SQL code**
```
SELECT COUNT (*) FROM public.green_tripdata
WHERE filename LIKE 'green_tripdata_2020-%';

```

## Question 5. 
How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

#### Answer: 1,925,152
- Execute flow of ``02_postgres_taxi_scheduled.yaml`` file and add **backfill** trigger for 2021 yellow taxi data (add label ``backfill=true`` to distinguish backfill and real time dataflow)
![backfill-yellow-2021](https://github.com/user-attachments/assets/afbd8a2e-9d85-4a32-b37f-e3465b45143e)
- Alternatively, you can execute flow of 02_postgres_taxi.yaml and add inputs ``taxi=yellow``, ``year=2021``,``month=03``
  but modify the configuration for input just like this:
  ```
  inputs:
  - id: taxi
    type: SELECT
    displayName: Select taxi type
    values: [ yellow, green ]
    defaults: yellow

  - id: year
    type: SELECT
    displayName: Select year
    values: [ "2019", "2020", "2021" ]
    defaults: "2019"

  - id: month
    type: SELECT
    displayName: Select month
    values: [ "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12" ]
    defaults: "01"
  ```
- Once the data is ingested to Postgres run the SQL code (i used PgAdmin)

**SQL code**
```
SELECT COUNT (*)
FROM yellow_tripdata
WHERE filename='yellow_tripdata_2021-03.csv';
```

## Question 6. 
How would you configure the timezone to New York in a Schedule trigger?
#### Answer: Add a timezone property set to America/New_York in the Schedule trigger configuration

**Example on Kestra documentation: [Kestra scheduler doc](https://kestra.io/docs/workflow-components/triggers/schedule-trigger)**

```
triggers:
  - id: daily
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "@daily"
    timezone: America/New_York
```



