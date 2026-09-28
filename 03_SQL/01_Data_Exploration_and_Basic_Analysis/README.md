# Data Exploration and Basic Analysis

## Overview

This SQL file contains the initial data exploration and basic analysis performed on an e-commerce dataset.

The analysis focuses on understanding the structure of the **Customers, Products, and Orders** tables before moving into advanced business analysis.

The purpose of this stage is to establish a basic understanding of the customer base, product catalog, order activity, and sales patterns.

---

## Dataset

The analysis uses three tables:

* `Customers$` — Customer information
* `Products$` — Product information
* `Orders$` — Order and sales transaction information

### Main entities

**Customers**

* Customer ID
* City
* Customer Segment

**Products**

* Product ID
* Product Name
* Category

**Orders**

* Order ID
* Customer ID
* Product ID
* Order Date
* Sales

---

## Analysis Performed

### 1. Customer Analysis

The analysis explores:

* Total number of customers
* Customer locations
* Customer segments
* Customers by city
* Distribution of customers across segments

### 2. Product Analysis

The analysis explores:

* Total number of products
* Product categories
* Distribution of products across categories
* Initial product-level observations

### 3. Order Analysis

The analysis explores:

* Total number of orders
* Orders placed by individual customers
* Most frequently ordered products
* Basic order activity patterns

### 4. Initial Sales Analysis

The analysis also begins connecting order activity with sales information to understand:

* Revenue by customer segment
* Product sales
* Category-level performance
* Sales patterns across years

---

## SQL Concepts Used

This file primarily demonstrates foundational SQL concepts:

* `SELECT`
* `DISTINCT`
* `WHERE`
* `GROUP BY`
* `ORDER BY`
* Aggregate functions
* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`
* `HAVING`
* Basic joins
* Subqueries / CTEs
* Basic window-function usage

---

## Business Purpose

This stage answers basic questions such as:

* How large is the customer base?
* Where are customers located?
* What customer segments exist?
* How many products and categories are available?
* How many orders have been placed?
* Which products have higher order activity?
* Which customer segments contribute to sales?

The findings from this stage provide the foundation for the advanced analysis contained in:

`02_Advanced_Sales_Customer_Product_Analysis.sql`

---

## Project Workflow

The SQL analysis follows this general workflow:

**Data Exploration → Basic Analysis → Advanced Analysis → Business Insights → Power BI Dashboard**

This file represents the **Data Exploration and Basic Analysis** stage.
