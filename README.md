# Retail Sales Analysis

An end-to-end analysis of the UK Online Retail dataset (541,909 order line items, Dec 2010 – Dec 2011), built in stages — starting with SQL, then visualised in Power BI, with PySpark and cloud deployment planned next.

**Dataset source:** [Online Retail Dataset – UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/352/online+retail)

## Project stages

### 1. [SQL Analysis](./sql/)
Eleven analytical questions answered using SQLite — revenue by country and month, returns and data quality issues, customer segmentation, and more. See the full write-up and queries in [`sql/README.md`](./sql/README.md).

### 2. [Power BI Dashboard](./powerbi/)
An interactive dashboard built on top of the SQL findings — six visuals covering revenue, returns, and customer behaviour, cross-checked against the SQL results. See [`powerbi/README.md`](./powerbi/README.md).

### 3. PySpark + Cloud (planned)
Scaling the same pipeline with PySpark and deploying via cloud storage.

## Key takeaway
Across both stages, the data consistently points to this being a **wholesale/B2B gift and homeware retailer** rather than a casual consumer store — evidenced by high average order values, zero Saturday activity, a 70% repeat-purchase rate, and revenue heavily concentrated among a small group of top customers.

## Note on terminology
"Returns" throughout this project refers to item returns (negative-quantity transactions), not ROI or profit. The dataset contains only selling price, not cost price, so profit/ROI cannot be calculated from it.
