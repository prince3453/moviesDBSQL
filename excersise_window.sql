-- Excersise the window function

-- Problem : Retrieve the top 2 markets in every region by their gross sales amount in FY=2021. Create the store procedure for this

CREATE PROCEDURE `get_top_n_bymarket_region_gross_sales`(
	in_fiscal_year INT,
    in_top_n INT
)
BEGIN
	WITH CTE AS 
		(
		SELECT gs.market, dc.region, ROUND(SUM(gs.gross_price_total)/1000000,2) AS total_price
		FROM gross_sales gs
		INNER JOIN dim_customer dc 
		ON dc.customer_code = gs.customer_code
		where gs.fiscal_year = in_fiscal_year
		GROUP BY gs.market,dc.region
		),
	Cte2 as
		(
		SELECT *,
			dense_rank() over (partition by region order by total_price desc) as drnk
		 FROM CTE
		 )
	 SELECT * FROM Cte2
	 WHERE drnk<=in_top_n;
END
