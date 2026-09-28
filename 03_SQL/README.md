# SQL Analysis

## Overview

This folder contains the complete SQL analysis for the **E-commerce Sales & Customer Analytics** project.

The objective of the analysis is to transform raw e-commerce transaction data into meaningful business insights using Microsoft SQL Server.

The analysis progresses from **data exploration and basic business analysis** to **advanced customer, product, and sales analysis**.

---

## Project Objective

The SQL analysis is designed to answer important business questions related to:

* Customer behavior
* Customer revenue contribution
* Product performance
* Sales performance
* Revenue growth and decline
* Customer retention
* Revenue concentration
* Product and category performance
* Year-over-year trends

The goal is to move beyond simple reporting and identify patterns that can support business decision-making.

---

## Dataset

The analysis uses three primary tables:

* `Customers$`
* `Products$`
* `Orders$`

### Table Relationships

```text
Customers$
     |
     | customer_id
     ↓
Orders$
     |
     | product_id
     ↓
Products$
```

The `Orders$` table acts as the central transaction table connecting customers and products.

---

# SQL Analysis Structure

The SQL analysis is divided into two stages.

## 01 — Data Exploration and Basic Analysis

**File:**

`01_Data_Exploration_and_Basic_Analysis.sql`

This file focuses on understanding the dataset and performing foundational analysis.

### Customer Analysis

* Total customer count
* Customer distribution
* Customers by city
* Customer segments
* Customer-level order activity

### Product Analysis

* Total product count
* Product categories
* Product distribution
* Product order activity

### Order & Sales Analysis

* Total orders
* Orders by customer
* Product order frequency
* Basic sales analysis
* Category-level analysis
* Customer-segment sales analysis

### Purpose

This stage establishes an understanding of the dataset before moving into more complex analytical questions.

---

# 02 — Advanced Sales, Customer & Product Analysis

**File:**

`02_Advanced_Sales_Customer_Product_Analysis.sql`

This file contains advanced analytical queries designed to answer more business-oriented questions.

---

## Customer Analysis

The analysis includes:

* Top revenue-generating customers
* Top customer revenue contribution
* Above-average revenue customers
* Revenue versus order frequency
* Average Order Value (AOV)
* Customer revenue concentration
* Year-over-year customer revenue changes
* Customers with declining revenue
* Customers with increasing revenue
* Customers with declining revenue despite increased orders
* Customer retention analysis
* Pareto analysis
* Customer ranking by city
* Customer contribution within product categories

### Key Business Questions

* Which customers generate the most revenue?
* How concentrated is revenue among major customers?
* Which customers are experiencing declining revenue?
* Are customers ordering more while spending less?
* Which customers require closer monitoring from a retention perspective?

---

## Product Analysis

The analysis includes:

* Top products by revenue
* Product revenue contribution
* Products contributing to approximately 80% of revenue
* Product order frequency
* Product year-over-year trends
* Revenue versus order volume
* Product performance classification

Products are analyzed based on both revenue and order volume.

---

## Sales Analysis

The analysis includes:

* Current-year versus previous-year revenue
* Revenue growth and decline
* Monthly sales trends
* Year-over-year monthly comparisons
* Category-level sales performance
* Product-level year-over-year performance
* Revenue growth percentages
* Revenue contribution by customer
* Analysis of changes in overall revenue

### Key Business Questions

* Is revenue increasing or declining?
* Which periods have stronger sales performance?
* Which categories contribute most to sales?
* Which products are growing or declining?
* Which customers contribute significantly to changes in revenue?

---

# SQL Techniques Used

This project demonstrates SQL concepts ranging from foundational to advanced analytical techniques.

### Basic SQL

* `SELECT`
* `DISTINCT`
* `WHERE`
* `ORDER BY`
* `GROUP BY`
* `HAVING`
* `TOP`

### Aggregate Functions

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`

### Joins

* `INNER JOIN`
* `LEFT JOIN`

### Conditional Logic

* `CASE`
* Conditional aggregation
* Business-rule based classification

### Advanced SQL

* Common Table Expressions (`CTEs`)
* Subqueries
* Window functions
* `RANK()`
* `ROW_NUMBER()`
* `LAG()`
* `LEAD()`
* `SUM() OVER()`
* `AVG() OVER()`
* `PARTITION BY`

### Analytical Techniques

* Year-over-year analysis
* Running totals
* Revenue contribution
* Pareto analysis
* Ranking
* Trend analysis
* Percentage change
* Customer segmentation
* Product performance classification

---

# Analytical Approach

The analysis follows a structured progression:

```text
Raw Data
   ↓
Data Exploration
   ↓
Basic SQL Analysis
   ↓
Customer Analysis
   ↓
Product Analysis
   ↓
Sales Analysis
   ↓
Advanced SQL Analysis
   ↓
Business Insights
   ↓
Power BI Dashboard
```

This approach ensures that the data is understood before advanced business questions are analyzed.

---

# Business Areas Covered

| Business Area | Analysis                              |
| ------------- | ------------------------------------- |
| Customer      | Customer activity, revenue, retention |
| Product       | Product revenue, volume, trends       |
| Sales         | Revenue, growth, trends               |
| Category      | Category performance                  |
| Revenue       | Contribution and concentration        |
| Trends        | Year-over-year and monthly analysis   |
| Risk          | Customer/product performance changes  |

---

# SQL to Power BI

The SQL analysis forms the analytical foundation for the Power BI dashboard.



SQL is used to perform detailed data analysis, while Power BI is used to communicate the findings through interactive visualizations.


---

# Outcome

The SQL analysis provides a structured view of:

* Who the major customers are
* Which products generate significant revenue
* How revenue changes over time
* Where revenue is concentrated
* Which customers and products show changing performance
* How customer, product, and sales behavior interact

The resulting insights are used as the foundation for the project's Power BI dashboard and business reporting.

