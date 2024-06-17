-- LOOKUP table >>>>> FILTER TABLE (time according)
WITH sales_croma AS (
SELECT date, sold_quantity, customer_code, product_code ,get_fiscal_year(date) as fiscal1_year FROM fact_sales_monthly
)
SELECT
	   sc.date,sc.product_code, dp.product, dp.variant, sc.sold_quantity, gp.gross_price,
       ROUND(sc.sold_quantity * gp.gross_price,2) as gross_total_price, pid.pre_invoice_discount_pct
FROM sales_croma sc
INNER JOIN dim_product dp
ON sc.product_code = dp.product_code
INNER JOIN dim_date dd
ON dd.calender_date = sc.date
INNER JOIN fact_gross_price gp
ON gp.product_code = sc.product_code AND gp.fiscal_year = sc
INNER JOIN fact_pre_invoice_deductions pid
ON pid.customer_code = sc.customer_code AND pid.fiscal_year = dd.fiscal_year
WHERE dd.fiscal_year = 2021
ORDER BY sc.date ASC;

-- ADDING EXTRA COLUMN IN THE TABLE FOR Fiscal_YEAR >>>> LOOKUP table >>>>> FILTER TABLE (time according)
SELECT
	   sc.date,sc.product_code, dp.product, dp.variant, sc.sold_quantity, gp.gross_price,
       ROUND(sc.sold_quantity * gp.gross_price,2) as gross_total_price, pid.pre_invoice_discount_pct
FROM fact_sales_monthly sc
INNER JOIN dim_product dp
ON sc.product_code = dp.product_code
INNER JOIN fact_gross_price gp
ON gp.product_code = sc.product_code AND gp.fiscal_year = sc.fiscal_year
INNER JOIN fact_pre_invoice_deductions pid
ON pid.customer_code = sc.customer_code AND pid.fiscal_year = sc.fiscal_year
WHERE sc.fiscal_year = 2021
ORDER BY sc.date ASC;

