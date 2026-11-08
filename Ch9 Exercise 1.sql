-- CHAPTER 9 EXERCISE: Yearly Sales Report

-- Generate a yearly sales report for croma india where there are two columns
# 1. Fiscal year
# 2. Total gross sales amount in that year from croma

SELECT 
get_fiscal_year(date) as fiscal_year,
sum(round(sold_quantity*g.gross_price,2)) as yearly_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g
ON 
     g.fiscal_year = get_fiscal_year(s.date) and
     g.product_code = s.product_code
WHERE
     customer_code = 90002002
GROUP BY get_fiscal_year(date)
ORDER BY fiscal_year;