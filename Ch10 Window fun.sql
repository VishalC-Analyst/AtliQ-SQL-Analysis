-- WINDOW FUNCTIONS


with cte1 as (
select 
           customer,
           round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales s
join dim_customer c
on s.customer_code = c.customer_code
where s.fiscal_year = 2021
group by customer)

select 
         *,
          net_sales_mln*100/sum(net_sales_mln) over() as pct
from cte1
order by net_sales_mln desc
-----------------------------------------------------------------------------------------------------------------------------------------



select 
           c.customer,
           c.region,
           round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales s
join dim_customer c
on s.customer_code = c.customer_code
where s.fiscal_year = 2021
group by c.customer, c.region
order by net_sales_mln desc

-- percentage calculation per region:

with cte1 as (
select 
           c.customer,
           c.region,
           round(sum(net_sales)/1000000,2) as net_sales_mln
from net_sales s
join dim_customer c
on s.customer_code = c.customer_code
where s.fiscal_year = 2021
group by c.customer, c.region)

select * ,
              net_sales_mln*100/sum(net_sales_mln) over( partition by region) as pct_share_region
from cte1
order by region, net_sales_mln desc


