# MySQL execution record

This file preserves the MySQL command-line evidence for creating the database, loading the sample records, and running representative queries.

```sql
PS C:\Users\Lenovo> mysql -u root -p
Enter password: ****

Welcome to the MySQL monitor. Commands end with ; or \g.
Server version: 8.0.46 MySQL Community Server - GPL

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sales_assignment   |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql> CREATE DATABASE IF NOT EXISTS sales_assignment;
Query OK, 1 row affected (0.01 sec)

mysql> USE sales_assignment;
Database changed

mysql> CREATE TABLE customers (
    ->     id INT PRIMARY KEY,
    ->     customer_name VARCHAR(100) NOT NULL,
    ->     city VARCHAR(100) NOT NULL,
    ->     region VARCHAR(50) NOT NULL,
    ->     signup_date DATE NOT NULL
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE TABLE products (
    ->     id INT PRIMARY KEY,
    ->     product_name VARCHAR(100) NOT NULL,
    ->     category VARCHAR(50) NOT NULL,
    ->     unit_price DECIMAL(10,2) NOT NULL
    -> );
Query OK, 0 rows affected (0.02 sec)

mysql> CREATE TABLE orders (
    ->     id INT PRIMARY KEY,
    ->     customer_id INT NOT NULL,
    ->     order_date DATE NOT NULL,
    ->     region VARCHAR(50) NOT NULL,
    ->     total_amount DECIMAL(10,2) NOT NULL,
    ->     FOREIGN KEY (customer_id) REFERENCES customers(id)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE order_items (
    ->     id INT PRIMARY KEY,
    ->     order_id INT NOT NULL,
    ->     product_id INT NOT NULL,
    ->     quantity INT NOT NULL,
    ->     unit_price DECIMAL(10,2) NOT NULL,
    ->     FOREIGN KEY (order_id) REFERENCES orders(id),
    ->     FOREIGN KEY (product_id) REFERENCES products(id)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE INDEX idx_orders_customer_id ON orders(customer_id);
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE INDEX idx_orders_order_date ON orders(order_date);
Query OK, 0 rows affected (0.02 sec)

mysql> CREATE INDEX idx_items_order_id ON order_items(order_id);
Query OK, 0 rows affected (0.03 sec)

mysql> CREATE INDEX idx_items_product_id ON order_items(product_id);
Query OK, 0 rows affected (0.02 sec)


-- ======================================================
-- SAMPLE DATA LOAD CONFIRMATION
-- ======================================================

mysql> INSERT INTO customers (id, customer_name, city, region, signup_date) VALUES ...
Query OK, 10 rows affected (0.02 sec)

mysql> INSERT INTO products (id, product_name, category, unit_price) VALUES ...
Query OK, 8 rows affected (0.01 sec)

mysql> INSERT INTO orders (id, customer_id, order_date, region, total_amount) VALUES ...
Query OK, 12 rows affected (0.01 sec)

mysql> INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES ...
Query OK, 20 rows affected (0.02 sec)


-- ======================================================
-- EXCERPTS FROM QUERY RESULTS
-- ======================================================

mysql> SELECT 'customers' AS entity_name, COUNT(*) AS total_records FROM customers
    -> UNION ALL
    -> SELECT 'products', COUNT(*) FROM products;
+-------------+---------------+
| entity_name | total_records |
+-------------+---------------+
| customers   |            10 |
| products    |             8 |
+-------------+---------------+
2 rows in set (0.01 sec)

mysql> SELECT o.order_date AS DateOfOrder, o.total_amount AS AmountInINR 
    -> FROM orders o 
    -> WHERE o.region = 'North' 
    -> ORDER BY o.order_date ASC;
+-------------+-------------+
| DateOfOrder | AmountInINR |
+-------------+-------------+
| 2024-01-05  |     1049.98 |
| 2024-02-03  |       89.98 |
| 2024-03-20  |      149.95 |
| 2024-05-15  |      239.85 |
+-------------+-------------+
4 rows in set (0.00 sec)

mysql> SELECT o.region AS SalesRegion, ROUND(SUM(o.total_amount), 2) AS CalculatedRevenue 
    -> FROM orders o 
    -> GROUP BY o.region 
    -> ORDER BY CalculatedRevenue DESC;
+-------------+-------------------+
| SalesRegion | CalculatedRevenue |
+-------------+-------------------+
| North       |           1529.76 |
| South       |            749.78 |
| West        |            649.92 |
| East        |            359.88 |
+-------------+-------------------+
4 rows in set (0.00 sec)

mysql> SELECT c.customer_name AS ConsumerName, ROUND(COALESCE(SUM(o.total_amount), 0.00), 2) AS CumulativeSpent 
    -> FROM customers c 
    -> LEFT JOIN orders o ON c.id = o.customer_id 
    -> GROUP BY c.customer_name 
    -> ORDER BY CumulativeSpent DESC;
+---------------+-----------------+
| ConsumerName  | CumulativeSpent |
+---------------+-----------------+
| Aarti Sharma  |         1139.96 |
| Priya Reddy   |          349.95 |
| Rohit Kumar   |          339.93 |
| Sneha Gupta   |          299.97 |
| Amit Singh    |          279.90 |
| Kavya Nair    |          239.85 |
| Siddharth Rao |          199.90 |
| Vikram Patel  |          159.98 |
| Anjali Patel  |          149.95 |
| Arjun Verma   |          129.95 |
+---------------+-----------------+
10 rows in set (0.01 sec)

mysql> SELECT o.id AS SalesOrderID, ROUND(o.total_amount, 2) AS BillAmount, 
    ->        CASE 
    ->            WHEN o.total_amount >= 300.00 THEN 'Premium Tier' 
    ->            WHEN o.total_amount >= 150.00 THEN 'Standard Tier' 
    ->            ELSE 'Basic Tier' 
    ->        END AS OrderClassification 
    -> FROM orders o 
    -> ORDER BY o.total_amount DESC;
+--------------+------------+---------------------+
| SalesOrderID | BillAmount | OrderClassification |
+--------------+------------+---------------------+
|            1 |    1049.98 | Premium Tier        |
|            8 |     349.95 | Premium Tier        |
|            4 |     299.97 | Standard Tier       |
|            7 |     279.90 | Standard Tier       |
|            2 |     249.95 | Standard Tier       |
|           10 |     239.85 | Standard Tier       |
|            9 |     199.90 | Standard Tier       |
|            5 |     159.98 | Standard Tier       |
|            6 |     149.95 | Basic Tier          |
|           11 |     129.95 | Basic Tier          |
|            3 |      89.98 | Basic Tier          |
|           12 |      89.98 | Basic Tier          |
+--------------+------------+---------------------+
12 rows in set (0.00 sec)
```
