-- Retail Sales Analysis
-- Dataset: Online Retail Dataset (UCI Machine Learning Repository)
-- 541,909 order line items, Dec 2010 - Dec 2011

-- Q1: Top 10 best-selling products by total quantity sold
SELECT Description, SUM(Quantity) AS TotalSold
FROM orders
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10;

-- Q2: Revenue by country (Quantity * UnitPrice, summed, highest first)
SELECT Country, SUM(Quantity * UnitPrice) AS Revenue
FROM orders
GROUP BY Country
ORDER BY Revenue DESC;

-- Q3: Returns by country (Quantity < 0 only), most damaging first
-- Used to quantify how much of each country's revenue is offset by returns
SELECT Country, SUM(Quantity * UnitPrice) AS ReturnsValue
FROM orders
WHERE Quantity < 0
GROUP BY Country
ORDER BY ReturnsValue ASC;

-- Supporting checks used to verify dataset stats for the README
SELECT COUNT(*) FROM orders;                          -- total row count
SELECT MIN(InvoiceDate), MAX(InvoiceDate) FROM orders; -- date range covered