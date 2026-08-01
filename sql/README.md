# Retail Sales Analysis (SQL)

## Overview
Analysis of the UK Online Retail dataset (541,909 order line items, Dec 2010 – Dec 2011)
using SQL (SQLite) to answer business questions about sales performance, revenue by
region, customer behaviour, and data quality issues affecting the results.

**Dataset source:** [Online Retail Dataset – UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail)

**Note on terminology:** "Returns" throughout this analysis refers strictly to item
returns — customers sending products back, represented as negative `Quantity` values
in the data. It does not refer to ROI (return on investment) or profit. This dataset
only contains selling price, not cost price, so profit/ROI cannot be calculated from it.

## Tools
- SQLite (via DB Browser for SQLite)
- SQL: aggregation, grouping, filtering, sorting, calculated fields, subqueries, CASE, HAVING

## How to Run
> **Note:** The database file (`retail.db`) is not included in this repo due to
> its size. To reproduce this analysis:
> 1. Download the dataset from the [UCI link above](https://archive.ics.uci.edu/dataset/352/online+retail)
> 2. Import it into a new SQLite database named `retail.db`, in a table named `orders`
> 3. Open `retail.db` in [DB Browser for SQLite](https://sqlitebrowser.org/)
> 4. Go to the **Execute SQL** tab
> 5. Run any query from [`queries.sql`](./queries.sql)

## Key Findings

### 1. Top-selling products by quantity
"World War 2 Gliders Asstd Designs" and "Jumbo Bag Red Retrospot" top the list of
best-selling products by units sold. While building this query, an unsorted version
of the results turned up something odd first: a single row with a `NULL` product
description totalling -13,609 units. More on that below.

### 2. Revenue by country
The UK accounts for the overwhelming majority of revenue (~£8.19M), which makes
sense for what looks like a UK-based retailer. Netherlands, EIRE, and Germany follow,
though each is far behind the UK.

### 3. Data quality: NULL descriptions and returns
That odd row from Finding 1 turns out to be returns or data entry errors that never
got tied to a real product. Digging further, negative `Quantity` values represent
returns throughout the dataset, and isolating them shows just how much they matter:
UK returns total -£815,291.60, about 10% of the UK's gross revenue. That's the
largest returns impact of any country by a wide margin — the next highest, EIRE,
is only -£20,177. It's still within a normal 8-15% retail return range, but it's
big enough that it shouldn't be left hidden inside a headline revenue number.

### 4. Revenue by month
November 2011 had the highest total revenue at roughly £1.46M — not December, even
though December is usually peak season. This tracks with pre-Christmas gift and
wholesale ordering, where buyers get ahead of shipping deadlines. December 2011
looks artificially weak here only because the dataset cuts off on Dec 9, 2011,
missing the last three weeks of the month. December 2010, which is complete,
brought in £748,957 — a fairer comparison.

### 5. Top customers by spend
The top spender (CustomerID 14646.0) put through £279,489.02 over the year. One
thing worth flagging: rows with a `NULL` CustomerID — likely guest or unlinked
transactions — added up to £1,447,682.12, over five times the top real customer,
and were excluded from this ranking since they don't represent one identifiable
buyer. Also worth a mention: CustomerID is stored as a float in the source data
(e.g. 14646.0), not an integer. Left as-is here rather than quietly reformatting it.

### 6. Average order value
Average order value across the whole dataset comes to £376.36, though it swings
month to month, roughly between £283 and £427. November 2011 stands out again —
not just the highest revenue month, but also a higher-than-average order value
(£422.23), meaning customers were both ordering more often and spending more per
order that month.

### 7. Revenue by day of week
Thursdays bring in the most revenue (£2.11M); Sundays the least, among days that
actually have activity. And Saturday has none at all — zero transactions across
the entire dataset, confirmed with a direct row count rather than just a low
number. That points to a business that simply doesn't process orders on Saturdays,
which fits a B2B/wholesale pattern rather than casual retail.

### 8. One-time vs. repeat buyers
Of 4,373 identified customers, 70% (3,060) come back more than once, and 30%
(1,313) only order once. A repeat rate that high says a lot — it's the kind of
number you'd expect from a wholesale or subscription-style business, not
one-off casual shopping.

### 9. High-value customers
97 customers, about 2.2% of the customer base, have each spent over £10,000. A
small group, but clearly a commercially important one.

### 10. Revenue concentration in top customers
Just the top 10 customers account for about 14.05% of total revenue — £1,369,181.79
out of £9,747,747.93 company-wide. A small handful of accounts driving that much
revenue is a classic Pareto pattern, and it lines up with everything else pointing
toward a wholesale operation built around a core of high-value repeat customers.

### 11. Returns as a percentage of sales, by country
Extending Finding 3 to every country, not just the UK, shows return rates ranging
from 0% (low-volume markets like Iceland, Canada, and Brazil, which simply don't
have enough transactions to show any) up to 57.14% in Singapore. That upper end is
worth taking with a grain of salt, though — small countries with few transactions
produce noisy percentages, since a couple of returns can swing the number a lot.
The UK's 10% is the more trustworthy figure here, simply because it's based on
far more data than anywhere else.

One honest note on getting here: the first version of this query divided returns
by *net* revenue instead of gross sales, and it produced nonsense — one country
showed a returns rate of -133%. The fix was dividing by gross sales (positive
transactions only), which is the number that actually makes sense as a denominator.

## Overall Conclusion
A few different findings here point in the same direction independently: high
average order values, no activity at all on Saturdays, a 70% repeat-purchase rate,
and revenue concentrated in a small group of top customers. Taken together, this
looks less like a casual consumer store and more like a wholesale/B2B gift and
homeware retailer.

## Next Steps
- Build a Power BI dashboard on top of these findings (see [`../powerbi/`](../powerbi/))
- Scale this pipeline with PySpark and deploy via cloud storage
