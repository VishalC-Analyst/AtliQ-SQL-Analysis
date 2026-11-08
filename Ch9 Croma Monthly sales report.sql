# GROSS MONTHLY TOTAL SALES REPORT FOR CROMA

-- DESCRIPTION: As a product owner, i need an aggregate monthly gross sales report for croma india customer so that i can
-- track how much sales this particular customer is generating for AtliQ and manage our relationship accordingly.

#THIS REPORT SHOULD HAVE THE FOLLOWING FIELD;
# 1.MONTH
# 2.TOTAL GROSS SALES AMOUNT TO CROMA INDIA IN THIS MONTH

SELECT 
             s.date, 
             ROUND(SUM(g.gross_price*s.sold_quantity),2) as gross_price_total
FROM fact_sales_monthly s
JOIN fact_gross_price g
ON 
     g.product_code = s.product_code and 
     g.fiscal_year = get_fiscal_year(s.date)
WHERE customer_code = 90002002
GROUP BY s.date
ORDER BY s.date asc
