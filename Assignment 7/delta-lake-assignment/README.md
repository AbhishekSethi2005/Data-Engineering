# Delta Lake Type 1 update workflow

This project uses Apache Spark and Delta Lake to maintain a customer table from an initial CSV file and a later incremental file. The update follows Type 1 slowly changing-dimension behaviour: a matching customer is replaced with the latest values, while a new customer is added.

## Project structure

```text
delta-lake-assignment/
├── data/                         # Initial and incremental CSV inputs
├── notebooks/delta_scd_assignment.ipynb
├── screenshots/                  # Evidence from notebook execution
├── verify_delta_merge.py         # Separate validation run
└── README.md
```

## Processing outline

1. Read the source records and make their column names Delta-safe.
2. Standardize identifier fields, remove duplicate keys, and address missing location values.
3. Save the cleansed initial data as a Delta table.
4. Merge the incremental records by identifier, overwriting matched attributes and inserting unmatched records.
5. Confirm the final table has the expected row count and no repeated identifiers.

## Verification

With Python, Java, and the Delta dependencies configured, run:

```powershell
python verify_delta_merge.py
```

The expected checks are `row_count= 4` and `duplicate_ids= 0`.
