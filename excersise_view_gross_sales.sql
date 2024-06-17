CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `gross_sales` AS
    SELECT 
        `sc`.`date` AS `date`,
        `sc`.`fiscal_year` AS `fiscal_year`,
        `dc`.`customer_code` AS `customer_code`,
        `dc`.`customer` AS `customer`,
        `dc`.`market` AS `market`,
        `sc`.`product_code` AS `product_code`,
        `dp`.`product` AS `product`,
        `dp`.`variant` AS `variant`,
        `sc`.`sold_quantity` AS `sold_quantity`,
        `fgp`.`gross_price` AS `gross_price_per_item`,
        ROUND((`fgp`.`gross_price` * `sc`.`sold_quantity`),
                2) AS `gross_price_total`
    FROM
        (((`fact_sales_monthly` `sc`
        JOIN `dim_customer` `dc` ON ((`sc`.`customer_code` = `dc`.`customer_code`)))
        JOIN `dim_product` `dp` ON ((`dp`.`product_code` = `sc`.`product_code`)))
        JOIN `fact_gross_price` `fgp` ON (((`fgp`.`product_code` = `sc`.`product_code`)
            AND (`fgp`.`fiscal_year` = `sc`.`fiscal_year`))))
