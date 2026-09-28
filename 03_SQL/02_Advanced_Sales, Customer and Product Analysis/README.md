# Advanced Sales, Customer and Product Analysis

## Overview

This SQL file contains advanced business analysis performed on an e-commerce sales dataset.

The objective is to move beyond basic reporting and identify **revenue drivers, customer behavior, product performance, sales trends, revenue concentration, and potential business risks**.

The analysis is divided into three major areas:

1. Customer Analysis
2. Product Analysis
3. Sales Analysis

---

## Dataset

The analysis uses three tables:

* `Customers$` — Customer information
* `Products$` — Product information
* `Orders$` — Transaction and sales information

### Relationships

```text
Customers$
    |
    | customer_id
    |
Orders$
    |
    | product_id
    |
Products$
```

---

# 1. Customer Analysis

The customer analysis focuses on understanding revenue contribution and changes in customer purchasing behavior.

### Key analyses

* Top revenue-generating customers
* Revenue contribution of the top 10 customers
* Customers generating above-average revenue
* Customers with high revenue but relatively low order frequency
* Customer revenue concentration
* Average Order Value (AOV)
* Customers whose revenue declined year-over-year
* Customers whose revenue increased year-over-year
* Customers whose revenue declined while order volume increased
* Customers showing declining revenue and order activity
* Customer retention analysis
* Pareto analysis of customer revenue
* Customer ranking within cities
* Highest-revenue customers within product categories
* Product-category dependency on individual customers

### Business questions

Examples include:

* Which customers contribute the most revenue?
* How concentrated is company revenue among major customers?
* Which customers have experienced revenue declines?
* Are some customers ordering more frequently while spending less?
* Which customers may require closer retention monitoring?
* Which customers account for approximately 80% of sales?

---

# 2. Product Analysis

The product analysis investigates which products and categories drive revenue and order activity.

### Key analyses

* Top products by revenue
* Revenue concentration among products
* Products contributing toward 80% of company revenue
* Product order frequency
* Product-level yearly trends
* Revenue and order-volume comparison
* Product performance classification

Products are classified based on revenue and order volume into categories such as:

* Star Products
* Premium Products
* Volume Products
* Weak Products

These classifications are based on comparison with average product revenue and average order volume.

---

# 3. Sales Analysis

The sales analysis examines overall company performance and changes over time.

### Key analyses

* Current-year vs previous-year revenue
* Revenue growth and decline
* Monthly revenue trends
* Year-over-year monthly comparison
* Category-level performance
* July category performance
* Furniture product analysis
* Product-level year-over-year revenue comparison
* Revenue growth/loss percentages
* Customer contribution to overall revenue changes

### Business questions

Examples include:

* Is company revenue growing or declining?
* Which months show stronger or weaker performance?
* Which categories are contributing to changes in revenue?
* Which products experienced revenue growth?
* Which products experienced revenue decline?
* Which customers contributed to changes in overall revenue?

---

# Advanced SQL Techniques Used

This analysis demonstrates several intermediate-to-advanced SQL techniques.

### Common Table Expressions

```sql
WITH total_data AS (...)
```

CTEs are used to break complex analytical problems into multiple logical stages.

### Window Functions

The project uses:

* `LAG()`
* `LEAD()`
* `RANK()`
* `ROW_NUMBER()`
* `SUM() OVER()`
* `AVG() OVER()`

### Other SQL Concepts

* `JOIN`
* `GROUP BY`
* `HAVING`
* `CASE`
* `COALESCE`
* Aggregate functions
* Date functions
* Conditional analysis
* Running totals
* Percentage calculations
* Year-over-year analysis
* Pareto analysis

---

# Analytical Techniques

## Year-over-Year Analysis

Revenue is compared across years to identify:

* Growth
* Decline
* Break-even periods
* Percentage change

## Pareto Analysis

Customer and product revenue are analyzed using cumulative contribution to identify entities responsible for a large portion of total revenue.

## Revenue Concentration

The analysis examines how much company/category revenue depends on individual customers or products.

## Trend Analysis

`LAG()` and `LEAD()` are used to compare values across years and identify changes in:

* Revenue
* Orders
* Customer activity
* Product performance

---

# Business Value

The purpose of this analysis is not simply to produce SQL results.

The queries are designed to support questions around:

* Revenue growth
* Customer retention
* Revenue concentration
* Product performance
* Category performance
* Customer dependency
* Sales trends
* Business risk areas

The results can subsequently be used to build a Power BI dashboard and communicate findings to business stakeholders.

---

# Project Workflow

```text
Raw Dataset
     ↓
SQL Data Exploration
     ↓
Basic Analysis
     ↓
Advanced SQL Analysis
     ↓
Business Insights
     ↓
Power BI Dashboard
     ↓
Business Recommendations

