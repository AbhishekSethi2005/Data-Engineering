-- ======================================================
-- Part B: condition-based record selection
-- ======================================================

USE sales_assignment;

-- 1. North-region orders arranged by date
SELECT o.order_date AS DateOfOrder, o.total_amount AS AmountInINR 
FROM orders o 
WHERE o.region = 'North' 
ORDER BY o.order_date ASC;

-- 2. Electronics priced at 50 or more
SELECT p.product_name AS NameOfProduct, ROUND(p.unit_price, 2) AS StandardPrice 
FROM products p 
WHERE p.category = 'Electronics' AND p.unit_price >= 50.00 
ORDER BY p.unit_price DESC;

-- 3. Orders with values above 200
SELECT o.id AS PurchaseOrderID, ROUND(o.total_amount, 2) AS HighValueAmount 
FROM orders o 
WHERE o.total_amount > 200.00 
ORDER BY o.total_amount DESC;

-- 4. Customers who joined before June 2023
SELECT c.customer_name AS EarlyAdopter, c.signup_date AS EnrollmentDate 
FROM customers c 
WHERE c.signup_date < '2023-06-01' 
ORDER BY c.signup_date ASC;
