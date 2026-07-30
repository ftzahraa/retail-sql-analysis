# Retail Sales Analysis (SQL)

## Overview
Analysis of the UK Online Retail dataset (541,909 order line items, Dec 2010 – Dec 2011)
using SQL (SQLite) to answer business questions about sales performance, revenue by
region, and data quality issues affecting the results.

**Dataset source:** [Online Retail Dataset – UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail)

## Tools
- SQLite (via DB Browser for SQLite)
- SQL: aggregation, grouping, filtering, sorting, calculated fields

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
Identified the 10 best-selling products by total units sold (e.g. "World War 2 Gliders
Asstd Designs", "Jumbo Bag Red Retrospot"). While building this query, an unsorted
version of the results surfaced a single anomalous row: `NULL` product description
totaling -13,609 units — investigated further below.

### 2. Revenue by country
UK generates the overwhelming majority of revenue (~£8.19M), consistent with this
being a UK-based retailer. Netherlands, EIRE, and Germany are the next largest
markets, each far behind the UK.

### 3. Data quality: NULL descriptions and returns
- One row grouping (`NULL` Description, negative Quantity) accounts for -13,609 units,
  likely representing unlinked returns or data entry errors rather than a real product.
- Negative `Quantity` values represent product returns across the dataset. Isolating
  these:
  - **UK returns total: -£815,291.60**, roughly **10% of UK's gross revenue**
    (£8,187,806.36) — the largest returns impact of any country by a wide margin
    (next highest, EIRE, is only -£20,177).
  - This is within normal retail return-rate ranges (8-15%), but significant enough
    to flag when reporting headline revenue rather than leaving it hidden in the total.

## Next Steps
- Quantify returns as a % of revenue for all countries, not just the UK
- Build a Power BI dashboard on top of these findings
- Scale this pipeline with PySpark and deploy via cloud storage
