-- ======================================================
-- Part E: derived metrics and classification queries
-- ======================================================

USE sales_assignment;

-- 1. Sales amount by calendar month
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS CalendarMonth, ROUND(SUM(o.total_amount), 2) AS GrossMonthlySales 
FROM orders o 
GROUP BY CalendarMonth 
ORDER BY CalendarMonth ASC;

-- 2. Three customers with the largest total spend
SELECT c.customer_name AS TopCustomer, ROUND(SUM(o.total_amount), 2) AS CumulativeValue 
FROM customers c 
INNER JOIN orders o ON c.id = o.customer_id 
GROUP BY c.customer_name 
ORDER BY CumulativeValue DESC 
LIMIT 3;

-- 3. Find repeated customer-and-date transactions
SELECT o.customer_id AS ClientID, o.order_date AS PurchaseDate, COUNT(o.id) AS TotalTransactions 
FROM orders o 
GROUP BY o.customer_id, o.order_date 
HAVING COUNT(o.id) > 1;

-- 4. Label orders by their value band
SELECT o.id AS SalesOrderID, ROUND(o.total_amount, 2) AS BillAmount, 
       CASE 
           WHEN o.total_amount >= 300.00 THEN 'Premium Tier' 
           WHEN o.total_amount >= 150.00 THEN 'Standard Tier' 
           ELSE 'Basic Tier' 
       END AS OrderClassification 
FROM orders o 
ORDER BY o.total_amount DESC;
