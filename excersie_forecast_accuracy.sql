-- create the store procedure for forecast_accuracy according to the fiscal_year

DELIMITER $$
USE gdb0041;
CREATE PROCEDURE `get_forecast_accuracy`(
	in_fiscal_year INT
)
BEGIN
	with CTE_forecast_err AS (
			SELECT
					customer_code,
				   sum((forecast_quantity-sold_quantity)) as net_err,
				   sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as net_err_pct,
				   sum(abs(forecast_quantity-sold_quantity)) as abs_err,
				   sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as abs_err_pct
			FROM gdb0041.fact_act_est s
			where s.fiscal_year = in_fiscal_year
			group by customer_code
			order by abs_err_pct desc
		)
		SELECT *,
				IF (abs_err_pct>100,0,(100-abs_err_pct)) as forecas_accuracy 
		FROM CTE_forecast_err;
END $$
DELIMITER ;
