# Employee data processing with PySpark

This notebook uses Spark DataFrames to prepare and examine an employee dataset.

## Workflow

1. Start a local Spark session and read `Employee.csv`.
2. Inspect the imported schema and record count.
3. Remove repeated rows and replace selected missing values with documented defaults.
4. Convert analysis fields to numeric types and keep employees aged 25 or above with usable location data.
5. Calculate summary measures and group results by education and gender.
6. Export the cleaned data and aggregate results as CSV output.

## Spark concepts shown

The notebook illustrates immutable DataFrame transformations, the difference between row-local filtering and shuffle-based grouping, and the way Spark delays execution until an action needs a result.

## Layout

```text
Assessment 5/
├── Employee.csv
└── spark-assignment/
    ├── notebook/spark_basics.ipynb
    └── output/
```
