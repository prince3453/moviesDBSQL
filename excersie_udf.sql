--Generate a yearly report for Croma India where there are two columns
-- 1. Fiscal Year
-- 2. Total Gross Sales amount In that year from Croma

WITH sales_croma AS (
SELECT date, sold_quantity, product_code ,get_fiscal_year(date) as fiscal1_year FROM fact_sales_monthly
WHERE
	customer_code = 90002002
)
SELECT
		fiscal1_year,
       ROUND(SUM(sc.sold_quantity * gp.gross_price),2) as gross_total_price
FROM sales_croma sc
INNER JOIN fact_gross_price gp
ON gp.product_code = sc.product_code AND gp.fiscal_year = get_fiscal_year(sc.date)
GROUP BY fiscal1_year
ORDER BY fiscal1_year ASC
;
