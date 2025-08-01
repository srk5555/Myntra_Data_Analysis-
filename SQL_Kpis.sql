use  myntra_DataAnalysis;
-- 1. Total Sales Revenue (after discount)
SELECT 
    ROUND(SUM(original_price * (1 - discount)), 2) AS total_sales_after_discount
FROM fact_table;


-- 2. Total Sales Revenue (before discount)
SELECT 
    SUM(original_price) AS total_sales_before_discount
FROM fact_table;

-- 3 Average of rating
SELECT 
    AVG(Ratings) AS average_rating
FROM Myntra_dataset;

--4 Total orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM fact_table;

--5 Total products
SELECT 
    COUNT(DISTINCT Product_Name) AS total_products
FROM Myntra_dataset;

--Daily Order Trend
SELECT 
    DATENAME(WEEKDAY, CAST(fact_table.Date AS DATE)) AS day_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM fact_table
GROUP BY DATENAME(WEEKDAY, CAST(fact_table.Date AS DATE))
ORDER BY 
    DATEPART(WEEKDAY, CAST(MIN(fact_table.Date) AS DATE)); -- ensures correct order of days


--Day-wise Trend with Category-wise Columns 
	-- First: prepare base data (orders, sales by day and category)
WITH DailyCategorySales AS (
    SELECT 
        DATENAME(WEEKDAY, CAST(s.date AS DATE)) AS day_name,
        p.category,
        s.order_id,
        s.original_price * (1 - s.discount) AS discounted_price
    FROM fact_table s
    JOIN Myntra_dataset p ON s.product_id = p.product_id
)

-- Then: pivot to get category-wise sales per day
SELECT 
    day_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(CASE WHEN category = 'Men' THEN discounted_price ELSE 0 END), 2) AS men_sales,
    ROUND(SUM(CASE WHEN category = 'Women' THEN discounted_price ELSE 0 END), 2) AS women_sales,
    ROUND(SUM(CASE WHEN category = 'Kids' THEN discounted_price ELSE 0 END), 2) AS kids_sales,
    ROUND(SUM(CASE WHEN category = 'Beauty' THEN discounted_price ELSE 0 END), 2) AS beauty_sales,
    ROUND(SUM(discounted_price), 2) AS total_sales
FROM DailyCategorySales
GROUP BY day_name
ORDER BY 
    CASE day_name
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;

--Total Revenue by Brand (After Discount)
	SELECT 
    p.Brand_Name,
    ROUND(SUM(s.original_price * (1 - s.discount)), 2) AS total_revenue
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.Brand_Name
ORDER BY total_revenue DESC;


--Total Revenue by Brand & Product Name (After Discount)

SELECT 
    p.brand_name,
    p.product_name,
    ROUND(SUM(s.original_price * (1 - s.discount)), 2) AS total_revenue
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY 
    p.Brand_Name, 
    p.product_name
ORDER BY 
    p.Brand_Name,
    total_revenue DESC;


-- Percentage Share of Revenue by Brand
	WITH brand_revenue AS (
    SELECT 
        p.Brand_Name,
        SUM(s.original_price * (1 - s.discount)) AS revenue
    FROM fact_table s
    JOIN Myntra_dataset p ON s.product_id = p.product_id
    GROUP BY p.Brand_Name
)
SELECT 
    Brand_Name,
    ROUND(revenue, 2) AS brand_revenue,
    ROUND((revenue * 100) / SUM(revenue) OVER (), 2) AS percentage_share
FROM brand_revenue
ORDER BY percentage_share DESC;


--Percentage Share of Revenue by Product
WITH product_revenue AS (
    SELECT 
        p.product_name,
        SUM(s.original_price * (1 - s.discount)) AS revenue
    FROM fact_table s
    JOIN Myntra_dataset p ON s.product_id = p.product_id
    GROUP BY p.product_name
)
SELECT 
    product_name,
    ROUND(revenue, 2) AS product_revenue,
    ROUND((revenue * 100.0) / SUM(revenue) OVER (), 2) AS percentage_share
FROM product_revenue
ORDER BY percentage_share DESC;


--Percentage Share of Revenue by Category
WITH category_revenue AS (
    SELECT 
        p.category,
        SUM(s.original_price * (1 - s.discount)) AS revenue
    FROM fact_table s
    JOIN Myntra_dataset p ON s.product_id = p.product_id
    GROUP BY p.category
)
SELECT 
    category,
    ROUND(revenue, 2) AS category_revenue,
    ROUND((revenue * 100.0) / SUM(revenue) OVER (), 2) AS percentage_share
FROM category_revenue
ORDER BY percentage_share DESC;


--Total Sales by State with Categories in Columns
SELECT 
    state,
    ISNULL([Men], 0) AS Men_Sales,
    ISNULL([Women], 0) AS Women_Sales,
    ISNULL([Kids], 0) AS Kids_Sales,
    ISNULL([Beauty], 0) AS Beauty_Sales,
    ROUND(ISNULL([Men], 0) + ISNULL([Women], 0) + ISNULL([Kids], 0) + ISNULL([Beauty], 0), 2) AS Total_Sales
FROM (
    SELECT 
        c.state,
        p.category,
        s.original_price * (1 - s.discount) AS sales_amount
    FROM fact_table s
    JOIN Myntra_dataset p ON s.product_id = p.product_id
    JOIN dim_customers c ON s.customer_id = c.customer_id
) AS source_table
PIVOT (
    SUM(sales_amount)
    FOR category IN ([Men], [Women], [Kids], [Beauty])
) AS pivot_table
ORDER BY Total_Sales DESC;


--Brand Distribution (by Count)
SELECT 
    p.Brand_Name,
    COUNT(*) AS brand_order_count
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.Brand_Name
ORDER BY brand_order_count DESC;



--product Distribution (by Count)
SELECT 
    p.product_name,
    COUNT(*) AS product_order_count
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_order_count DESC;




--Top 5 Products by Revenue
SELECT TOP 5
    p.product_name,
    SUM(s.original_price * (1 - s.discount / 100.0)) AS total_revenue
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;



--Bottem 5 Products by Revenue
SELECT top 5
    p.product_name,
    SUM(s.original_price * (1 - s.discount / 100.0)) AS total_revenue
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue asc;




--Top 5 Brands by Revenue
SELECT TOP 5
    p.Brand_Name,
    SUM(s.original_price * (1 - s.discount / 100.0)) AS total_revenue
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.Brand_Name
ORDER BY total_revenue DESC;




--Bottom 5 Brands by Revenue
SELECT TOP 5
    p.Brand_Name,
    SUM(s.original_price * (1 - s.discount / 100.0)) AS total_revenue
FROM fact_table s
JOIN Myntra_dataset p ON s.product_id = p.product_id
GROUP BY p.Brand_Name
ORDER BY total_revenue asc;