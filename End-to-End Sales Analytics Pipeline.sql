

CREATE DATABASE superstore;
USE superstore;

CREATE TABLE orders (
    ship_mode       VARCHAR(50),
    segment         VARCHAR(50),
    country         VARCHAR(50),
    city            VARCHAR(50),
    state           VARCHAR(50),
    postal_code     INT,
    region          VARCHAR(50),
    category        VARCHAR(50),
    sub_category    VARCHAR(50),
    sales           FLOAT,
    quantity        INT,
    discount        FLOAT,
    profit          FLOAT,
    profit_margin   FLOAT,
    discount_bucket VARCHAR(50)
);
SELECT * FROM orders LIMIT 5;

USE superstore;
SELECT * FROM orders LIMIT 5;

# Top 10 regions by revenue
USE superstore;
select region,
round(sum(sales), 2) as total_revenue,
round(sum(profit)/sum(sales)*100, 2) as profit_margin_pct
from orders
group by region
order by total_revenue DESC;

#Top 10 categories by revenue
select category,
round(sum(sales), 2)as total_revenue,
round(sum(profit), 2) as total_profit,
round(sum(profit)/sum(sales)*100, 2) as profit_margin_pct
from orders
group by category
order by total_revenue DESc;

# Discount impact on profit
select 
discount_bucket,
count(*) as total_orders,
round(avg(profit), 2) as avg_profit,
round(avg(profit_margin), 2)as avg_margin_pct
from orders
group by discount_bucket
order by avg_profit DESC;

# Top 10 customers by revenue
SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS total_orders
FROM orders
GROUP BY segment
ORDER BY total_revenue DESC;

# Sub-category performance
SELECT 
    sub_category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS margin_pct
FROM orders
GROUP BY sub_category
ORDER BY total_profit DESC;

# Region + Category profit matrix (CASE statement)
SELECT 
    region,
    category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    CASE 
        WHEN SUM(profit)/SUM(sales)*100 >= 15 THEN 'High Margin'
        WHEN SUM(profit)/SUM(sales)*100 >= 5  THEN 'Medium Margin'
        ELSE                                       'Low Margin'
    END AS margin_category
FROM orders
GROUP BY region, category
ORDER BY total_profit DESC;

# Customer segment ranking (Window Function)
SELECT 
    segment,
    region,
    ROUND(SUM(sales), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS revenue_rank
FROM orders
GROUP BY segment, region
ORDER BY total_revenue DESC;

# Top performing sub-categories using CTE
WITH category_performance AS (
    SELECT 
        category,
        sub_category,
        ROUND(SUM(sales), 2)  AS total_revenue,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(SUM(profit)/SUM(sales)*100, 2) AS margin_pct
    FROM orders
    GROUP BY category, sub_category
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY category ORDER BY total_profit DESC) AS rank_in_category
    FROM category_performance
)
SELECT * FROM ranked
ORDER BY category, rank_in_category;


# Discount vs profit analysis (CASE + GROUP BY)
SELECT 
    CASE 
        WHEN discount = 0    THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low (1-20%)'
        WHEN discount <= 0.4 THEN 'Medium (21-40%)'
        ELSE                      'High (41%+)'
    END AS discount_level,
    COUNT(*)                        AS total_orders,
    ROUND(SUM(sales), 2)            AS total_revenue,
    ROUND(SUM(profit), 2)           AS total_profit,
    ROUND(AVG(profit_margin), 2)    AS avg_margin_pct
FROM orders
GROUP BY discount_level
ORDER BY avg_margin_pct DESC;

# State wise performance (Top 10)
SELECT 
    state,
    region,
    ROUND(SUM(sales), 2)  AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*)              AS total_orders
FROM orders
GROUP BY state, region
ORDER BY total_profit DESC
LIMIT 10;




# Region revenue ranking(rank)
use superstore;
select region,
round(sum(sales), 2)as total_sales,
rank() over(order by sum(sales)desc) as rank_no
from orders
group by region;

# sub category revenue ranking
select sub_category,
round(sum(sales), 2)as total_sales,
round(sum(profit),2)as total_profit,
rank() over(order by sum(sales) desc)as rank_no
from orders
group by sub_category;

# profit change using LAG
select sub_category, 
round(sum(profit),2) as current_profit,
round(LAG(SUM(profit)) over(order by sum(profit) desc),2) as prev_profit,
round(sum(profit) - LAG(sum(profit)) over(order by sum(profit) desc),2) as profit_change
from orders
group by sub_category;


# top categories per region
with category_rank as(
select region, category, round(sum(sales),2) as total_sales,
rank() over(partition by region order by sum(sales) desc) as rank_no
from orders
group by region, category
)
select * from category_rank
where rank_no=1;

# Discount impact with CASE
SELECT 
    CASE 
        WHEN discount = 0    THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low (1-20%)'
        WHEN discount <= 0.4 THEN 'Medium (21-40%)'
        ELSE                      'High (41%+)'
    END AS discount_level,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(AVG(profit_margin), 2) AS avg_margin_pct
FROM orders
GROUP BY discount_level
ORDER BY avg_profit DESC;

-- ==========================================================================
-- CUSTOMER ANALYSIS
-- =======================================================

# revenue by segment
select segment, round(sum(sales),2) as tootal_revenue,
round(sum(profit),2) as total_profit,
count(*) as togtal_orders,
round(AVG(sales), 2) as avg_order_value,
round(sum(profit)/sum(sales)* 100,2)as profit_margin_pct
from orders
group by segment
order by total_revenue desc;

# best segment per region
with segment_rank as(
select region, segment, 
round(sum(sales), 2) as total_revenue, 
rank() over(partition by region order by sum(sales) desc) as rank_no
from orders
group by region, segment
)
select * from segment_rank
where rank_no=1;

# avg order value by segment
select segment,
count(*) as total_orders,
round(avg(sales), 2)as avg_order_value,
round(min(sales), 2) as min_order_value,
round(max(sales),2) as max_order_value
from orders
group by segment
order by avg_order_value desc;

# segment profit ranking by region
select segment, region,
round(sum(sales), 2) as total_revenue,
round(sum(profit), 2) as total_profit,
rank() over(partition by segment order by sum(profit) desc) as profit_rank
from orders
group by segment, region
order by segment, profit_rank;

# high value order by segment
select segment, category,
count(*) as total_orders,
round(sum(sales),2) as total_revenue,
round(avg(sales),2)as avg_order_value
from orders
where sales> 500
group by segment,category
order by total_revenue desc;
 
 
-- =====================
-- TREND ANALYSIS
-- =====================

-- Query 1: Sales trend by Category
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin_pct,
    COUNT(*) AS total_orders
FROM orders
GROUP BY category
ORDER BY total_revenue DESC;

-- Query 2: Sales trend by Region and Category
SELECT 
    region,
    category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS total_orders
FROM orders
GROUP BY region, category
ORDER BY region, total_revenue DESC;

-- Query 3: Sub-category growth ranking
SELECT 
    sub_category,
    category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    RANK() OVER(ORDER BY SUM(sales) DESC) AS growth_rank
FROM orders
GROUP BY sub_category, category
ORDER BY growth_rank;

-- Query 4: Segment trend by Region
SELECT 
    segment,
    region,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin_pct
FROM orders
GROUP BY segment, region
ORDER BY segment, total_revenue DESC;

-- Query 5: Quantity trend by Category
SELECT 
    category,
    sub_category,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(AVG(sales), 2) AS avg_sale_per_order,
    RANK() OVER(ORDER BY SUM(quantity) DESC) AS quantity_rank
FROM orders
GROUP BY category, sub_category
ORDER BY total_quantity DESC;

-- Query 6: Discount trend by Region
SELECT 
    region,
    ROUND(AVG(discount)*100, 2) AS avg_discount_pct,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS total_orders
FROM orders
GROUP BY region
ORDER BY avg_discount_pct DESC;
