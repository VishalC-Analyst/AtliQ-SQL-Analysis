-- TOP markets and customers:

select 
           market,
           round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales
where fiscal_year=2021
group by market
order by net_sales_mln desc
limit 5

------------------------------------------------------------------------------------------------------------------------

-- We might need to repeat this again, so it is better to save this as a stored procedure!!

# We have stored it

call gdb0041.get_top_n_markets_by_net_sales(2020, 3);

------------------------------------------------------------------------------------------------------------------------

# TOP CUSTOMERS:

select 
           c.customer,
           round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales n
join dim_customer c
on n.customer_code = c.customer_code
where fiscal_year=2021
group by c.customer
order by net_sales_mln desc
limit 5

call gdb0041.get_top_n_customers_by_net_sales('India', 2021, 3);

------------------------------------------------------------------------------------------------------------------------

# TOP PRODUCT:

select 
           product,
           round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales n
join dim_customer c
on n.customer_code = c.customer_code
where fiscal_year=2021
group by product 
order by net_sales_mln desc
limit 5

call gdb0041.get_top_n_products_by_net_sales(2021, 3);