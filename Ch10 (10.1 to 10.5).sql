-- Chapter 10: Problem statement and Pre-invoice discount report

# Want a report for TOP MARKET; PRODUCT; CUSTOMER by NET SALES for given financial year.

select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = get_fiscal_year (s.date)
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = get_fiscal_year(s.date)
where 
	      s.customer_code = 90002002 and 
          get_fiscal_year(date)=2021 
order by date asc
limit 1000000;

# The above gives the report for the particular customer code = 90002002 (croma india)

-- NOW TO GET THE REPORT OF NET SALES FOR ALL THE CUSTOMER???

select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = get_fiscal_year (s.date)
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = get_fiscal_year(s.date)
where 
	      get_fiscal_year(date)=2021 
order by date asc
limit 1000000;

# By writing this query it took few seconds to geenrate the report, the performance is slow 
# NOW WE NEED TO OPTIMIZE THE PERFORMANCE!!  ---------------------- BUT HOW???? 

------------------------------------------------------------------------------------------ IN UPCOMING SESSION WILL LEARN :)


-- Let's see how to minimize the DURATION TIME???

-- use EXPLAIN ANALYZE

EXPLAIN ANALYZE
select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = get_fiscal_year (s.date)
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = get_fiscal_year(s.date)
where 
	      get_fiscal_year(date)=2021 
order by date asc
limit 1000000;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# WE COULD SEE THAT DATES ARE REUSED, So to improve preformance
-- OPTION 1: WE ARE CREATING A NEW TABLE dim_date 

EXPLAIN ANALYZE
select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join dim_date dt
       on dt.calendar_date = s.date
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = dt.fiscal_year
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = dt.fiscal_year
where 
	      get_fiscal_year(date)=2021 
order by date asc
limit 1000000;
---------------------------------------------------------------------------------------------------------------------------

# To improve performance OPTION 2:

-- Add a fiscal_year in fact_sales_monthly

select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = s.fiscal_year
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = s.fiscal_year
where 
	      s.fiscal_year=2021 
limit 1000000;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Let's calculate NET INVOICE SALES:

select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct,
         (gross_price_total - gross_price_total*pre.pre_invoice_discount_pct) as net_invoice_sales
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = s.fiscal_year
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = s.fiscal_year
where 
	      s.fiscal_year=2021 
          
-- ===> THIS WILL GIVE ERROR!!
Error Code: 1054. Unknown column 'gross_price_total' in 'field list'

-- WE USE CTE

WITH cte1 as
(select 
         s.date, s.product_code, p.product, 
		 p.variant, s.sold_quantity, g.gross_price,
         ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total,
         pre.pre_invoice_discount_pct
from fact_sales_monthly s
join dim_product p
       on p.product_code = s.product_code
join fact_gross_price g
      on g.product_code = s.product_code and 
       g.fiscal_year = s.fiscal_year
join fact_pre_invoice_deductions pre
	  on pre.customer_code = s.customer_code and
	   pre.fiscal_year = s.fiscal_year
where 
	      s.fiscal_year=2021)
select 
		 *,
         (gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales
from cte1

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DISPLAY POST INVOICE DISCOUNT:

-- what if i can store cte1 in my database, as i use it frequently???

-- we can create a virtual table = DATABASE VIEWS

select 
		 *,
         (gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales
from sales_pre_invoice_discount
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#NOW WILL SEE: Dataviews post invoice discount, Net sales

-- SIMPLIFIED WAY

select 
		 *,
         (1-pre_invoice_discount_pct)*gross_price_total as net_invoice_sales,
         (po.discounts_pct + po.other_deductions_pct) as post_invoice_discount_pct
from sales_pre_invoice_discount s
join fact_post_invoice_deductions po
on s.date = po.date 
and s.product_code = po.product_code
and s.customer_code = po.customer_code

SELECT 
            *,
              (1-post_invoice_discount_pct)*net_invoice_sales as net_sales
FROM gdb0041.sales_post_invoice_discount;
