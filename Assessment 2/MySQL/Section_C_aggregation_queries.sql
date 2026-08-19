-- ======================================================
-- Part C: grouped metrics and summary queries
-- ======================================================

USE sales_assignment;

-- 1. Revenue total for each region
SELECT o.region AS SalesRegion, ROUND(SUM(o.total_amount), 2) AS CalculatedRevenue 
FROM orders o 
GROUP BY o.region 
ORDER BY CalculatedRevenue DESC;

-- 2. Units purchased for every product
SELECT p.product_name AS MerchName, SUM(oi.quantity) AS VolumeSold 
FROM order_items oi 
INNER JOIN products p ON oi.product_id = p.id 
GROUP BY p.product_name 
ORDER BY VolumeSold DESC;

-- 3. Mean order value by customer
SELECT c.customer_name AS ShopperName, ROUND(AVG(o.total_amount), 2) AS AverageTicketSize 
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.id 
GROUP BY c.customer_name 
ORDER BY AverageTicketSize DESC;

-- 4. Highest listed price in each category
SELECT p.category AS ProductClass, ROUND(MAX(p.unit_price), 2) AS HighestPricePoint 
FROM products p 
GROUP BY p.category;
