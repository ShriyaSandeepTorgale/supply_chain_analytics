-- 1.Calculate month-over-month order count change using LAG
with cte as(
select month(str_to_date(order_date,'%m/%d/%Y %H:%i')) as month,
       year(str_to_date(order_date,'%m/%d/%Y %H:%i')) as year,
       count(*) as total_orders from orders
group by year,month
)
select month,year,total_orders,
lag(total_orders,1) over(order by  year,month) as prev_month_orders,
total_orders-lag(total_orders,1) over(order by  year,month) as mom_change 
from cte
order by year,month;



-- 2.Rank customers by total purchase amount using RANK() partitioned by customer segment
with cte as (select t3.customer_id,t3.customer_fname,t3.customer_lname ,t3.customer_segment,sum(t2.sales) as total_sales  from orders t1
inner join order_items t2 on 
t1.order_id=t2.order_id 
inner join customers t3 on
t3.customer_id=t1.customer_id
group by t3.customer_id,t3.customer_fname,t3.customer_lname,t3.customer_segment
) 

select customer_id,customer_fname,customer_lname,customer_segment,total_sales,
rank() over(partition by customer_segment order by total_sales desc) as rank_within_segment
from cte
order by customer_segment,rank_within_segment;



-- 3.Calculate running total of sales ordered by order date using SUM() OVER
with cte as 
(select date(str_to_date(t1.order_date,'%m/%d/%Y %H:%i')) as order_day, sum(t2.sales) as 'total_sales' from order_items t2 
inner join orders t1 on
t1.order_id=t2.order_id
group by t1.order_date)

select order_day,total_sales ,
sum(total_sales) over(order by order_day ) as running_total
from cte;



--4. Find the top 3 products per department by total sales using ROW_NUMBER()
with cte as 
(select t2.department_name, t1.product_name ,sum(t3.sales) as total_sales from products t1
inner join departments t2 on t1.department_id=t2.department_id
inner join order_items t3 on t1.product_card_id=t3.product_card_id
group by t2.department_name, t1.product_name),

ranked as (select department_name,product_name,total_sales,
row_number() over(partition by department_name order by total_sales desc) as 'row_num'
from cte)

select * from ranked 
where row_num<=3;



-- 5.Calculate 3-month moving average of monthly revenue

with cte as
(select 
year( str_to_date(t1.order_date,'%m/%d/%Y %H:%i')) as 'year_no',
month( str_to_date(t1.order_date,'%m/%d/%Y %H:%i')) as 'month_no', round(sum( t2.sales),2) as total_sales from orders t1
inner join order_items t2 on 
t1.order_id=t2.order_id
group by year_no,month_no
order by year_no,month_no);

select *, 
avg(total_sales) over(order by year_no,month_no rows between 2 preceding and current row ) as moving_3mon_avg
from cte
order by year_no, month_no;



-- For each shipping mode, show the cumulative late delivery count over time
with cte as
(select shipping_mode , 
year(str_to_date(order_date,'%m/%d/%Y %H:%i')) as 'year_no',
month(str_to_date(order_date,'%m/%d/%Y %H:%i')) as 'month_no',
sum(late_delivery_risk) as monthly_late_count
from orders
where late_delivery_risk=1
group by shipping_mode , year_no,month_no)

select *,
sum(monthly_late_count) over(partition by shipping_mode order by year_no,month_no rows between unbounded preceding and current row) as cumulative_late_count
from cte
order by shipping_mode,year_no,month_no