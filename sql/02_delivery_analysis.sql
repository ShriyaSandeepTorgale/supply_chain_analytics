-- 1.How many orders were delivered late vs on time? Show the count and percentage of each
SELECT CASE 
    WHEN late_delivery_risk = 0 THEN 'On Time'
    WHEN late_delivery_risk = 1 THEN 'Late'
END AS delivery_result,
count(*) as total,
(count(*)/(select count(*) from supply_chain_db.orders)) * 100 as percentage 
FROM supply_chain_db.orders
group by late_delivery_risk;


-- 2.What is the total number of orders per delivery status category?
select delivery_status,count(*) from orders
group by delivery_status;


-- 3.What is the total sales revenue per customer segment?
SELECT t3.customer_segment ,sum(t1.sales) FROM order_items t1 
inner join orders t2 on t1.order_id= t2.order_id
join customers t3 on t2.customer_id=t3.customer_id
group by t3.customer_segment ;


-- 4.What is the average real shipping days vs scheduled shipping days per shipping mode?
SELECT shipping_mode,
avg(days_for_shipping_real),
avg(days_for_shipment_scheduled) FROM orders
group by shipping_mode;


-- 5.Which top 5 markets have the highest late delivery count?
select count(late_delivery_risk) as 'late_delivery_count',market from orders
where late_delivery_risk='1'
group by market 
order by count(late_delivery_risk) desc limit 5;


-- 6.What percentage of orders are late per shipping mode?
select  shipping_mode,
(sum(late_delivery_risk)/count(*)) * 100 as percentage from orders
group by shipping_mode;


-- 7.How many orders were late per month? (use order_date column)
select monthname(
      str_to_date(order_date,'%m/%d/%Y %H:%i')) as month_name,
      year(str_to_date(order_date,'%m/%d/%Y %H:%i')) as year_name,
      sum(late_delivery_risk) as late_orders from orders
      
      group by monthname(str_to_date(order_date,'%m/%d/%Y %H:%i')),
      year(str_to_date(order_date,'%m/%d/%Y %H:%i')) 
      
      order by monthname(str_to_date(order_date,'%m/%d/%Y %H:%i')),
      year(str_to_date(order_date,'%m/%d/%Y %H:%i'));


 -- 8.Which shipping mode has the worst on-time delivery rate (as a percentage)?
      select shipping_mode , 
      (sum(late_delivery_risk)/count(*))*100 as percentage from orders
      group by shipping_mode 
      order by percentage desc limit 1;

