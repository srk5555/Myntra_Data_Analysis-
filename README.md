# 🛍️ Myntra Sales Dashboard (Power BI + SQL)

![Dashboard Page 1](./82fe6078-f1ed-4d2e-9b63-5d1c923c43c7.png)
![Dashboard Page 2](./c934142a-27de-4dcd-8ffb-d2d698702143.png)

## 📌 Project Overview

This project showcases an end-to-end **sales dashboard** for *Myntra*, built using **Power BI** for dynamic visualization and **MS SQL Server** for robust backend data handling.

The dashboard is designed to track key performance indicators (KPIs), visualize customer behavior, and provide business insights such as revenue by brand, product performance, state-wise sales, and more.

---

## 🔧 Tools & Technologies

- **Power BI** — For dynamic, interactive dashboard creation.
- **Microsoft SQL Server** — Used as the primary data source for querying and validating KPIs.
- **SQL** — Core querying language for data manipulation and validation.
- **DAX (in Power BI)** — For custom metrics and calculated columns.

---

## 📊 KPIs Tracked

| Metric             | Description                             |
|--------------------|-----------------------------------------|
| `original_sales_amt` | Total original price of products        |
| `total_sales_amount` | Net sales after discounts               |
| `total_products`     | Number of unique products               |
| `total_orders`       | Total number of orders placed           |
| `avg_ratings`        | Average product rating across sales     |

---

## 📈 Visual Insights (Page 1 Highlights)

- **Sales by Day & Category**  
- **Sales by Brand Name**  
- **State-wise Category Performance**  
- **Orders by Product Name**  
- **Customer Age, Size, and City Filters**

---

## 📈 Visual Insights (Page 2 Highlights)

- **Top/Bottom 5 Products by Revenue**  
- **Top/Bottom 5 Brands by Revenue**  
- **Total Revenue by Size**  
- **Brand Popularity by Orders**

---

## 🗄️ SQL Backend Logic

All KPIs and visuals are validated using SQL queries. The queries are saved in [View Full SQL KPI Queries](https://github.com/srk5555/Myntra_Data_Analysis-/blob/main/SQL_Kpis.sql)
. Below is a glimpse of the structure:

### 📌 Sample SQL Queries Used

```sql
-- Database Creation
CREATE DATABASE myntra_DataAnalysis;
USE myntra_DataAnalysis;

-- Sample KPI Calculation
SELECT SUM(original_price) AS original_sales_amt FROM fact_table;
SELECT SUM(discounted_price) AS total_sales_amount FROM fact_table;
SELECT COUNT(DISTINCT product_id) AS total_products FROM fact_table;
SELECT COUNT(order_id) AS total_orders FROM fact_table;
SELECT ROUND(AVG(rating), 2) AS avg_ratings FROM fact_table;

-- Visuals: Total Sales by Brand
SELECT brand_name, SUM(discounted_price) AS total_sales_amount
FROM fact_table
GROUP BY brand_name
ORDER BY total_sales_amount DESC;
