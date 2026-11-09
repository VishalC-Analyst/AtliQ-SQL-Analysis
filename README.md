# AtliQ Hardware: SQL Sales Analytics and Reporting

SQL project on the AtliQ Hardware sales database (MySQL), building business reports from gross sales to net sales, ranking top markets, customers and products, and automating them with functions, stored procedures and views.

## Business Questions
- How much does a key customer (Croma India) buy, by product, month and fiscal year?
- What are gross sales vs net sales after pre-invoice and post-invoice discounts?
- Which markets, customers and products lead on net sales in a given fiscal year?
- How can these reports be reused without rewriting the SQL each time?

## What I Built

### Chapter 9: Reports, Functions and Stored Procedures
- **Fiscal year function:** `get_fiscal_year()` converts calendar dates to AtliQ's fiscal year (starts in September)
- **Product-level sales report** for Croma India (FY2021): joins sales, product and gross price tables to calculate gross price per item and total
- **Monthly and yearly gross sales reports** for a customer
- **Stored procedures:**
  - `get_monthly_gross_sales_for_customer`: monthly sales for one or more customers
  - `get_market_batch`: gives a market a Gold or Silver badge based on total quantity sold

### Chapter 10: Net Sales, Window Functions and Views
- **Pre-invoice and post-invoice discount reports** leading to a net sales calculation
- **Query performance tuning** with `EXPLAIN ANALYZE`: compared a date dimension table against adding a fiscal year column to the fact table
- **CTEs** to calculate net invoice sales from gross sales and discounts
- **Database views:** reusable views for gross sales, sales after pre-invoice discount, and sales after post-invoice discount
- **Window functions:** `DENSE_RANK() OVER (PARTITION BY ...)` for top 3 products per division, and `SUM() OVER()` for each customer's percentage share of net sales, overall and by region
- **Top N stored procedures:** top N markets, customers and products by net sales for a fiscal year

## SQL Concepts Used
Joins (multi-table), aggregation and GROUP BY, CTEs, window functions (DENSE_RANK, SUM OVER, PARTITION BY), user-defined functions, stored procedures, views, date functions, query optimisation (EXPLAIN ANALYZE)

## Tools
MySQL, MySQL Workbench

## Files
All SQL scripts are in this repository:
- **Chapter 9 (files starting with Ch9):** fiscal year function, product and monthly sales reports, stored procedures
- **Chapter 10 (files starting with Ch10):** net sales, window functions, views, top N stored procedures

## Dataset
AtliQ Hardware sample database (`gdb0041`), a practice dataset.

## Author
Vishal C | Business Analyst | Microsoft Certified: Power BI Data Analyst Associate
