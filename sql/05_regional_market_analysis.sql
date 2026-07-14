-- 1.What is the total number of orders per market?
select market,count(order_id) as total_orders from orders
group by market
order by total_orders desc

-- 2.What is the total revenue per market?
select t2.market, round(sum(t1.sales),2) as total_revenue from order_items t1
inner join orders t2 on t1.order_id=t2.order_id
group by t2.market
order by total_revenue desc


-- 3.Which top 5 regions have the highest late delivery risk?
select order_region,round((sum(late_delivery_risk)/count(*)),2)*100 as percentage_delivery_risk from orders
group by order_region
order by percentage_delivery_risk desc;


-- 4.Which market has the highest average profit per order?
select t1.market,round(avg(t2.order_profit_per_order),2) as avg_profit_per_order from orders t1 
inner join order_items t2 on t1.order_id=t2.order_id
group by t1.market
order by avg_profit_per_order desc limit 1;


--5. What is the late delivery rate (%) per market?
select market , round(sum(late_delivery_risk)/count(*)*100,2) as late_delivery_rate from orders
group by market
order by late_delivery_rate desc;


-- 6.Which top 5 order countries generate the most revenue?
select t1.order_country,round(sum(t2.sales),2) as total_revenue from orders t1
inner join order_items t2 on
t1.order_id=t2.order_id
group by order_country
order by total_revenue desc limit 5;

-- 7.Which region has the highest average days gap between real and scheduled shipping?
 select order_region,avg( days_for_shipping_real-days_for_shipment_scheduled) as avg_days_gap from orders
 group by order_region
 order by avg_days_gap desc limit 1;