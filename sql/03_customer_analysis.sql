-- 1.How many customers exist per customer segment?
SELECT customer_segment, count(distinct (customer_id)) as 'total_customers'
FROM supply_chain_db.customers
group by
    customer_segment;


-- 2.Which top 10 customers have placed the most orders?
select count( o.customer_id) as total_orders,c.customer_fname,c.customer_lname from customers c
inner join orders o on c.customer_id=o.customer_id
group by c.customer_id,c.customer_fname,c.customer_lname
order by count( o.customer_id) desc limit 10; 


-- 3.Which customer segment has the highest average order value?
select t3.customer_segment,avg(t1.sales) as avg_order_value from order_items t1 
inner join orders t2 on t2.order_id=t1.order_id
inner join customers t3 on t3.customer_id=t2.customer_id
group by t3.customer_segment
order by avg(t1.sales) desc ;


-- 4.How many unique customers placed orders per market?
select market,count(distinct customer_id) as no_of_customers from orders
group by market
order by no_of_customers desc;


-- 5.Which top 5 countries have the most customers?
select order_country,count(distinct customer_id) as no_customers from orders
group by order_country
order by no_customers desc limit 5;


-- 6.Rank customers by total spending using a window function
select t3.customer_fname,t3.customer_lname,t3.customer_id,
sum(t1.sales) as avg_order_value, 
rank()over(order by sum(t1.sales ) desc )as ranking from order_items t1 
inner join orders t2 on t2.order_id=t1.order_id
inner join customers t3 on t3.customer_id=t2.customer_id
group by t3.customer_fname,t3.customer_lname,t3.customer_id