# Chapter 9: Stored Procedures

SELECT 
             s.date, 
             ROUND(SUM(g.gross_price*s.sold_quantity),2) as monthly_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g
ON 
    g.fiscal_year = get_fiscal_year(s.date)
	AND g.product_code = s.product_code  
WHERE 
            customer_code = 90002002
GROUP BY date;

SELECT FIND_IN_SET(90002002, "90002002,90002008")