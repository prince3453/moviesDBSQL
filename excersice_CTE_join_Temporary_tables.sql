-- Write the following query

-- The supply chain business manager wants to see which customers’ forecast accuracy has dropped from 2020 to 2021. 
-- Provide a complete report with these columns: customer_code, customer_name, market, forecast_accuracy_2020, forecast_accuracy_2021

----------------------------- USING CTEs METHOD -----------------------------
WITH CTE_forecast_err_2021 AS (
SELECT
        customer_code,
	   sum((forecast_quantity-sold_quantity)) as net_err,
       sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as net_err_pct,
       sum(abs(forecast_quantity-sold_quantity)) as abs_err,
       sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as abs_err_pct
FROM gdb0041.fact_act_est s
where s.fiscal_year =2021
group by customer_code
),


CTE_forecast_err_2020 AS (
SELECT
        customer_code,
	   sum((forecast_quantity-sold_quantity)) as net_err,
       sum((forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as net_err_pct,
       sum(abs(forecast_quantity-sold_quantity)) as abs_err,
       sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as abs_err_pct
FROM gdb0041.fact_act_est s
where s.fiscal_year =2020
group by customer_code
),


CTE_final as(
SELECT fe0.customer_code,
		dc.customer,
        dc.market,
		IF (fe0.abs_err_pct>100,0,(100-fe0.abs_err_pct)) as forecas_accuracy_2020,
        IF (fe1.abs_err_pct>100,0,(100-fe1.abs_err_pct)) as forecas_accuracy_2021 
FROM CTE_forecast_err_2020 fe0
JOIN CTE_forecast_err_2021 fe1
ON fe0.customer_code = fe1.customer_code
JOIN dim_customer dc
ON fe0.customer_code = dc.customer_code
)


SELECT * FROM CTE_final
WHERE forecas_accuracy_2020>forecas_accuracy_2021
ORDER BY forecas_accuracy_2020 desc;



----------------------------- USING TEMPORARY TABLE METHOD -----------------------------

-- step 1: Get forecast accuracy of FY 2021 and store that in a temporary table
drop table if exists forecast_accuracy_2021;
create temporary table forecast_accuracy_2021
with forecast_err_table as (
        select
                s.customer_code as customer_code,
                c.customer as customer_name,
                c.market as market,
                sum(s.sold_quantity) as total_sold_qty,
                sum(s.forecast_quantity) as total_forecast_qty,
                sum(s.forecast_quantity-s.sold_quantity) as net_error,
                round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
                sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
                round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
        from fact_act_est s
        join dim_customer c
        on s.customer_code = c.customer_code
        where s.fiscal_year=2021
        group by customer_code
)
select 
        *,
    if (abs_error_pct > 100, 0, 100.0 - abs_error_pct) as forecast_accuracy
from 
	forecast_err_table
order by forecast_accuracy desc;

-- step 2: Get forecast accuracy of FY 2020 and store that also in a temporary table
drop table if exists forecast_accuracy_2020;
create temporary table forecast_accuracy_2020
with forecast_err_table as (
        select
                s.customer_code as customer_code,
                c.customer as customer_name,
                c.market as market,
                sum(s.sold_quantity) as total_sold_qty,
                sum(s.forecast_quantity) as total_forecast_qty,
                sum(s.forecast_quantity-s.sold_quantity) as net_error,
                round(sum(s.forecast_quantity-s.sold_quantity)*100/sum(s.forecast_quantity),1) as net_error_pct,
                sum(abs(s.forecast_quantity-s.sold_quantity)) as abs_error,
                round(sum(abs(s.forecast_quantity-sold_quantity))*100/sum(s.forecast_quantity),2) as abs_error_pct
        from fact_act_est s
        join dim_customer c
        on s.customer_code = c.customer_code
        where s.fiscal_year=2020
        group by customer_code
)
select 
        *,
    if (abs_error_pct > 100, 0, 100.0 - abs_error_pct) as forecast_accuracy
from 
	forecast_err_table
order by forecast_accuracy desc;

-- Step 3: Join forecast accuracy tables for 2020 and 2021 using a customer_code
select 
	f_2020.customer_code,
	f_2020.customer_name,
	f_2020.market,
	f_2020.forecast_accuracy as forecast_acc_2020,
	f_2021.forecast_accuracy as forecast_acc_2021
from forecast_accuracy_2020 f_2020
join forecast_accuracy_2021 f_2021
on f_2020.customer_code = f_2021.customer_code 
where f_2021.forecast_accuracy < f_2020.forecast_accuracy
order by forecast_acc_2020 desc;


