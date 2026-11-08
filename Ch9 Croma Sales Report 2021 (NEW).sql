-- Croma India Product wise sales report for fiscal year 2021

-- As a product owner, I want to generate a report of individual product sales (aggregated on a monthly basis at the product code level)
-- for Croma India customer for FY=2021 so that I can track individual product sales and run further product analytics on it in excel.

-- THE REPORT SHOULD HAVE FOLLOWING FIELDS:
# Month
# Product Name
# Varient
# Sold quantity
# Gross Price Per Item
# Gross Price Total
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1st I want to know the croma code for customer india;
SELECT * FROM gdb0041.dim_customer
WHERE customer like "%croma%";

-- In this case the market is only INDIA, but what if there are so many other markets and you want INDIA???
SELECT * FROM gdb0041.dim_customer
WHERE customer like "%croma%"
AND market="india";
# CODE: 90002002

select * from fact_sales_monthly
where customer_code = 90002002;
-- This shows the transations for croma india

--- aggregated on a monthly basis at the product code level = Means all sold quantity for each product separately for that month
-- Aggregation is already done by the data engineer, so we need to find the data for calander year 2021

select * from fact_sales_monthly
where 
          customer_code = 90002002 and 
          year (date) = 2021
order by date desc;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- HOW DO YOU CONVERT CALENDER YEAR TO FISCAL YEAR??

# AtilQ starts with SEP every year.
# SEP 2020 - 2021 1st year
# 09-2020 -> 1st month of 2021 
# 10-2020 -> 2nd month of 2021

-- For this, search in google = Mysql add month to date (Art of Googling!!!)
-- USE DATE_ADD

SELECT DATE_ADD("2020-09-01", INTERVAL 4 MONTH);
SELECT DATE_ADD("2020-10-01", INTERVAL 4 MONTH);

-- FISCAL YEAR = YEAR(DATE_ADD(date, INTERVAL 4 MONTH))

select * from fact_sales_monthly
where 
          customer_code = 90002002 and
          Year (date_add(date,interval 4 month))
order by date desc;
-- This gives all the 2021 fiscal year data!!
          
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Formula: We can create user defined function. "GO TO FUNCTIONS IN SCHEME => CREATE"

select * from fact_sales_monthly
where 
          customer_code = 90002002 and 
          get_fiscal_year(date)=2021
order by date asc;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- What if the manager says i want the report for only 2021 and quater 4??

# MONTH 9,10,11 = Q1
# MONTH 12,1,2 = Q2
# MONTH 3,4,5 = Q3
# MONTH 6,7,8 = Q4
# THEREFORE 'Q4' = 6,7,8 MONTH

select * from fact_sales_monthly
where 
          customer_code = 90002002 and 
          get_fiscal_year(date)=2021
          get_fiscal_quarter(date)="Q4"
order by date asc;
# the above is a sample query for how it has to begin

-- How do u get a month from a give date??
# USE: MONTH FUNCTION
SELECT MONTH ("2019-04-01");

-- LETS CREATE A NEW FUNCTION = get_fiscal_quarter

select gdb0041.get_fiscal_quarter('2020-09-01');

select * from fact_sales_monthly
where 
          customer_code = 90002002 and 
          get_fiscal_year(date)=2021 and
          get_fiscal_quarter(date)="Q4"
order by date asc
LIMIT 1000000;
# This gives the details of customer (90002002) for the year 2021 and quater 4 in ascending order with limit of 1000000

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# PRODUCT AND VARIANT USING JOIN:

select 
          s.date, s.product_code,
          p.product, p.variant, s.sold_quantity
from  fact_sales_monthly s
join   dim_product p
on 
	      p.product_code = s.product_code 
where 
          customer_code = 90002002 and 
          get_fiscal_year(date)=2021 and
          get_fiscal_quarter(date)="Q4"
order by date asc
LIMIT 1000000;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# GROSS PRICE PER ITEM AND GROSS PRICE TOTAL USING JOIN

select 
          s.date, s.product_code,
          p.product, p.variant, s.sold_quantity,
          g.gross_price
from  fact_sales_monthly s
join   dim_product p
on 
	      p.product_code = s.product_code
join fact_gross_price g
on 
         g.product_code = s.product_code and 
         g.fiscal_year = get_fiscal_year(s.date)
where 
          customer_code = 90002002 and 
          get_fiscal_year(date)=2021 and
          get_fiscal_quarter(date)="Q4"
order by date asc
LIMIT 1000000;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Now the last field = Gross price total
# what to do?? Multiply sold_quantity with gross_price

select 
s.date, s.product_code, p.product, 
p.variant, s.sold_quantity, g.gross_price,
ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total
from fact_sales_monthly s
join dim_product p
on 
     p.product_code = s.product_code
join fact_gross_price g
on  
      g.product_code = s.product_code and 
g.fiscal_year = get_fiscal_year (s.date)
where 
          customer_code = 90002002 and 
          get_fiscal_year(date)=2021 
order by date asc
limit 1000000;

