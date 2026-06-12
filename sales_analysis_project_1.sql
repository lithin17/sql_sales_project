
--ANALYSING CUSTOMERS TABLE
select *
from Customers$;


--total number of customers.
select distinct count(*) 
from Customers$;
-- we have a  total of 100 customers in customer base.


--total cities
select distinct city
from Customers$;
-- we have customer base  in 10 cities all over india .

--types of customers
select distinct segment 
from Customers$
--we have 3 types of customers in our customer base .

--customers from each city
select city,
       count(*) as total_count
from Customers$
group by city
order by total_count desc
--we can see that we have highest customer base from hyd,delhi which are 14 and combining it is 28 % of total customer base.


--customer type
select segment,
       count(*) as total_customers
from Customers$
group by segment
order by total_customers desc
--here most of our customers are from home office and consumer and corporate.


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
--INSIGHT: here we have total of 3 categories of products .

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







     
   



