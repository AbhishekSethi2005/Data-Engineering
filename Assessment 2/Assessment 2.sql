-- ==========================================
-- Create the sales database and its core tables
-- ==========================================

CREATE DATABASE IF NOT EXISTS sales_assignment;
USE sales_assignment;

CREATE TABLE customers (
    id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- ==========================================
-- Load the sample sales records
-- ==========================================

INSERT INTO customers (id, customer_name, city, region, signup_date) VALUES
(1, 'Aarti Sharma', 'Chicago', 'North', '2023-01-10'),
(2, 'Rohit Kumar', 'Dallas', 'South', '2023-02-15'),
(3, 'Sneha Gupta', 'Austin', 'West', '2023-03-20'),
(4, 'Vikram Patel', 'Boston', 'East', '2023-04-05'),
(5, 'Anjali Patel', 'Denver', 'North', '2023-05-12'),
(6, 'Amit Singh', 'Phoenix', 'South', '2023-06-01'),
(7, 'Priya Reddy', 'Seattle', 'West', '2023-07-14'),
(8, 'Siddharth Rao', 'Miami', 'East', '2023-08-22'),
(9, 'Kavya Nair', 'Atlanta', 'North', '2023-09-18'),
(10, 'Arjun Verma', 'San Diego', 'South', '2023-10-09');

INSERT INTO products (id, product_name, category, unit_price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Wireless Mouse', 'Electronics', 49.99),
(3, 'Coffee Maker', 'Home', 79.95),
(4, 'Desk Lamp', 'Home', 39.99),
(5, 'Running Shoes', 'Sports', 89.99),
(6, 'Backpack', 'Sports', 59.99),
(7, 'Winter Jacket', 'Fashion', 129.99),
(8, 'Leather Wallet', 'Fashion', 49.99);

INSERT INTO orders (id, customer_id, order_date, region, total_amount) VALUES
(1, 1, '2024-01-05', 'North', 1049.98),
(2, 2, '2024-01-12', 'South', 249.95),
(3, 1, '2024-02-03', 'North', 89.98),
(4, 3, '2024-02-18', 'West', 299.97),
(5, 4, '2024-03-07', 'East', 159.98),
(6, 5, '2024-03-20', 'North', 149.95),
(7, 6, '2024-04-02', 'South', 279.90),
(8, 7, '2024-04-12', 'West', 349.95),
(9, 8, '2024-05-01', 'East', 199.90),
(10, 9, '2024-05-15', 'North', 239.85),
(11, 10, '2024-06-01', 'South', 129.95),
(12, 2, '2024-06-20', 'South', 89.98);

INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 1, 49.99),
(3, 2, 3, 1, 79.95),
(4, 2, 4, 1, 39.99),
(5, 2, 5, 1, 129.99),
(6, 3, 6, 1, 59.99),
(7, 4, 7, 1, 129.99),
(8, 4, 8, 1, 49.99),
(9, 4, 5, 1, 89.99),
(10, 5, 4, 1, 39.99),
(11, 5, 6, 1, 59.99),
(12, 6, 5, 1, 89.99),
(13, 7, 3, 2, 79.95),
(14, 8, 7, 1, 129.99),
(15, 8, 8, 1, 49.99),
(16, 9, 2, 2, 49.99),
(17, 10, 1, 1, 999.99),
(18, 10, 4, 1, 39.99),
(19, 11, 6, 1, 59.99),
(20, 12, 3, 1, 79.95);

-- ==========================================
-- Part A: confirm the loaded schema and row counts
-- ==========================================

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'sales_assignment' 
ORDER BY table_name;

SELECT * FROM customers ORDER BY id LIMIT 5;
SELECT * FROM products ORDER BY id LIMIT 5;
SELECT * FROM orders ORDER BY id LIMIT 5;
SELECT * FROM order_items ORDER BY id LIMIT 5;

SELECT 'customers' AS entity_name, COUNT(*) AS total_records FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;

/*
Sample execution output:
mysql> SELECT table_name FROM information_schema.tables WHERE table_schema = 'sales_assignment' ORDER BY table_name;
+-------------+
| TABLE_NAME  |
+-------------+
| customers   |
| order_items |
| orders      |
| products    |
+-------------+

mysql> SELECT 'customers' AS entity_name, COUNT(*) AS total_records FROM customers UNION ALL SELECT 'products', COUNT(*) FROM products UNION ALL SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
+-------------+---------------+
| entity_name | total_records |
+-------------+---------------+
| customers   |            10 |
| products    |             8 |
| orders      |            12 |
| order_items |            20 |
+-------------+---------------+
*/

-- ==========================================
-- Part B: retrieve records that meet the requested conditions
-- ==========================================

SELECT o.order_date AS DateOfOrder, o.total_amount AS AmountInINR 
FROM orders o 
WHERE o.region = 'North' 
ORDER BY o.order_date ASC;

SELECT p.product_name AS NameOfProduct, ROUND(p.unit_price, 2) AS StandardPrice 
FROM products p 
WHERE p.category = 'Electronics' AND p.unit_price >= 50.00 
ORDER BY p.unit_price DESC;

SELECT o.id AS PurchaseOrderID, ROUND(o.total_amount, 2) AS HighValueAmount 
FROM orders o 
WHERE o.total_amount > 200.00 
ORDER BY o.total_amount DESC;

SELECT c.customer_name AS EarlyAdopter, c.signup_date AS EnrollmentDate 
FROM customers c 
WHERE c.signup_date < '2023-06-01' 
ORDER BY c.signup_date ASC;

/*
Sample execution output:
mysql> SELECT o.order_date AS DateOfOrder, o.total_amount AS AmountInINR FROM orders o WHERE o.region = 'North' ORDER BY o.order_date ASC;
+-------------+-------------+
| DateOfOrder | AmountInINR |
+-------------+-------------+
| 2024-01-05  |     1049.98 |
| 2024-02-03  |       89.98 |
| 2024-03-20  |      149.95 |
| 2024-05-15  |      239.85 |
+-------------+-------------+
*/

-- ==========================================
-- Part C: calculate grouped sales measures
-- ==========================================

SELECT o.region AS SalesRegion, ROUND(SUM(o.total_amount), 2) AS CalculatedRevenue 
FROM orders o 
GROUP BY o.region 
ORDER BY CalculatedRevenue DESC;

SELECT p.product_name AS MerchName, SUM(oi.quantity) AS VolumeSold 
FROM order_items oi 
INNER JOIN products p ON oi.product_id = p.id 
GROUP BY p.product_name 
ORDER BY VolumeSold DESC;

SELECT c.customer_name AS ShopperName, ROUND(AVG(o.total_amount), 2) AS AverageTicketSize 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.id 
GROUP BY c.customer_name 
ORDER BY AverageTicketSize DESC;

SELECT p.category AS ProductClass, ROUND(MAX(p.unit_price), 2) AS HighestPricePoint 
FROM products p 
GROUP BY p.category;

/*
Sample execution output:
mysql> SELECT o.region AS SalesRegion, ROUND(SUM(o.total_amount), 2) AS CalculatedRevenue FROM orders o GROUP BY o.region ORDER BY CalculatedRevenue DESC;
+-------------+-------------------+
| SalesRegion | CalculatedRevenue |
+-------------+-------------------+
| North       |           1529.76 |
| South       |            749.78 |
| West        |            649.92 |
| East        |            359.88 |
+-------------+-------------------+
*/

-- ==========================================
-- Part D: connect related sales entities
-- ==========================================

SELECT o.id AS OrderID, c.customer_name AS ClientName, o.order_date AS OrderDate, o.region AS CustomerRegion, ROUND(o.total_amount, 2) AS TransactionTotal 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.id 
ORDER BY o.id ASC;

SELECT oi.id AS ItemID, o.id AS OrderID, p.product_name AS NameOfProduct, oi.quantity AS Qty, ROUND(oi.unit_price, 2) AS Rate 
FROM order_items oi 
INNER JOIN orders o ON oi.order_id = o.id 
INNER JOIN products p ON oi.product_id = p.id 
ORDER BY oi.id ASC;

SELECT c.customer_name AS ConsumerName, ROUND(COALESCE(SUM(o.total_amount), 0.00), 2) AS CumulativeSpent 
FROM customers c 
LEFT JOIN orders o ON c.id = o.customer_id 
GROUP BY c.customer_name 
ORDER BY CumulativeSpent DESC;

/*
Sample execution output:
mysql> SELECT c.customer_name AS ConsumerName, ROUND(COALESCE(SUM(o.total_amount), 0.00), 2) AS CumulativeSpent FROM customers c LEFT JOIN orders o ON c.id = o.customer_id GROUP BY c.customer_name ORDER BY CumulativeSpent DESC;
+---------------+-----------------+
| ConsumerName  | CumulativeSpent |
+---------------+-----------------+
| Aarti Sharma  |         1139.96 |
| Priya Reddy   |          349.95 |
| Rohit Kumar   |          339.93 |
+---------------+-----------------+
*/

-- ==========================================
-- Part E: derive advanced summaries and order bands
-- ==========================================

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS CalendarMonth, ROUND(SUM(o.total_amount), 2) AS GrossMonthlySales 
FROM orders o 
GROUP BY CalendarMonth 
ORDER BY CalendarMonth ASC;

SELECT c.customer_name AS TopCustomer, ROUND(SUM(o.total_amount), 2) AS CumulativeValue 
FROM customers c 
INNER JOIN orders o ON c.id = o.customer_id 
GROUP BY c.customer_name 
ORDER BY CumulativeValue DESC 
LIMIT 3;

SELECT o.customer_id AS ClientID, o.order_date AS PurchaseDate, COUNT(o.id) AS TotalTransactions 
FROM orders o 
GROUP BY o.customer_id, o.order_date 
HAVING COUNT(o.id) > 1;

SELECT o.id AS SalesOrderID, ROUND(o.total_amount, 2) AS BillAmount, 
       CASE 
           WHEN o.total_amount >= 300.00 THEN 'Premium Tier' 
           WHEN o.total_amount >= 150.00 THEN 'Standard Tier' 
           ELSE 'Basic Tier' 
       END AS OrderClassification 
FROM orders o 
ORDER BY o.total_amount DESC;

/*
Sample execution output:
mysql> SELECT o.id AS SalesOrderID, ROUND(o.total_amount, 2) AS BillAmount, CASE WHEN o.total_amount >= 300.00 THEN 'Premium Tier' WHEN o.total_amount >= 150.00 THEN 'Standard Tier' ELSE 'Basic Tier' END AS OrderClassification FROM orders o ORDER BY o.total_amount DESC;
+--------------+------------+---------------------+
| SalesOrderID | BillAmount | OrderClassification |
+--------------+------------+---------------------+
|            1 |    1049.98 | Premium Tier        |
|            8 |     349.95 | Premium Tier        |
|            4 |     299.97 | Standard Tier       |
+--------------+------------+---------------------+
*/
