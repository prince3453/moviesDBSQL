-- Hardware company customer wants to get the data for the fiscal year 2021 for the company chroma and the sales of that

--user defined function
CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`(
		Calender_date date
    ) RETURNS int
    DETERMINISTIC
BEGIN
DECLARE fiscal_year YEAR;
SET fiscal_year = YEAR(date_add(Calender_date, INTERVAL 4 MONTH));
RETURN fiscal_year;
END

--we are using user-defined function in this  
WITH sales_croma AS (
SELECT * FROM fact_sales_monthly
WHERE
	customer_code = 90002002 AND
	get_fiscal_year(date) = 2021
)
SELECT sc.product_code,
	   sc.date,
       dp.product,
       dp.variant,
       sc.sold_quantity,
       gp.gross_price,
       ROUND(sc.sold_quantity * gp.gross_price,2) as gross_total_price
FROM sales_croma sc
INNER JOIN dim_product dp
ON sc.product_code = dp.product_code
INNER JOIN fact_gross_price gp
ON gp.product_code = sc.product_code AND gp.fiscal_year = get_fiscal_year(sc.date)
ORDER BY sc.date ASC
;
