# Superstore relational analysis

This assignment turns a flat Superstore transaction extract into a relational SQL model and uses that model for sales and customer analysis.

## Design

The script stages the raw records and separates them into `customers`, `products`, `orders`, and `order_details`. This structure keeps customer, product, order-header, and line-item data at their appropriate levels of detail.

## Techniques demonstrated

- `SELECT DISTINCT` to build non-duplicated dimension records
- joins, subqueries, and common table expressions for business questions
- ranking and recency analysis with window functions
- customer segmentation with `NTILE(4)`

## Insights explored

The queries identify customers whose spending is above the overall average, distinguish sales volume from profit, highlight customers with only one purchase, and rank customer performance by category and market segment.

## Included file

- `superstore_advanced_sql.sql` — database creation, normalization, and analytical queries
