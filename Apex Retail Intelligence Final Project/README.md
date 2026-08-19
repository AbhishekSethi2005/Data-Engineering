# Apex Retail Intelligence Lakehouse

This project delivers a retail analytics pipeline in Databricks using PySpark, Delta Lake, and Unity Catalog. It moves source data through Raw, Landing, Bronze, Silver, and Gold layers, then produces validated analytical tables and business measures.

## Goals

- Preserve incoming retail data before applying transformations.
- Reconcile each load against audit expectations and stop processing on failed checks.
- Create dependable Delta tables with clear history and deduplication rules.
- Apply Type 2 history tracking to customers and Type 1 overwrites to products.
- Publish a dimensional model that supports reporting and KPI analysis.
- Demonstrate repeatable pipeline runs and data-quality validation.

## Tools and services

| Area | Implementation |
|---|---|
| Compute | Databricks serverless runtime |
| Processing | PySpark and Databricks SQL |
| Storage | Databricks Volumes, Parquet, and Delta Lake |
| Governance | Unity Catalog |
| Modelling approach | Medallion lakehouse and star schema |

## Data flow

```text
CSV source files
  → Landing Parquet with audit reconciliation
  → Bronze append-only Delta tables
  → Silver validated Delta tables with SCD rules
  → Gold dimensions and fact table
  → KPIs and validation evidence
```

### Layer responsibilities

- **Raw** retains source files in their received form and separates historical from incremental batches.
- **Landing** converts source records to Parquet and compares expected and actual row counts.
- **Bronze** stores append-only Delta data with ingestion timestamps.
- **Silver** enforces key, type, null, duplicate, and SCD rules.
- **Gold** exposes `dim_customer`, `dim_product`, `dim_promotion`, `dim_date`, and `fact_sales` for analysis.

## Pipeline modules

| Script | Responsibility |
|---|---|
| `01_Raw_Landing_Audit.py` | Raw file organisation, Landing conversion, audits, and Bronze loading |
| `02_Silver_Transformation_MERGE_SCD.py` | Silver transformations, MERGE operations, SCD logic, and surrogate keys |
| `03_Gold_StarSchema_KPIs.py` | Gold star schema, Unity Catalog registration, and KPIs |
| `04_Final_Validation_Testing.py` | End-to-end, idempotency, quality, and compliance checks |

## Controls included

The project checks audit totals, duplicate business keys, primary-key nulls, type conformance, valid value ranges, surrogate-key uniqueness, and Gold foreign-key relationships. The final validation also tests repeatability and verifies that Bronze remains append-only.

## Key analytics

The Gold layer supports sales by region, average order value by promotion, demographic churn comparisons, product quality scoring, and store traffic by hour. Because the input does not contain product cost, regional total sales is used as the available proxy for margin-oriented reporting.

## Evidence and report

- [Screenshot evidence](Images.md) records each project phase.
- `Apex_Retail_Intelligence_Final_Project_Report.pdf` contains the submitted project report.
- `Celebal Architecture.png` shows the solution architecture.

## Execution order

Run the four Databricks modules in numbered order. Each stage requires its upstream tables and audit outputs, so the validation module should run only after the Gold tables are available.
