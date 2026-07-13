-- 1.How many products exist per department?
select t2.department_name, count(t1.product_card_id) as no_products from products t1
inner join departments t2 on t1.department_id=t2.department_id
group by t2.department_name
order by no_products desc;


-- 2.What is the average product price per category?
select t2.category_name, avg(t1.product_price) as avg_price from products t1 
inner join categories t2 on t2.category_id=t1.category_id
group by t2.category_name;


-- 3.Which top 10 products generated the highest total sales?
select t1.product_card_id,t1.product_name,sum(t2.sales) as total from products t1
inner join order_items t2 on t2.product_card_id=t1.product_card_id
group by t1.product_card_id,t1.product_name
order by total desc limit 10;


--4.Which top 10 products have the highest total profit?
select t1.product_card_id,t2.product_name,sum(t1.order_profit_per_order) as total_profit from order_items t1
inner join products t2 on t1.product_card_id=t2.product_card_id
group by t1.product_card_id,t2.product_name
order by total_profit desc limit 10


-- 5.Which products have a negative profit (loss-making)?
select t1.product_card_id, t2.product_name,
SUM(t1.order_profit_per_order) AS total_profit from order_items t1
inner join products t2 on t2.product_card_id=t1.product_card_id
group by t1.product_card_id, t2.product_name HAVING SUM(t1.order_profit_per_order) < 0
order by total_profit asc ;


--6. What is the total revenue and profit per department?
select t3.department_name, round(sum(t1.order_profit_per_order),2) as profit , round(sum(t1.sales),2) as revenue from order_items t1 
inner join products t2 on t2.product_card_id=t1.product_card_id
inner join departments t3 on t3.department_id=t2.department_id
group by t3.department_name
order by profit desc,revenue desc;


--7. Which category has the highest average profit ratio?
select t3.category_name ,round(avg(t1.order_item_profit_ratio),2) as avg_profit_ratio from order_items t1
inner join products t2 on t1.product_card_id=t2.product_card_id
inner join categories t3 on t2.category_id=t3.category_id
group by t3.category_name
order by avg_profit_ratio desc  limit 1;


-- 8.How does discount rate affect profit ratio? (group discount_rate into bins using CASE)
SELECT 
    CASE 
        WHEN order_item_discount_rate = 0    THEN 'No Discount'
        WHEN order_item_discount_rate < 0.1  THEN 'Low'
        WHEN order_item_discount_rate < 0.2  THEN 'Medium'
        ELSE 'High'
    END AS discount_category,
    ROUND(AVG(order_item_profit_ratio), 2) AS avg_profit_ratio,
    COUNT(*) AS total_orders
FROM order_items
GROUP BY discount_category
ORDER BY avg_profit_ratio DESC;