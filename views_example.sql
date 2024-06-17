-- Before creating the View
WITH CTE_1 AS
( 
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
ORDER BY sc.date ASC
)
SELECT *,
		ROUND((gross_total_price - gross_total_price*pre_invoice_discount_pct),2) as net_invoice_sales
 FROM CTE_1;
 
-- creating the View as sales_preinvoice_discount
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sales_preinvoice_discount` AS
    SELECT 
        `sc`.`date` AS `date`,
        `sc`.`fiscal_year` AS `fiscal_year`,
        `sc`.`customer_code` AS `customer_code`,
        `dc`.`market` AS `market`,
        `sc`.`product_code` AS `product_code`,
        `dp`.`product` AS `product`,
        `dp`.`variant` AS `variant`,
        `sc`.`sold_quantity` AS `sold_quantity`,
        `gp`.`gross_price` AS `gross_price`,
        ROUND((`sc`.`sold_quantity` * `gp`.`gross_price`),
                2) AS `gross_total_price`,
        `pid`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`
    FROM
        ((((`fact_sales_monthly` `sc`
        JOIN `dim_customer` `dc` ON ((`dc`.`customer_code` = `sc`.`customer_code`)))
        JOIN `dim_product` `dp` ON ((`sc`.`product_code` = `dp`.`product_code`)))
        JOIN `fact_gross_price` `gp` ON (((`gp`.`product_code` = `sc`.`product_code`)
            AND (`gp`.`fiscal_year` = `sc`.`fiscal_year`))))
        JOIN `fact_pre_invoice_deductions` `pid` ON (((`pid`.`customer_code` = `sc`.`customer_code`)
            AND (`pid`.`fiscal_year` = `sc`.`fiscal_year`))))
    WHERE
        (`sc`.`fiscal_year` = 2021)
    ORDER BY `sc`.`date`;

-- using the view in the first query but in a simple way 
SELECT *, 
		ROUND((gross_total_price - gross_total_price*pre_invoice_discount_pct),2) as net_invoice_sales
 FROM sales_preinvoice_discount;
