

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