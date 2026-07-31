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

-- Q4: Total revenue by month (year-month), highest first
SELECT strftime('%Y-%m', InvoiceDate) AS Month, SUM(Quantity * UnitPrice) AS Revenue
FROM orders
GROUP BY strftime('%Y-%m', InvoiceDate)
ORDER BY Revenue DESC;

-- Q5: Top 10 customers by total spend (excludes NULL/unidentified customers)
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpend
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalSpend DESC
LIMIT 10;

-- Q6: Average order value overall, and by month
-- Inner subquery collapses line items into one total per order (InvoiceNo)
-- Outer query averages those order totals, grouped by month
SELECT Month, AVG(OrderTotal) AS AvgOrderValue
FROM (
    SELECT InvoiceNo, strftime('%Y-%m', InvoiceDate) AS Month, SUM(Quantity * UnitPrice) AS OrderTotal
    FROM orders
    GROUP BY InvoiceNo, strftime('%Y-%m', InvoiceDate)
) AS OrderTotals
GROUP BY Month
ORDER BY Month;

-- Q7: Revenue by day of week (CASE translates SQLite's numeric weekday into a name)
SELECT
    CASE strftime('%w', InvoiceDate)
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS DayOfWeek,
    SUM(Quantity * UnitPrice) AS Revenue
FROM orders
GROUP BY strftime('%w', InvoiceDate)
ORDER BY Revenue DESC;

-- Q8: One-time buyers vs. repeat buyers (count of customers in each group)
-- Inner subquery counts each customer's distinct orders
-- Outer query buckets customers into One-time vs Repeat and counts each bucket
SELECT
    CASE
        WHEN OrderCount = 1 THEN 'One-time Buyer'
        ELSE 'Repeat Buyer'
    END AS BuyerType,
    COUNT(*) AS NumberOfCustomers
FROM (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS OrderCount
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
) AS CustomerOrderCounts
GROUP BY BuyerType;

-- Q9: Customers who have spent more than £10,000 in total
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpend
FROM orders
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING TotalSpend > 10000
ORDER BY TotalSpend DESC;

-- Q10: What % of total revenue comes from the top 10 customers?
-- Run alongside the grand total query below, then divide by hand:
-- Top10Total / GrandTotal * 100
SELECT SUM(TotalSpend) AS Top10Total
FROM (
    SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpend
    FROM orders
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
    ORDER BY TotalSpend DESC
    LIMIT 10
) AS Top10;

SELECT SUM(Quantity * UnitPrice) AS GrandTotal
FROM orders;

-- Q11: Returns as a % of gross sales, by country
-- GrossSales = positive-quantity transactions only (the correct denominator)
-- ReturnsValue = negative-quantity transactions only
-- Countries with very low GrossSales produce volatile percentages -- read with caution
SELECT
    Country,
    SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END) AS GrossSales,
    SUM(CASE WHEN Quantity < 0 THEN Quantity * UnitPrice ELSE 0 END) AS ReturnsValue,
    ROUND(
        SUM(CASE WHEN Quantity < 0 THEN Quantity * UnitPrice ELSE 0 END) * -100.0
        / SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END), 2
    ) AS ReturnsPercentage
FROM orders
GROUP BY Country
ORDER BY ReturnsPercentage DESC;

-- Supporting checks used to verify dataset stats for the README
SELECT COUNT(*) FROM orders;                          -- total row count
SELECT MIN(InvoiceDate), MAX(InvoiceDate) FROM orders; -- date range covered
SELECT COUNT(*) FROM orders WHERE strftime('%w', InvoiceDate) = '6'; -- confirms zero Saturday orders
