# PySpark transformations and output formats

This assignment applies common Spark DataFrame operations to a transaction dataset, including selection, filtering, type conversion, derived values, aggregation, and file output.

## Processing sequence

1. Read `data/source.csv` with inferred column types.
2. Select required fields and isolate Electronics records.
3. Rename and cast relevant columns.
4. Calculate `final_price` by applying 18% tax to the base price.
5. Filter completed high-value orders, records with known users, and records meeting regional or priority conditions.
6. Count records by category.
7. Write summary data to CSV and detail data to Parquet.
8. Read the Parquet output again to confirm it was written successfully.
