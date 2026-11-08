CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales_for_customer`( 
           in_customer_code TEXT
)
BEGIN
           SELECT 
             s.date, 
             ROUND(SUM(g.gross_price*s.sold_quantity),2) as monthly_sales
        FROM fact_sales_monthly s
	    JOIN fact_gross_price g
        ON 
			g.fiscal_year = get_fiscal_year(s.date)
	        AND g.product_code = s.product_code  
		WHERE 
			FIND_IN_SET(s.customer_code, in_customer_code)>0
		GROUP BY date;
END