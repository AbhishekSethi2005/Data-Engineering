-- ======================================================
-- Part D: queries that combine related tables
-- ======================================================

USE sales_assignment;

-- 1. Match orders to their customer regions
SELECT o.id AS OrderID, c.customer_name AS ClientName, o.order_date AS OrderDate, o.region AS CustomerRegion, ROUND(o.total_amount, 2) AS TransactionTotal 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.id 
ORDER BY o.id ASC;

-- 2. Show each order line with product details
SELECT oi.id AS ItemID, o.id AS OrderID, p.product_name AS NameOfProduct, oi.quantity AS Qty, ROUND(oi.unit_price, 2) AS Rate 
FROM order_items oi 
INNER JOIN orders o ON oi.order_id = o.id 
INNER JOIN products p ON oi.product_id = p.id 
ORDER BY oi.id ASC;

-- 3. Calculate customer spend, including customers without orders
SELECT c.customer_name AS ConsumerName, ROUND(COALESCE(SUM(o.total_amount), 0.00), 2) AS CumulativeSpent 
FROM customers c 
LEFT JOIN orders o ON c.id = o.customer_id 
GROUP BY c.customer_name 
ORDER BY CumulativeSpent DESC;
