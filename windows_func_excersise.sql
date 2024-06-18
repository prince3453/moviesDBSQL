-- Get_top_n_products_by_division

CREATE PROCEDURE `Get_top_n_products_bydivision`(
		in_fiscal_year INT,
        in_top_n INT
)
BEGIN
	WITH CTE AS (SELECT dp.division, dp.product, sum(fsm.sold_quantity) as total_quantity
	FROM fact_sales_monthly fsm
	INNER JOIN dim_product dp
	ON fsm.product_code = dp.product_code
	WHERE fsm.fiscal_year =in_fiscal_year
	GROUP BY dp.product,DP.division),
	CTEs AS (SELECT *,
			dense_rank() over(partition by division order by total_quantity desc) as drnk
	FROM CTE)
	SELECT * FROM CTEs
	WHERE drnk<=in_top_n;
END
