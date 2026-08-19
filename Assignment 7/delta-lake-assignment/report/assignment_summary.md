# Delta MERGE assignment overview

## Purpose

The assignment demonstrates how Spark and Delta Lake can apply an incremental batch to an existing table.

## Inputs and preparation

- `Sample - Superstore.csv` supplies the original records.
- `superstore_incremental.csv` supplies changed and newly added records.
- Source column names are made compatible with Delta storage, key columns are clarified, duplicate entries are removed, and missing city or state values are completed.

## Merge behaviour

The MERGE matches records using the identifier. A matching row receives the new values, while a previously unseen identifier becomes a new row. This is a Type 1 SCD process, so it keeps only the latest version rather than preserving earlier history.

## Checks and result

After the merge, the notebook displays the resulting Delta table and tests both the row total and the count of duplicate identifiers. The final validation confirms that the update and insert paths completed successfully.
