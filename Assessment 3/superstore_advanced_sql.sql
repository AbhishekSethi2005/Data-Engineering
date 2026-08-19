-- ==========================================
-- Build the normalized Superstore data model
-- ==========================================

CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS superstore_raw;

CREATE TABLE superstore_raw (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    ship_date VARCHAR(50),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

-- ==========================================
-- Create dimensions from distinct source values
-- ==========================================

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(50) NOT NULL
);

-- DISTINCT keeps the source extraction at its natural grain
INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM superstore_raw
WHERE customer_id IS NOT NULL;

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100) NOT NULL
);

INSERT INTO products (product_id, product_name, category, sub_category)
SELECT DISTINCT product_id, product_name, category, sub_category
FROM superstore_raw
WHERE product_id IS NOT NULL;

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE,
    customer_id VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (order_id, order_date, ship_date, customer_id, ship_mode)
SELECT order_id,
       STR_TO_DATE(MAX(order_date), '%c/%e/%Y') AS order_date,
       STR_TO_DATE(MAX(ship_date), '%c/%e/%Y') AS ship_date,
       MAX(customer_id) AS customer_id,
       MAX(ship_mode) AS ship_mode
FROM superstore_raw
WHERE order_id IS NOT NULL
GROUP BY order_id;

CREATE TABLE order_details (
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    sales DECIMAL(10,2) NOT NULL CHECK (sales >= 0),
    quantity INT NOT NULL CHECK (quantity > 0),
    discount DECIMAL(5,2) NOT NULL CHECK (discount BETWEEN 0 AND 1),
    profit DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_details (order_id, product_id, sales, quantity, discount, profit)
SELECT order_id,
       product_id,
       MAX(sales) AS sales,
       MAX(quantity) AS quantity,
       MAX(discount) AS discount,
       MAX(profit) AS profit
FROM superstore_raw
WHERE order_id IS NOT NULL AND product_id IS NOT NULL
GROUP BY order_id, product_id;

-- ==========================================
-- Part 3: subqueries and benchmark comparisons
-- ==========================================

SELECT order_id, product_id, ROUND(sales, 2) AS rounded_sales
FROM order_details
WHERE sales > (SELECT AVG(sales) FROM order_details)
ORDER BY sales DESC;

SELECT order_id, product_id, ROUND(sales, 2) AS maximum_sale
FROM order_details
WHERE sales = (SELECT MAX(sales) FROM order_details);

-- Compare every customer's revenue with the overall mean
WITH client_revenue_baseline AS (
    SELECT o.customer_id, ROUND(SUM(od.sales), 2) AS total_revenue
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, total_revenue
FROM client_revenue_baseline
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM client_revenue_baseline
)
ORDER BY total_revenue DESC;

-- ==========================================
-- Part 4: sales measures built with CTEs
-- ==========================================

-- Total sales for each customer
WITH client_revenue_baseline AS (
    SELECT o.customer_id, ROUND(SUM(od.sales), 2) AS total_revenue
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT *
FROM client_revenue_baseline
ORDER BY total_revenue DESC;

-- Overall average customer sales
WITH client_revenue_baseline AS (
    SELECT o.customer_id, SUM(od.sales) AS total_revenue
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT ROUND(AVG(total_revenue), 2) AS global_average_revenue
FROM client_revenue_baseline;

-- Customers whose total exceeds that benchmark
WITH client_revenue_baseline AS (
    SELECT o.customer_id, ROUND(SUM(od.sales), 2) AS total_revenue
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, total_revenue
FROM client_revenue_baseline
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM client_revenue_baseline
)
ORDER BY total_revenue DESC;

-- ==========================================
-- Part 5: window-function analysis
-- ==========================================

-- Rank customers using several performance measures
WITH client_revenue_baseline AS (
    SELECT o.customer_id, ROUND(SUM(od.sales), 2) AS total_revenue
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT customer_id,
       total_revenue,
       ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS row_sequence,
       RANK() OVER (ORDER BY total_revenue DESC) AS absolute_rank,
       DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS dense_rank_score
FROM client_revenue_baseline;

-- Identify the latest order for each customer
SELECT customer_id, order_id, order_date,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS transaction_sequence
FROM orders;

-- Rank each customer's highest-value orders
WITH customer_order_sales AS (
    SELECT o.customer_id, o.order_id, ROUND(SUM(od.sales), 2) AS total_order_sales
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id, o.order_id
)
SELECT customer_id, order_id, total_order_sales,
       RANK() OVER (PARTITION BY customer_id ORDER BY total_order_sales DESC) AS order_rank_index
FROM customer_order_sales;

-- ==========================================
-- Part 6: category and segment analysis
-- ==========================================

SELECT c.customer_name AS ClientName,
       p.category AS CategoryName,
       ROUND(SUM(od.sales), 2) AS CategorySalesRevenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_name, p.category
ORDER BY CategorySalesRevenue DESC;

-- ==========================================
-- Part 7: customer portfolio findings
-- ==========================================

-- Assemble combined customer value and rank measures
WITH customer_financial_summary AS (
    SELECT o.customer_id,
           ROUND(SUM(od.sales), 2) AS total_sales,
           ROUND(SUM(od.profit), 2) AS total_profit,
           COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
), ranked_consumer_profiles AS (
    SELECT c.customer_name,
           c.customer_id,
           c.segment,
           cfs.total_sales,
           cfs.total_profit,
           cfs.order_count,
           RANK() OVER (ORDER BY cfs.total_sales DESC) AS revenue_rank
    FROM customer_financial_summary cfs
    INNER JOIN customers c ON cfs.customer_id = c.customer_id
)
SELECT customer_name, customer_id, segment, total_sales, total_profit, order_count, revenue_rank
FROM ranked_consumer_profiles
ORDER BY revenue_rank;

-- Ten customers with the greatest value
WITH customer_financial_summary AS (
    SELECT o.customer_id,
           ROUND(SUM(od.sales), 2) AS total_sales,
           ROUND(SUM(od.profit), 2) AS total_profit,
           COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
), ranked_consumer_profiles AS (
    SELECT c.customer_name,
           c.customer_id,
           c.segment,
           cfs.total_sales,
           cfs.total_profit,
           cfs.order_count,
           RANK() OVER (ORDER BY cfs.total_sales DESC) AS revenue_rank
    FROM customer_financial_summary cfs
    INNER JOIN customers c ON cfs.customer_id = c.customer_id
)
SELECT *
FROM ranked_consumer_profiles
WHERE revenue_rank <= 10
ORDER BY revenue_rank;

-- Ten customers at the lower end of performance
WITH customer_financial_summary AS (
    SELECT o.customer_id,
           ROUND(SUM(od.sales), 2) AS total_sales,
           ROUND(SUM(od.profit), 2) AS total_profit,
           COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
), ranked_consumer_profiles AS (
    SELECT c.customer_name,
           c.customer_id,
           c.segment,
           cfs.total_sales,
           cfs.total_profit,
           cfs.order_count,
           RANK() OVER (ORDER BY cfs.total_sales ASC) AS reverse_revenue_rank
    FROM customer_financial_summary cfs
    INNER JOIN customers c ON cfs.customer_id = c.customer_id
)
SELECT *
FROM ranked_consumer_profiles
WHERE reverse_revenue_rank <= 10
ORDER BY reverse_revenue_rank;

-- Customers with exactly one order
SELECT c.customer_name AS ConsumerName, c.customer_id AS ClientID, COUNT(DISTINCT o.order_id) AS TotalOrdersPlaced
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name, c.customer_id
HAVING COUNT(DISTINCT o.order_id) = 1;

-- Customer producing the most profit
SELECT c.customer_name AS ConsumerName, c.customer_id AS ClientID, ROUND(SUM(od.profit), 2) AS AggregatedProfit
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_name, c.customer_id
ORDER BY AggregatedProfit DESC
LIMIT 1;

-- Customer purchasing the highest unit volume
SELECT c.customer_name AS ConsumerName, c.customer_id AS ClientID, SUM(od.quantity) AS TotalQuantityPurchased
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_name, c.customer_id
ORDER BY TotalQuantityPurchased DESC
LIMIT 1;

-- Leading customer within each segment
WITH segment_customer_sales AS (
    SELECT c.segment,
           c.customer_id,
           ROUND(SUM(od.sales), 2) AS total_sales
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.segment, c.customer_id
), ranked_segment_customers AS (
    SELECT segment,
           customer_id,
           total_sales,
           RANK() OVER (PARTITION BY segment ORDER BY total_sales DESC) AS sales_rank
    FROM segment_customer_sales
)
SELECT segment, customer_id, total_sales, sales_rank
FROM ranked_segment_customers
WHERE sales_rank = 1;

-- Leading customer within each category
WITH category_customer_sales AS (
    SELECT p.category,
           c.customer_id,
           ROUND(SUM(od.sales), 2) AS total_sales
    FROM orders o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    INNER JOIN order_details od ON o.order_id = od.order_id
    INNER JOIN products p ON od.product_id = p.product_id
    GROUP BY p.category, c.customer_id
), ranked_category_customers AS (
    SELECT category,
           customer_id,
           total_sales,
           RANK() OVER (PARTITION BY category ORDER BY total_sales DESC) AS sales_rank
    FROM category_customer_sales
)
SELECT category, customer_id, total_sales, sales_rank
FROM ranked_category_customers
WHERE sales_rank = 1;

-- Divide the customer portfolio into NTILE groups
WITH customer_financial_summary AS (
    SELECT o.customer_id,
           SUM(od.sales) AS total_sales
    FROM orders o
    INNER JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
), sales_buckets AS (
    SELECT customer_id,
           total_sales,
           NTILE(4) OVER (ORDER BY total_sales DESC) AS quartile_tier
    FROM customer_financial_summary
)
SELECT quartile_tier,
       CASE
           WHEN quartile_tier = 1 THEN 'Tier 1: Top Spend'
           WHEN quartile_tier = 2 THEN 'Tier 2: Upper Mid'
           WHEN quartile_tier = 3 THEN 'Tier 3: Lower Mid'
           ELSE 'Tier 4: Bottom Spend'
       END AS spend_segment,
       COUNT(*) AS consumer_count,
       ROUND(MIN(total_sales), 2) AS minimum_threshold,
       ROUND(MAX(total_sales), 2) AS maximum_threshold
FROM sales_buckets
GROUP BY quartile_tier
ORDER BY quartile_tier;

-- ==========================================
-- Part 8: business-oriented summary queries
-- ==========================================

-- Compare categories by performance
SELECT p.category AS CategoryGroup,
       ROUND(SUM(od.sales), 2) AS CategoryRevenue,
       ROUND(SUM(od.profit), 2) AS CategoryProfit
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY CategoryRevenue DESC;

-- Compare customer segments by performance
SELECT c.segment AS MarketSegment,
       ROUND(SUM(od.sales), 2) AS SegmentRevenue,
       ROUND(SUM(od.profit), 2) AS SegmentProfit,
       COUNT(DISTINCT o.order_id) AS SegmentOrdersCount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.segment
ORDER BY SegmentRevenue DESC;
