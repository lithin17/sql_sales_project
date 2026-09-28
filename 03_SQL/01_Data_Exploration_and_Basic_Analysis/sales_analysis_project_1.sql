
--ANALYSING CUSTOMERS TABLE
select *
from Customers$;


--total number of customers
select distinct count(*) 
from Customers$;
--INSIGHT: we have a  total of 100 customers in customer base


--total cities
select distinct city
from Customers$;
--INSIGHT we have customer base  in 10 cities all over india and in these we can also observe metro politic cities


--types of customers
select distinct segment 
from Customers$
--INSIGHT:we have 3 types of customers in our customer base and further analysis  need to be done to get customers in these segment

--customers from each city
select city,
       count(*) as total_count
from Customers$
group by city
order by total_count desc
--INSIGHT:we can see that we have highest customer base from hyd,delhi which are 14 and combining it is 28 % of total customer base and least customer base is from kolkata but with current data we cannot talk about revenue of cities but upto the data we have to try to improve customers from kolkata here we are not considering revenue


--customer type
select segment,
       count(*) as total_customers
from Customers$
group by segment
order by total_customers desc
--here most of our customers are from home office and consumer and we have less customers from corporate but according to the avalable data we cannot say which brach has highest revenue we are here talking only about customers in each segment

------------------------------------------
--FURTHER ANALYSIS IS DONE LATER 
------------------------------------------
----------------------------------------------------------
--ANALYSIS OF PRODUCT TABLE
select *
from Products$


--count of products
select count(distinct product_id) as total 
from Products$
-- INSIGHT:ther are total of 30 products in different catogiries


--different category
select category,
       count(*) as total
from Products$
group by category
order by total desc
--INSIGHT: here we have total of 3 categories of products  distributed equally products in each category and sales of the products cannot be done with current data further analysis is done later

--------------------------------------------------
--FURTHER ANALYSIS IS DONE LATER
--------------------------------------------------
----------------------------------------------------------
---ORDERS ANALYSIS

select * 
from Orders$


--total number of orders
select count(*) as total
from Orders$
--INSIGHT:we have total of 300 orders placed by 100 customers  from 10 cities and 3 segments and ordered 3 catogiries of items placed


--customer and his orders to know placed more orders
select customer_id,
       count(*) as total_orders
from orders$
group by customer_id
order by total_orders desc
--INSIGHT: c1084 has placed more orders but by the current data we cannot say him as the most money spent he only hase more orders than others but some other may have most money contributed this is done by further analysis


---what product sold most
select product_id,
       count(*) as total_count
from Orders$
group by product_id
order by total_count desc
--INSIGHT p1029 has sold mostly but we cannot say it as it generated high revenue because by the current data we cannot say the revenue but it is sold mostly and p1001 has sold leastly people are not intrested in buyng it once again that doesnt mean it generates less we dont know price of it by current data and it may be sold less due to seasonal also insufficient current data


-- time period of ordering
select min(order_date) as mini,
       max(order_date) as maxi,
       datediff(month,min(order_date),max(order_date)) as months
from Orders$
--INSIGHT:the orders are placed in the span of 23 months starting of 2023-01 and ended in 2024-12


--FURTHER ANALYSIS USING SALES COLUMN

--customer and their spending
select customer_id,
       sum(sales) as total
from Orders$
group by customer_id
order by total desc
--INSIGHT:c1084,c1057 has spent most money but we cannot conclude them as more purchases they spent high amount and c1047 has spent low money and it doesnt conclude him as low orders he may have orderd high but spends low compae to others


-- product and their revenue
select product_id,
       sum(sales) as total
from Orders$
group by product_id
order by total desc
--INSIGHT: p1029 and p1015 has generated most revenue and p1001 has generated low revenue and the data is about revenue only here we are not considering the orders here


-- year and revenue generated and total orders conceded
select year(order_date) as years,
       sum(sales) as total,
       count(order_id) as total_orders

from Orders$
group by year(order_date)
order by total_orders desc
--INSIGHT: in 2023 most orders are kept and more revenue is generated than 2024 it is dropped in both revenue and orders if nothing changed in 2025 we may also see slight drop means people are shifting to others


--------------------------------------------------------------
--FURTHER ANALYSIS IS BELOW
---------------------------------------------------------------

--considering all tables data will be taken

select *
from Customers$
----------------------
select *
from Orders$
------------------------
select *
from Products$
------------------------


--city and revenue generated and orders received
select year(o.order_date) as years,
       c.city,
       sum(o.sales) as total_revenue,
       count(o.order_id) as orders,
       round(sum(o.sales)*1.0/count(o.order_id),2) as avg_order_value
from Orders$ o
join Customers$ c
    on o.customer_id = c.customer_id
group by year(o.order_date),
         c.city
order by years,
         total_revenue desc;
--INSIGHT: in 2023 delhi has generated highest revenue and orders and kolkotha is generated least revenue and orders but we can observe kolkatha has sold mostly costly products  and in 2024 hyd has generated most revenue and orders and again kol has generated least but we can observe mostly kol has generating the decent money with less orders 


--revenue generated in each segment in each year
select year(o.order_date) as years,
      c.segment,
      sum(o.sales) as total,
      count(o.order_id) as total_orders,
      rank() over(partition by year(o.order_date) order by sum(o.sales) desc) as ranked
from Orders$ as o
left join Customers$ as c
on o.customer_id=c.customer_id
group by  year(o.order_date),c.segment
--INSIGHT :in 2023 home office generated highest revenue and highest orders  and corporate generated least  and in 2024 the domination of home office continues and corporate has improved by revenue and consumer got down but by current data we cannot provide reasons for further analysis required

select *
from

(--sub query :city and catogory items sold
select c.city,
       p.category,
       sum(o.sales) as total_sales,
       rank() over(partition by c.city order by sum(o.sales) desc ) as ranked
from Orders$ as o
left join Customers$ as c
on o.customer_id=c.customer_id
left join Products$ as p
on o.product_id=p.product_id
group by c.city, p.category)t
-- this data is combined raw data for clear analysis consider it as sub query
where ranked = 1
--by the above query we can find which catogory is hing in which city



--customer and orders placed in each year and moey spent

select *
from
--sub query:customer and orders placed in each year and money spend
(select year(o.order_date) as years,
       c.customer_id,
       count(o.product_id) as total_orders,
       sum(o.sales) as total_sales,
       rank() over(partition by year(o.order_date) order by  sum(o.sales)  desc ) as  ranked,
       round(sum(o.sales)  /count(o.product_id),2)   as avg_purchase
from Orders$ as o
left join Customers$ as c
on o.customer_id=c.customer_id
group by year(o.order_date), c.customer_id)customer_orders
--to simply it consider it as sub query
where ranked <=5 

--INSIGHT: c1084 has spent more money and more orders in the year 2023 and we cannot say other customers spent less we can see the averages are close to alleven the avg of c1096 is greater than the 1st  c1090 has kept less orders but his avg is greater than 1st and in year 2024 c1057 has kept 4 order and spent more avg than most ordered person so we cannot conclude a person as best customer by the no. of orders but we have to money spent and his avg


--Which city generates the highest revenue per customer, and does it also have the highest customer count?
select *,
       rank() over(order by avg_sales desc ) as rank_tot,
       rank() over( order by  total_count  desc ) as ranked
from
(select c.city,
       count(distinct c.customer_id) as total_count,
       round(sum(o.sales)*1.0/count(distinct c.customer_id),2) as avg_sales
from Orders$ as o
left join Customers$ as c
on o.customer_id = c.customer_id
group by c.city)highest_revenue_per_cus


--products sold and revenue generated in year 2023 and 2024
select *,
       lag(total_sales) over(partition by category order by total_sales) as differ 
from
(Select year(o.order_date) as years,
       p.category,
       count(customer_id) as total_customers,
       sum(sales) as total_Sales,
       rank() over(partition by p.category order by sum(sales)) as ranked
from Orders$ as o
left join Products$ as p 
on o.product_id = p.product_id
group by year(o.order_date),p.category)revenue_calc

select *
from
(select  *,
       rank() over(partition by city order by total_spending desc) as ranked
from
(select c.city,
       c.customer_id,
       sum(o.sales) as total_spending
from Customers$  as c
left join Orders$ as o
on c.customer_id=o.customer_id
group by c.city,c.customer_id)city_customer)t
where ranked =1;

--For each year, find the city that generated the highest revenue.
with year_city
as
(select year(o.order_date) as years,
       c.city,
       sum(o.sales) as total_revenue
from Customers$ as c
right join Orders$ as o
on c.customer_id=o.customer_id
group by year(o.order_date),c.city)
--filter
select *
from
(--ranking
select *,
       rank() over(partition by years order by total_revenue desc) as ranked
from
year_city)t
where ranked =1

--find highest revenue generated city in 2024 and compare it to 2023
with total_city_revenue 
as
(select year(order_date) as years,
       c.city,
       sum(sales) as total_revenue
from Orders$ as o
left join Customers$ as c
on o.customer_id=c.customer_id
group by year(order_date),c.city),
--filter
top_1_2024 
as
(select top 1 *
from total_city_revenue
where years=2024
order by total_revenue desc),
--revenue difference
rev_diff as
(select t.city,
       t.years,
       t.total_revenue
from top_1_2024 as o
 join total_city_revenue as t
on o.city=t.city),
after_diff as 
(select *,
      total_revenue - lag(total_revenue) over(partition by city order by years ) as diff
from rev_diff)
select city,
       years,
       total_revenue,
       diff,
       case
       when diff is null then 'unknown value'
       when diff > 0 then 'growth'
       when diff < 0 then 'downfall'
       else 'breakeven'
       end trend
from after_diff;


--Find the customer with the highest revenue in 2024.Compare their revenue with 2023.
with year_city_rev 
as
(select year(o.order_date) as years,
       c.city,
       o.customer_id,
       sum(o.sales) as total_revenue
from Orders$ as o
join Customers$ as c
on o.customer_id=c.customer_id
group by  year(o.order_date),
          c.city,
          o.customer_id),
--only 2024 data
data_2024 as
(select *
from year_city_rev
where years=2024),
--ranking the region region
ranking_region as
(select *,
       rank() over(partition by city order by total_revenue desc) as ranked
from data_2024),
--top 1 of each city
top_1_region as
(select *
from ranking_region
where ranked =1),
--comparing 2023 
compared_2023 as
(select y.years,
       y.city,
       y.customer_id,
       y.total_revenue,
       lag(y.total_revenue) over(partition by y.city,y.customer_id order by y.years asc) as prev,
       y.total_revenue- lag(y.total_revenue) over(partition by y.city,y.customer_id order by y.years asc) as diff
from year_city_rev as y
right join top_1_region as t
on y.customer_id=t.customer_id
and y.city=t.city)
select *,
       case
       when diff is null then 'unknown'
       when diff > 0 then 'growth'
       when diff < 0 then 'fall'
       else 'breakeven'
       end trend
from compared_2023;


--For each city, find the customer who was ranked in the Top 3 in both 2023 and 2024, and among those customers, return the one with the highest combined revenue across both years.
with year_city_rev as   
(select year(o.order_date) as years,
       c.city,
       o.customer_id,
       sum(sales) as total_revenue
from Orders$ as o
inner join Customers$ as c
on o.customer_id = c.customer_id
group by year(o.order_date),
       c.city,
       o.customer_id),
--filter of 2023
data_2023 as
(select *,
        rank() over(partition by city order by total_revenue desc) as ranked     
from year_city_rev
where years =2023),
--filter of 2024
data_2024 as
(select *,
        rank() over(partition by city order by total_revenue desc) as ranked
from year_city_rev
where years = 2024),
--combined data
combined_data as
(select d.years,
       d.city,
       d.customer_id,
       d.total_revenue
from data_2023 as d
inner join data_2024 as a
on d.city=a.city and 
   d.customer_id =a.customer_id
where d.ranked <=3 and
      a.ranked <=3),
data_2023_2024 as
(select y.years,
       y.city,
       y.customer_id,
       sum(y.total_revenue) as combined_rev
from year_city_rev as y
inner join combined_data as c
on    y.city=c.city and
      y.customer_id =c.customer_id
      group by y.years,y.city,y.customer_id)
select *
from data_2023_2024

     
   



