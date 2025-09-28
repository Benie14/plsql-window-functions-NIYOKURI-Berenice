-- 1. Top 5 Products per Region (RANK)
SELECT region, product_name, total_sales, sales_rank
FROM (
    SELECT 
        c.region,
        p.name as product_name,
        SUM(t.amount) as total_sales,
        RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) as sales_rank
    FROM transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    JOIN products p ON t.product_id = p.product_id
    GROUP BY c.region, p.name
)
WHERE sales_rank <= 5
ORDER BY region, sales_rank;
-- 2. Running Monthly Sales Totals (SUM OVER)
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') as sale_month,
    SUM(amount) as monthly_sales,
    SUM(SUM(amount)) OVER (ORDER BY TO_CHAR(sale_date, 'YYYY-MM')) as running_total
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sale_month;
-- 3. Month-over-Month Growth (LAG)
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') as sale_month,
        SUM(amount) as monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    sale_month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY sale_month) as prev_month_sales,
    ROUND(((monthly_sales - LAG(monthly_sales) OVER (ORDER BY sale_month)) / 
          LAG(monthly_sales) OVER (ORDER BY sale_month)) * 100, 2) as growth_pct
FROM monthly_sales
ORDER BY sale_month;
-- 4. Customer Spending Quartiles (NTILE)
SELECT 
    c.name,
    c.region,
    SUM(t.amount) as total_spent,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) as spending_quartile
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_spent DESC;
-- 5. 3-Month Moving Averages (AVG OVER)
WITH monthly_data AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') as sale_month,
        SUM(amount) as monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    sale_month,
    monthly_sales,
    ROUND(AVG(monthly_sales) OVER (
        ORDER BY sale_month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) as three_month_moving_avg
FROM monthly_data
ORDER BY sale_month;
