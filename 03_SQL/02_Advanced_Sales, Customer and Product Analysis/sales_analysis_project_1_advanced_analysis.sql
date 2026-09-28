
--ADVANCED CUSTOMER ANALYSIS

select *
from Customers$
------------------
select *
from Orders$
---------------------
select *
from Products$;
--------------------

--Who are the top revenue-generating customers?

SELECT TOP 10 customer_id,
       sum(sales) as total_spending
FROM Orders$
GROUP BY customer_id
ORDER BY sum(sales) DESC;

--What percentage of total sales comes from the top 10 customers?
WITH top_10 
AS
(SELECT top 10  customer_id,
       sum(sales) as total_spending
FROM Orders$
GROUP BY customer_id
ORDER BY sum(sales) DESC),
top_10_total 
AS
(SELECT sum(total_spending) as total_of_10
 FROM top_10),
company_total 
AS
(SELECT sum(sales) as total
 FROM Orders$)
SELECT
round((t.total_of_10/c.total) * 100,2) as top_10_contribution
FROM top_10_total as t
CROSS JOIN company_total as c;
      

--Which customers generate above-average revenue but place below-average orders?

WITH total_data as
(SELECT customer_id,
       sum(sales) as total_spending,
       count(order_id) as total_orders
FROM Orders$
GROUP BY customer_id),
filtering_data as
(SELECT *,
      round(avg(total_spending) over(order by customer_id asc rows between unbounded preceding and unbounded following),2) as total_com_avg,
      avg(total_orders) over(order by customer_id asc rows between unbounded preceding and unbounded following) as avg_com_orders
FROM total_data)
SELECT customer_id,
       total_spending,
       total_orders
FROM filtering_data
WHERE total_spending > total_com_avg AND
      total_orders < avg_com_orders
ORDER BY  total_spending DESC;

--Which customers contribute most to company revenue, and how much risk is there if we lose them?

WITH total_data as
(SELECT customer_id,
       sum(sales) as total_spending
FROM Orders$
GROUP BY customer_id),
ranked_data 
AS
(SELECT *,
       rank() OVER(ORDER BY total_spending DESC) as ranked
FROM total_data),
added_total_rev as
(SELECT *,
       sum(total_spending)over() as total_com_rev 
FROM ranked_data),
contribution_data as
(SELECT *,
       round((total_spending/total_com_rev) * 100,2) as contribution
FROM added_total_rev)
SELECT *,
       total_com_rev-total_spending as rev_after_loss
FROM contribution_data;


--Find customers whose Average Order Value (AOV) is above the company average AOV.
WITH  total_data AS
(SELECT customer_id,
       sum(sales) as total_spending,
       count(order_id) as total_orders
FROM Orders$
GROUP BY customer_id),
cus_avg as
(SELECT *,
       round(total_spending/total_orders,2) as cus_avg_ord_val
FROM total_data),
total_data_2 AS
(SELECT *,
       sum(total_spending)over() as com_rev,
       sum(total_orders) over() as com_ord
FROM cus_avg),
new_com_data as
(SELECT *,
       round(com_rev/com_ord,2) as com_avg
FROM total_data_2)
SELECT customer_id,
       total_spending,
       cus_avg_ord_val
FROM new_com_data
WHERE cus_avg_ord_val > com_avg
ORDER by total_spending DESC;


--Find customers whose total revenue in the latest year is lower than in the previous year."

WITH total_data
AS
(SELECT year(order_date) as years,
       customer_id,
       sum(sales) as total_revenue
FROM Orders$
GROUP BY year(order_date),
         customer_id ),
data_2023 
AS
(SELECT *
FROM total_data
WHERE years=2023),
data_2024
AS
(SELECT *
FROM total_data
WHERE years=2024)
SELECT d.years, 
       d.customer_id,
       d.total_revenue
FROM data_2024 as d
INNER JOIN data_2023 as a
ON d.customer_id=a.customer_id
WHERE d.total_revenue < a.total_revenue;

--advanced approach
WITH total_data
AS
(SELECT year(order_date) as years,
       customer_id,
       sum(sales) as total_spending
FROM Orders$
GROUP BY year(order_date),
         customer_id),
prev_data
AS
(SELECT *,
       lag(total_spending) OVER(partition by customer_id order by years asc) as prev_year_data
FROM total_data)
SELECT *,
       total_spending-prev_year_data as diff
FROM prev_data
WHERE prev_year_data > total_spending
ORDER BY diff ;

--Find customers whose revenue increased from 2023 to 2024.

WITH total_data
AS
(SELECT year(order_date) as order_year,
       customer_id,
       sum(sales) as yearly_revenue
FROM Orders$
GROUP BY year(order_date),
         customer_id),
year_com_data
AS
(SELECT order_year,
       customer_id,
       yearly_revenue as revenue_2023,
       LEAD(yearly_revenue) OVER(partition by customer_id order by order_year asc) revenue_2024
FROM total_data),
differ_data 
AS
(SELECT customer_id,
       revenue_2023,
       revenue_2024,
       revenue_2024-revenue_2023 AS diff
FROM year_com_data),
result_data
AS
(SELECT *,
       CASE
       WHEN diff IS NULL THEN 'unknown'
       WHEN diff > 0 THEN 'include'
       ELSE 'exclude'
       END result
FROM differ_data)
SELECT *
FROM result_data
WHERE result != 'unknown';

--Find customers whose revenue dropped from the previous year, but whose number of orders increased.

WITH total_data 
AS
(SELECT year(order_date) as order_year,
       customer_id,
       sum(sales) as yearly_revenue,
       count(order_id) as yearly_orders
FROM Orders$
GROUP BY year(order_date),
         customer_id),
com_year_data
AS
(SELECT *,
       LEAD(yearly_revenue) OVER(partition by customer_id order by order_year asc) as next_year_rev,
       LEAD(yearly_orders) OVER(partition by customer_id order by order_year asc) as next_year_orders
FROM total_data),
result_data
AS
(SELECT *,
       next_year_rev-yearly_revenue as diff_rev,
       next_year_orders - yearly_orders as diff_orders
FROM com_year_data)
SELECT customer_id,
       yearly_revenue,
       next_year_rev,
       yearly_orders,
       next_year_orders,
       diff_rev,
       diff_orders
FROM result_data
WHERE diff_rev < 0 AND
      diff_orders > 0

--We're worried about customer loyalty. Can you identify customers we should prioritize for retention

WITH total_data
AS
(SELECT year(order_date) as order_year,
       customer_id,
       sum(sales) as yearly_revenue,
       count(order_id) as yearly_orders
FROM Orders$
GROUP BY year(order_date),
         customer_id),
differ_in_data 
AS
(SELECT customer_id,
       yearly_revenue as previous_year_rev,
       yearly_orders as previous_year_orders,
       LEAD(yearly_revenue) OVER(partition by customer_id order by order_year asc) current_year_rev,
       LEAD(yearly_orders) OVER(partition by customer_id order by order_year asc) current_year_ord
FROM total_data),
result_data
AS
(SELECT customer_id,
       previous_year_rev,
       current_year_rev,
       previous_year_orders,
       current_year_ord,
       current_year_rev-previous_year_rev as diff_rev,
       current_year_ord-previous_year_orders as diff_ord
FROM differ_in_data)
SELECT *
FROM result_data
WHERE current_year_rev IS NOT NULL AND
      diff_rev < 0 AND 
      diff_ord < 0 ;


--Which customers contribute to 80% of total sales? (Pareto Analysis)

WITH total_data
AS
(SELECT customer_id,
       sum(sales) as total_revenue
FROM Orders$
GROUP BY customer_id),
company_rev 
AS
(SELECT *,
       sum(total_revenue) OVER() as total_com_rev
FROM total_data),
percent_data AS
(SELECT *,
      round((total_revenue/total_com_rev) * 100,2) as individual_per
FROM company_rev),
ranked_data AS
(SELECT *,
       RANK() OVER(ORDER BY total_revenue DESC) as ranked
FROM percent_data),
result_data
AS
(SELECT customer_id,
       total_revenue,
       individual_per,
       ranked,
       sum(individual_per) over(order by ranked asc rows between unbounded preceding and current row) as cum_per
FROM ranked_data)
SELECT *
FROM result_data
WHERE cum_per <=80;

--Rank customers within each region based on total sales
WITH total_data
AS
(SELECT c.city,
       c.customer_id,
       sum(sales) as total_revenue
FROM Customers$ as c
INNER JOIN Orders$ as o
ON c.customer_id = o.customer_id
GROUP BY c.city,
         c.customer_id)
SELECT city,
       customer_id,
       total_revenue,
       RANK() OVER(partition by city order by total_revenue desc) as ranked
FROM total_data;

--For each city, find the product that generated the highest total revenue.

WITH total_data
AS
(SELECT c.city,
        o.product_id,
        sum(o.sales) as total_revenue
FROM Customers$ as c
INNER JOIN Orders$ as o
ON c.customer_id=o.customer_id
GROUP BY c.city,
         o.product_id),
ranked_data
AS
(SELECT *,
       RANK() OVER(partition by city order by total_revenue desc) as ranked
FROM total_data)
SELECT *
FROM ranked_data
WHERE ranked=1;

--Which customers generate the highest revenue in each product category

WITH total_data
AS
(SELECT p.category,
       o.customer_id,
       sum(o.sales) as total_revenue
FROM Products$ as p
INNER JOIN Orders$ as o
ON p.product_id=o.product_id
GROUP BY p.category,
         o.customer_id),
filtered_data AS
(SELECT category,
       customer_id,
       total_revenue,
       RANK() OVER(partition by category order by total_revenue desc) as ranked
FROM total_data)
SELECT *
FROM filtered_data
WHERE ranked =1;

--Which product category is most dependent on a single customer?

WITH total_data
AS
(SELECT p.category,
       o.customer_id,
       sum(o.sales) as total_revenue
FROM Products$ as p
INNER JOIN Orders$ as o
ON p.product_id=o.product_id
GROUP BY p.category,
         o.customer_id),
ranked_data 
AS
(SELECT category,
       customer_id,
       total_revenue,
       RANK() OVER(partition by category order by total_revenue desc) as ranked
FROM total_data),
filtered_data as
(SELECT *
FROM ranked_data
WHERE ranked =1),
filter_data_new
AS
(SELECT category,
       customer_id,
       total_revenue,
       rank() over(order by total_revenue desc) as ranked_new
FROM filtered_data)
SELECT *
FROM filter_data_new
WHERE ranked_new =1;

--"If one customer stopped buying, which category would lose the largest percentage of its revenue?"

WITH total_data
AS
(SELECT p.category,
       o.customer_id,
       sum(o.sales) as total_revenue
FROM Products$ as p
INNER JOIN Orders$ as o
ON p.product_id=o.product_id
GROUP BY p.category,
         o.customer_id),
category_total 
AS
(SELECT category,
       customer_id,
       total_revenue,
       sum(total_revenue) over(partition by category ) as category_total
FROM total_data),
percen_contri
AS
(SELECT *,
       round((total_revenue * 100 /category_total),2) as individual_contri
FROM category_total),
ranked_data
AS
(SELECT *,
       RANK() OVER(partition by category order by individual_contri desc) as ranked
FROM percen_contri)
SELECT * 
FROM ranked_data
WHERE ranked =1;



---------------------------------------------------------------------------------------------

--ADVANCED PRODUCT ANALYSIS

select *
from Customers$
------------------
select *
from Orders$
---------------------
select *
from Products$;
--------------------

--STORY TELLING ON PRODUCT ANALYSIS

--Objective
--The company wants to understand which products and categories drive revenue and how dependent the business is on a small set of products. The goal is to identify revenue concentration, growth patterns, and strategic focus areas.

--steps for story telling

--query.1.category and thieir products who generates highest revenue
WITH product_data
AS
(SELECT p.category,
        p.product_name,
        sum(o.sales) as total_revenue
FROM Orders$ as o
INNER JOIN Products$ as p
on p.product_id = o.product_id
GROUP BY p.category,
         p.product_name),
ranked_data
AS
(SELECT category,
       product_name,
       total_revenue,
       RANK()over( order by total_revenue desc) as ranked
FROM product_data)
SELECT category,
       product_name,
       total_revenue,
       ranked
FROM ranked_data
where ranked <=3;

--query2:what less no of products gives 80% of com revenue
WITH total_data
AS
(SELECT p.category,
        p.product_name,
        p.product_id,
        sum(o.sales) as total_revenue
FROM Products$ as p
INNER JOIN Orders$ as o
ON p.product_id=o.product_id
GROUP BY p.category,
         p.product_name,
         p.product_id),
com_data
AS
(SELECT *,
        RANK() OVER(order by total_revenue desc) as ranked,
        sum(total_revenue) over() as total_com_rev
FROM total_data),
individual_contribution
AS
(SELECT *,
       round((total_revenue * 100/total_com_rev),2) as percen_of_contri
FROM com_data),
final_data
AS
(SELECT *,
       sum(percen_of_contri) over(order by ranked asc rows between unbounded preceding and current row) as cum_sum
FROM individual_contribution),
further_analysis_data
AS
(SELECT *
FROM final_data
WHERE cum_sum <=80 or
      cum_sum-percen_of_contri <=80),

--query 3 :products and their frequency of order placed
connecting_prod_data
AS
(SELECT product_name,
        product_id,
        total_revenue
FROM further_analysis_data),
final_freq_data
AS
(SELECT c.product_name,
        c.product_id,
        count(o.order_id) as total_orders
FROM connecting_prod_data as c
INNER join Orders$ as o
ON c.product_id=o.product_id
GROUP BY c.product_name,
         c.product_id),
final_ordered_data
AS
(SELECT f.product_name,
        f.total_orders,
        f.product_id,
        c.total_revenue
FROM final_freq_data as f
INNER join connecting_prod_data aS c
ON f.product_name=c.product_name),
prority_products
AS
(SELECT product_name,
        product_id,
        total_orders,
        total_revenue,
       rank() over(order by total_orders desc) as ranked
FROM final_ordered_data),
monthly_analysis
AS
(SELECT TOP 5 product_name,
            product_id
FROM prority_products),

--query 4 :product trend analysis 
yearly_analysis
AS
(SELECT m.product_name,
       m.product_id,
       datename(yy,o.order_date) as order_year,
       count(o.order_id) as total_orders
FROM monthly_analysis as m
INNER JOIN Orders$ as o
ON m.product_id =o.product_id
GROUP BY m.product_name,
         m.product_id,
         datename(yy,o.order_date)),
filter_data
AS
(SELECT *,
       lead(total_orders) over(partition by product_name order by order_year asc) current_year_ord,
       lead(total_orders) over(partition by product_name order by order_year asc)-total_orders as diff
FROM yearly_analysis)

SELECT *,
       CASE
       WHEN diff > 0 THEN 'increased'
       WHEN diff = 0  THEN 'no change'
       ELSE 'decreased'
       END trend
FROM filter_data
WHERE current_year_ord IS NOT NULL;

-- query 5 :for each product their revenue and orders placed

WITH total_data
AS
(SELECT p.product_name,
        p.product_id,
        sum(o.sales) as total_revenue,
        count(o.order_id) as total_orders
FROM Orders$ as o
INNER JOIN Products$ as p
ON p.product_id =o.product_id
GROUP by p.product_name,
         p.product_id),
avg_data
AS
(SELECT *,
       round(avg(total_revenue) over(),2) as avg_revenue,
       avg(total_orders) over() as avg_orders
FROM total_data),
trend_analysis
AS
(SELECT *,
       CASE
       WHEN total_revenue >= avg_revenue and total_orders >= avg_orders THEN 'star product'
       WHEN total_revenue >= avg_revenue and total_orders < avg_orders THEN 'premium product'
       WHEN total_revenue < avg_revenue and total_orders >= avg_orders THEN 'volume products'
       ELSE 'weak products'
       END trend
FROM avg_data)
SELECT *
FROM trend_analysis;

--END OF PRODUCT ANALYSIS


---------------------------------------------------------

--SALES ANALYSIS

--Objective

--Understand overall sales performance, identify growth patterns, seasonality, and periods of strong or weak business performance.
    

--QUERY 1 : total company sales in current year and previous year

WITH comp_data
AS
(SELECT year(order_date) as rev_year,
       sum(sales) as total_rev
FROM Orders$
GROUP BY year(order_date)),
com_data
AS
(SELECT total_rev as current_rev,
       lag(total_rev) over(order by rev_year asc) prev_year
FROM comp_data),
diff_data
AS
(SELECT *,
       current_rev-prev_year as diff
FROM com_data
WHERE  current_rev-prev_year IS NOT NULL)
SELECT *,
       CASE 
       WHEN diff > 0 THEN 'growth'
       WHEN diff = 0 THEN 'break even'
       ELSE 'loss'
       END trend,
       round(diff * 100.0 /prev_year,2) as per_of_grow_or_loss
FROM diff_data;

--QUERY 2 : monthly revenue trend analysis
WITH total_data
AS
(SELECT year(order_date) as rev_year,
        datename(mm,order_date) as rev_month,
        sum(sales) as total_rev
FROM Orders$
GROUP BY year(order_date),
         datename(mm,order_date)),
com_data
AS
(SELECT rev_month,
       total_rev as current_year_month_rev,
       lag(total_rev) over(partition by rev_month order by rev_year asc) as prev_year_mon_rev
FROM total_data),
diff_data
AS
(SELECT *,
       round(current_year_month_rev-prev_year_mon_rev,2) as diff
FROM com_data)
SELECT *,
       CASE
       WHEN diff > 0 THEN 'growth'
       WHEN diff = 0 THEN 'break even'
       ELSE 'loss'
       END trend,
       round(diff * 100 /prev_year_mon_rev,2) as per_of_g_l
FROM diff_data
WHERE diff IS NOT NULL
ORDER BY diff DESC;

--QUERY 3 :category wise revenue per in the month of july in current year and previous year

WITH total_data
AS
(SELECT year(o.order_date) as rev_year,
        month(o.order_date) as rev_month,
        p.category,
        sum(o.sales) as total_rev
FROM Orders$ as o
INNER JOIN Products$ as p
ON o.product_id=p.product_id
GROUP BY year(o.order_date),
         month(o.order_date),
         p.category
HAVING month(o.order_date) = 7),
combined_data
AS
(SELECT rev_year,
       rev_month,
       category,
       total_rev as current_year_jul_rev,
       lag(total_rev) over(partition by category order by rev_year asc) as previous_year_jul_rev
FROM total_data),
diff_data
AS
(SELECT *,
       round(current_year_jul_rev-previous_year_jul_rev,2) as diff
FROM combined_data),
final_data
AS
(SELECT *,
       CASE
       WHEN diff > 0 THEN 'growth'
       WHEN diff = 0 THEN 'break even'
       ELSE 'loss'
       END trend,
       round(diff * 100.0 / previous_year_jul_rev,2) as per_of_g_l
FROM diff_data
WHERE diff IS NOT NULL),
ranked_data
AS
(SELECT *,
       rank() over(order by diff desc) as ranked
FROM final_data)
SELECT *
FROM ranked_data
WHERE ranked =1;

--query 4 : for furniture category check product revenue in 2023 and 2024 and do pareto analysis

WITH total_data
AS
(SELECT YEAR(o.order_date) as rev_year,
        month(o.order_date) as rev_month,
        p.category,
        p.product_name,
        o.product_id,
        sum(o.sales) as total_rev
FROM Orders$ as o
INNER JOIN Products$ as p
ON o.product_id=p.product_id
WHERE p.category='Furniture'
GROUP BY YEAR(o.order_date),
         month(o.order_date),
         p.category,
         p.product_name,
         o.product_id
HAVING month(o.order_date) = 7),
combined_data
AS
(SELECT rev_year,
       product_name,
       total_rev as current_year_jul_rev,
       coalesce(lag(total_rev) over(partition by product_id order by rev_year asc),0) as prev_year_jul_rev
FROM total_data),
differ_data
AS
(SELECT *,
       round(current_year_jul_rev-prev_year_jul_rev,2) as diff
FROM combined_data),
rep_product_remover
AS
(SELECT *,
       row_number() over(partition by product_name order by rev_year desc) as duplicate_rank
FROM differ_data),
polished_data
AS
(SELECT *
FROM rep_product_remover
WHERE duplicate_rank=1),
ranked_data
AS
(SELECT product_name,
       current_year_jul_rev,
       prev_year_jul_rev,
       diff,
       rank() over(order by diff desc) as ranked
FROM polished_data)
SELECT *,
       CASE
       WHEN prev_year_jul_rev = 0 THEN 'newly added prod'
       ELSE 'old product'
       END trend
FROM ranked_data;


--QUERY 5 : product and sales in 2023 and 2024 

WITH total_data
AS
(SELECT year(o.order_date) as rev_year,
       p.product_name,
       p.product_id,
       sum(o.sales) as total_revenue
FROM Orders$ as o
INNER JOIN Products$ as p
ON o.product_id=p.product_id
GROUP by  year(o.order_date),
          p.product_name,
          p.product_id),
com_data
AS
(SELECT product_name,
        product_id,
        total_revenue as current_year_rev,
        lag(total_revenue) over(partition by product_id order by rev_year asc) as prev_rev
FROM total_data),
final_data
AS
(SELECT *,
        round(current_year_rev-prev_rev,2) as diff
FROM com_data
WHERE prev_rev IS NOT NULL)
SELECT *,
       CASE
       WHEN diff > 0 THEN 'GROWTH'
       WHEN diff = 0 THEN 'BREAK EVEN'
       ELSE 'FALL'
       END trend,
       round(diff * 100.0/prev_rev,2) as per_of_grow_or_loss
FROM final_data
ORDER BY diff DESC;

--END OF SALES ANALYSIS
-------------------------------------------------------------------------

--CUSTOMER ANALYSIS

--STORY TELLING OF CUSTOMER ANALYSIS

--Customer Analysis Objective
--Understand who drives revenue, how dependent the business is on key customers, and identify customers at risk of reducing their spending.

--query 1 : we know that revenue dropped by 15% from 2023 to 2024 we got info from product analysis and is it customers are the reason

WITH total_data
AS
(SELECT year(o.order_date) as rev_year,
        c.customer_id,
        sum(o.sales) as total_rev
FROM Orders$ as o
INNER JOIN Customers$ as c
ON o.customer_id=c.customer_id
GROUP BY year(o.order_date),
         c.customer_id),
combined_data
AS
(SELECT rev_year,
       customer_id,
       total_rev as current_year_rev,
       lag(total_rev) over(partition by customer_id order by rev_year asc) as prev_year_rev
FROM total_data),
final_data
AS
(SELECT *,
       coalesce(current_year_rev-prev_year_rev,current_year_rev) as diff
FROM combined_data
WHERE rev_year != 2023),
trend_analysis
AS
(SELECT *,
       CASE
       WHEN prev_year_rev IS NULL THEN 'new customer'
       WHEN diff > 0 then 'increased'
       WHEN diff = 0 then 'breakeven'
       ELSE 'decreased'
       END trend
FROM final_data)
SELECT trend,
    SUM(diff) AS revenue_loss,
    ROUND( SUM(diff) * 100.0 /SUM((SUM(diff))) OVER(),2) AS per_of_loss
FROM trend_analysis
WHERE diff < 0
GROUP BY trend

UNION 

SELECT
    trend,
    SUM(diff) AS revenue_loss,
    ROUND(
        SUM(diff) * 100.0 /
        SUM(SUM(diff)) OVER(),
        2
    ) AS per_of_loss
FROM trend_analysis
WHERE diff > 0
GROUP BY trend;


