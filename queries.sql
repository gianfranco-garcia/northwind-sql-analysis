-- ============================================================
-- Northwind Sales Analysis — queries.sql
-- Each block = one business question + its SQL query.
-- Author: Gianfranco García | Database: northwind.db (classic clean version)
-- ============================================================


-- ------------------------------------------------------------
-- Query 0 — Warm-up: a first look at the products table
-- Question: What products does Northwind sell, and at what price?
-- Skills: SELECT, FROM, LIMIT
-- ------------------------------------------------------------
SELECT ProductName, UnitPrice
FROM Products
LIMIT 10;


-- ------------------------------------------------------------
-- Query 1 — Top 10 products by revenue
-- Question: Which products generate the most money for Northwind?
-- Skills: SUM, revenue calculation, GROUP BY, ORDER BY, LIMIT, JOIN
-- ------------------------------------------------------------
SELECT p.ProductName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM OrderDetails od
JOIN Products p ON od.ProductId = p.ProductId
GROUP BY p.ProductName
ORDER BY Revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 2 — Revenue by category
-- Question: Which product categories generate the most money?
-- Skills: JOIN (3 tables), SUM, GROUP BY, ORDER BY
-- ------------------------------------------------------------
SELECT c.CategoryName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM OrderDetails od
JOIN Products p   ON od.ProductId = p.ProductId
JOIN Categories c ON p.CategoryId = c.CategoryId
GROUP BY c.CategoryName
ORDER BY Revenue DESC;


-- ------------------------------------------------------------
-- Query 3 — Revenue by customer country
-- Question: Which countries do the top-buying customers come from?
-- Skills: JOIN (Customers-Orders-OrderDetails), GROUP BY, ORDER BY, LIMIT
-- ------------------------------------------------------------
SELECT c.Country,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM Customers c
JOIN Orders o        ON c.CustomerId = o.CustomerId
JOIN OrderDetails od ON o.OrderId   = od.OrderId
GROUP BY c.Country
ORDER BY Revenue DESC
LIMIT 10;


-- Check (Q3) — customers and revenue PER CUSTOMER by country
-- Tests the "USA buys premium" hypothesis. It does NOT hold: USA/Germany lead on a
-- broad base (13 and 11 customers); the real "whales" are in small countries
-- (Austria $64k/customer, Ireland, Sweden). Total revenue != most valuable customers.
SELECT c.Country,
       COUNT(DISTINCT c.CustomerId) AS Customers,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) / COUNT(DISTINCT c.CustomerId)) AS Revenue_per_customer
FROM Customers c
JOIN Orders o        ON c.CustomerId = o.CustomerId
JOIN OrderDetails od ON o.OrderId    = od.OrderId
GROUP BY c.Country
ORDER BY Revenue_per_customer DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Query 4 — Top 5 customers by spend
-- Question: Which individual customers bring in the most money?
-- Skills: JOIN (Customers-Orders-OrderDetails), SUM, GROUP BY, ORDER BY, LIMIT
-- ------------------------------------------------------------
SELECT c.CompanyName, c.Country,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM Customers c
JOIN Orders o        ON c.CustomerId = o.CustomerId
JOIN OrderDetails od ON o.OrderId    = od.OrderId
GROUP BY c.CustomerId
ORDER BY Revenue DESC
LIMIT 5;


-- Check (Q4) — Austria's customers (to validate the "$64k/customer" from Q3)
-- Revealed that the average was hiding the distribution: Ernst Handel $104k vs Piccolo $23k.
SELECT c.CompanyName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM Customers c
JOIN Orders o        ON c.CustomerId = o.CustomerId
JOIN OrderDetails od ON o.OrderId    = od.OrderId
WHERE c.Country = 'Austria'
GROUP BY c.CustomerId
ORDER BY Revenue DESC;


-- ------------------------------------------------------------
-- Query 5 — Employees who generate the most sales
-- Question: Who on the sales team closes the most money?
-- Skills: JOIN (Employees-Orders-OrderDetails), string concatenation (||),
--         COUNT(DISTINCT), SUM, GROUP BY, ORDER BY
-- ------------------------------------------------------------
SELECT e.FirstName || ' ' || e.LastName AS Employee,
       e.Title,
       COUNT(DISTINCT o.OrderId) AS Orders,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM Employees e
JOIN Orders o        ON e.EmployeeId = o.EmployeeId
JOIN OrderDetails od ON o.OrderId    = od.OrderId
GROUP BY e.EmployeeId
ORDER BY Revenue DESC;


-- ------------------------------------------------------------
-- Query 6 — Monthly sales trend
-- Question: How do sales evolve over time? Is the business growing?
-- Skills: DATE functions (strftime), SUM, COUNT(DISTINCT), GROUP BY, ORDER BY
-- ------------------------------------------------------------
SELECT strftime('%Y-%m', o.OrderDate) AS Month,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue,
       COUNT(DISTINCT o.OrderId) AS Orders
FROM Orders o
JOIN OrderDetails od ON o.OrderId = od.OrderId
GROUP BY Month
ORDER BY Month;


-- Check (Q6) — date range of the database (to explain the 2018-05 "drop")
-- Revealed the data ends on 2018-05-06: May is an INCOMPLETE (truncated) month, not a real decline.
SELECT MIN(OrderDate) AS First_order, MAX(OrderDate) AS Last_order
FROM Orders;


-- ------------------------------------------------------------
-- Query 7 — Products selling above the average
-- Question: Which products sell more than the average product (the "stars")?
-- Skills: SUBQUERY (query inside a query), HAVING, AVG, GROUP BY
-- How to read: inside-out. The subquery computes the AVERAGE revenue
--              per product; HAVING keeps only the ones that beat it.
-- ------------------------------------------------------------
SELECT p.ProductName,
       ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))) AS Revenue
FROM OrderDetails od
JOIN Products p ON od.ProductId = p.ProductId
GROUP BY p.ProductId
HAVING Revenue > (
        SELECT AVG(prod_rev)
        FROM (
            SELECT SUM(od2.UnitPrice * od2.Quantity * (1 - od2.Discount)) AS prod_rev
            FROM OrderDetails od2
            GROUP BY od2.ProductId
        )
)
ORDER BY Revenue DESC;
