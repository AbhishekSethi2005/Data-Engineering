# Project evidence gallery

The images below document the main checks and deliverables from each pipeline stage.

## Phase 1: ingestion and Bronze storage

### Workspace and raw inputs

![Raw input directories](screenshots/phase1/raw_folder_structure1.png)
![Raw input directories](screenshots/phase1/raw_folder_structure2.png)
![Raw input directories](screenshots/phase1/raw_folder_structure3.png)
![Raw input directories](screenshots/phase1/raw_folder_structure4.png)

### Landing conversion and audit checks

![Landing Parquet output](screenshots/phase1/landing_parquet1.png)
![Landing Parquet output](screenshots/phase1/landing_parquet2.png)
![Landing Parquet output](screenshots/phase1/landing_parquet3.png)
![Successful audit check](screenshots/phase1/audit_pass1.png)
![Successful audit check](screenshots/phase1/audit_pass2.png)
![Successful audit check](screenshots/phase1/audit_pass3.png)

### Bronze results

![Bronze Delta table](screenshots/phase1/bronze_delta1.png)
![Bronze Delta table](screenshots/phase1/bronze_delta2.png)
![Bronze count check](screenshots/phase1/bronze_row_counts1.png)
![Bronze count check](screenshots/phase1/bronze_row_counts2.png)

## Phase 2: Silver transformations

### Change-history and MERGE processing

![Customer Type 2 history](screenshots/phase2/customer_scd_type2-1.png)
![Customer Type 2 history](screenshots/phase2/customer_scd_type2-2.png)
![Customer Type 2 history](screenshots/phase2/customer_scd_type2-3.png)
![Product Type 1 update](screenshots/phase2/product_scd_type1-1.png)
![Product Type 1 update](screenshots/phase2/product_scd_type1-2.png)
![Product Type 1 update](screenshots/phase2/product_scd_type1-3.png)
![Delta MERGE result](screenshots/phase2/merge_operation1.png)
![Delta MERGE result](screenshots/phase2/merge_operation2.png)
![Delta MERGE result](screenshots/phase2/merge_operation3.png)

### Data-quality and Silver outputs

![Duplicate-record check](screenshots/phase2/duplicate_removal1.png)
![Duplicate-record check](screenshots/phase2/duplicate_removal2.png)
![Duplicate-record check](screenshots/phase2/duplicate_removal3.png)
![Surrogate-key creation](screenshots/phase2/surrogate_keys1.png)
![Surrogate-key creation](screenshots/phase2/surrogate_keys2.png)
![Surrogate-key creation](screenshots/phase2/surrogate_keys3.png)
![Surrogate-key creation](screenshots/phase2/surrogate_keys4.png)
![Surrogate-key creation](screenshots/phase2/surrogate_keys5.png)
![Silver customer table](screenshots/phase2/silver_customer1.png)
![Silver product table](screenshots/phase2/silver_customer2.png)
![Silver sales table](screenshots/phase2/silver_customer3.png)

## Phase 3: Gold model and KPIs

### Star schema and published tables

![Gold star schema](screenshots/phase3/star_schema.png)
![Customer dimension](screenshots/phase3/dim_customer1.png)
![Customer dimension](screenshots/phase3/dim_customer2.png)
![Product dimension](screenshots/phase3/dim_product1.png)
![Product dimension](screenshots/phase3/dim_product2.png)
![Product dimension](screenshots/phase3/dim_product3.png)
![Promotion dimension](screenshots/phase3/dim_promotion1.png)
![Promotion dimension](screenshots/phase3/dim_promotion2.png)
![Date dimension](screenshots/phase3/dim_date1.png)
![Date dimension](screenshots/phase3/dim_date2.png)
![Sales fact table](screenshots/phase3/fact_sales1.png)
![Sales fact table](screenshots/phase3/fact_sales2.png)
![Unity Catalog registration](screenshots/phase3/unity_catalog_gold_tables.png)

### KPI evidence

![Regional sales measure](screenshots/phase3/kpi_net_margin_region.png)
![Promotion AOV measure](screenshots/phase3/kpi_aov_promotion.png)
![Customer churn comparison](screenshots/phase3/kpi_churn_heatmap.png)
![Product quality score](screenshots/phase3/kpi_product_quality.png)
![Hourly store traffic](screenshots/phase3/kpi_store_traffic.png)

## Phase 4: final tests

### Pipeline and repeatability checks

![End-to-end run](screenshots/phase4/end_to_end_validation1.png)
![End-to-end run](screenshots/phase4/end_to_end_validation2.png)
![End-to-end run](screenshots/phase4/end_to_end_validation3.png)
![End-to-end run](screenshots/phase4/end_to_end_validation4.png)
![End-to-end run](screenshots/phase4/end_to_end_validation5.png)
![Idempotency check](screenshots/phase4/idempotency_test1.png)
![Idempotency check](screenshots/phase4/idempotency_test2.png)
![Idempotency check](screenshots/phase4/idempotency_test3.png)
![Idempotency check](screenshots/phase4/idempotency_test4.png)
![Idempotency check](screenshots/phase4/idempotency_test5.png)
![Idempotency check](screenshots/phase4/idempotency_test6.png)

### Failure, duplicate, and completion evidence

![Audit failure handling](screenshots/phase4/audit_failure_test1.png)
![Audit failure handling](screenshots/phase4/audit_failure_test2.png)
![Audit failure handling](screenshots/phase4/audit_failure_test3.png)
![Audit failure handling](screenshots/phase4/audit_failure_test4.png)
![Audit failure handling](screenshots/phase4/audit_failure_test5.png)
![Audit failure handling](screenshots/phase4/audit_failure_test6.png)
![Audit failure handling](screenshots/phase4/audit_failure_test7.png)
![Duplicate validation](screenshots/phase4/duplicate_validation1.png)
![Duplicate validation](screenshots/phase4/duplicate_validation2.png)
![Duplicate validation](screenshots/phase4/duplicate_validation3.png)
![Duplicate validation](screenshots/phase4/duplicate_validation4.png)
![Duplicate validation](screenshots/phase4/duplicate_validation5.png)
![Duplicate validation](screenshots/phase4/duplicate_validation6.png)
![Final validation summary](screenshots/phase4/final_summary1.png)
![Final validation summary](screenshots/phase4/final_summary2.png)
![Final validation summary](screenshots/phase4/final_summary3.png)
![Final validation summary](screenshots/phase4/final_summary4.png)
![Final validation summary](screenshots/phase4/final_summary5.png)
![Final validation summary](screenshots/phase4/final_summary6.png)
![Final validation summary](screenshots/phase4/final_summary7.png)
![Final validation summary](screenshots/phase4/final_summary8.png)
![Completed project](screenshots/phase4/project_completion.png)
