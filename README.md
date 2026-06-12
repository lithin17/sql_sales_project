# Sales & Customer Performance Analysis using SQL

## Project Overview
This project analyzes sales data to understand customer performance across different cities and years. The goal is to identify top-performing customers, measure revenue trends, and compare customer performance across multiple years using SQL.


## Problem Statement
The objective of this analysis is to:
- Identify top revenue-generating customers in each city
- Analyze customer performance across 2023 and 2024
- Find customers who consistently perform well over time
- Measure growth or decline in customer revenue

## Dataset Used
Two tables were used:
- Customers$ (customer_id, city)
- Orders$ (customer_id, order_date, sales)
- Products$ (product_id,category,product_name)



## Approach
The analysis was performed using SQL with the following steps:
- Aggregated sales at customer, city, and year level
- Used window functions (RANK) to find top customers per city
- Filtered top 3 customers for each year
- Compared customer performance across years
- Calculated revenue differences and trends (growth/decline)



## Key SQL Concepts Used
- GROUP BY aggregations
- Common Table Expressions (CTEs)
- Window Functions (RANK, LAG)
- INNER JOIN for comparisons
- CASE WHEN for trend classification



## Key Insights
- A small group of customers contributes a large portion of revenue
- Some customers consistently remain top performers across years
- Revenue patterns vary significantly across cities
- Customer performance can be tracked effectively using SQL ranking techniques



## Outcome
This project helps in understanding customer behavior, identifying high-value customers, and analyzing revenue trends to support business decision-making.


#customer analysis is getting done
