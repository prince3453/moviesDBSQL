# MovieDBSQL SQl query to answer the different types of questions:

Queries that are used to sort list and extract the particular data from database:
- SELECT
- WHERE
- ORDER BY
- LIKE
- IN
- BETWEEN AND
- OR AND
- NULL
- LIMIT
- OFFSET (to skip the particular first N rows)

#

Queries to get the numeric maximum, minimum, average
- MAX
- AVG
- MIN

#

To Combine the particular columns data in order to get the average or max or any kind of aggeragated function:
- GROUP BY (but to make sure that the column is in the SELECT clause in order to apply this)
- HAVING (we have to mention this column in the column list as it cannot be accessible without that, and where column can access any column in the database).


#

## Conditional statements

#### To convert the currency into one currency
#### IF(Condition, True, False)
```
SELECT *, 
        ROUND(IF(unit="Billions", revenue*1000, IF(unit="Thousands", revenue/1000, revenue)),2) AS revenue_in_million 
From financials;
```

#### CASE Statment for the Same Query

```
SELECT *,
    CASE
        WHEN unit = "Thousands" THEN revenue / 1000
        WHEN unit = "Billions" THEN revenue * 1000
        ELSE revenue
    END AS revenue_mln
FROM financials;
```

# JOINS

- INNER (By default)
- LEFT
- RIGHT
- FULL JOIN (Using the UNION keyword we can combine both left and right join)

  
<img width="1013" alt="Screenshot 2024-05-22 at 1 13 08 PM" src="https://github.com/prince3453/moviesDBSQL/assets/47770221/497118da-8bcc-44fb-bd4f-d89f36924b7e">

```
SELECT m.movie_id, title, budget, revenue
FROM movies m
LEFT JOIN financials f
ON m.movie_id = f.movie_id
UNION
SELECT f.movie_id, title, budget, revenue
FROM movies m
RIGHT JOIN financials f
ON m.movie_id = f.movie_id;
```

## USING CLAUSE (instead of ON clause in JOIN)

- We can use the USING clause when there is same name of the column and also we want to apply the join based on more than two columns.

```
SELECT movie_id, title, budget, revenue
FROM movies m
LEFT JOIN financials f
USING (movie_id)
```

## CROSS JOIN means taking all the data from one table and given each record joins with the other tables every row.
```
USE food_db;

SELECT CONCAT(v.variant_name, " ", i.name) As item_name,
	   ROUND(i.price + v.variant_price, 2) AS item_price
FROM items i
CROSS JOIN variants v
ORDER BY item_price;
```


## ANY AND ALL CLAUSE IN WHERE CLAUSE (it is the same as getting the minimum and maximum respectively)
- ANY : getting the result list and we can get the result which is greater than or less than it or equal to any of them (means the minimum of the list).
- ALL : getting the result list and we can get the result which is greater than or less than it or equal to all of them (meaning maximum of the list).

```
-- the imdb_rating should be more than any of the list that we are getting from the subquies
SELECT * FROM movies 
WHERE imdb_rating > ANY (select imdb_rating from movies where studio = "Marvel studios");

-- the imdb_rating should be more than all of the list that we are getting from the subquies
SELECT * FROM movies 
WHERE imdb_rating > ALL (select imdb_rating from movies where studio = "Marvel studios");
```

# Measure the Performance of the Query using EXPLAIN ANALYZE:
```
-- movies count by the actor_name using JOINS  
explain analyze
SELECT a.name AS Actorname, COUNT(*) as total_movie_by_actor FROM movie_actor ma
JOIN actors a ON a.actor_id = ma.actor_id
GROUP BY ma.actor_id
ORDER BY total_movie_by_actor DESC;

-- movies count by the actor_name using Subqueries
explain analyze -- to analyze query performance
SELECT 
	name,
    (SELECT count(*) FROM movie_actor WHERE actor_id= actors.actor_id) AS total_movie
FROM actors 
ORDER BY total_movie DESC;
```

## Benefits of CTES
- Simple Queries, Query resuability, visibility of Query(views)
- Recursive subqueries


# Database design phases
- Cocneptual design
- ER diagram
- Database schema

### database fallback
- put everything in one table like two actor in one table: then what if we can get third actor and so on —> it is not that much flexible

- what if we put the data in the row manner like two data row for two actor and three actor have three column —> Data becomes redundant or duplication

- Data integrity - data inconsistence (like we are updating the row but forget to update in the other row, we are not changing everytwhere so, it can be used
    - Data integrity is accuracy and consistency of data over its life cycle.

![movies](https://github.com/prince3453/moviesDBSQL/assets/47770221/c9511cb7-ea7b-4d98-88d9-a6cb9025d2bf)

### Solution for this is Data model or Normalization:

- Normalization : It is a process of oraganizing the database in order to maintain the data integrity and avoid data duplication Example: 1NF, 2NF, 3NF
- Link table : it is between the two table relations
- So there might be some column which has no data like in our case the movie dont have the budget and revenue
- Space optimization like in our case is language so we dont have to mentioned about the english everytime

# Data Types:
- Numeric
- String
- Date/time
- other

## Numeric
- Whole Numbers - Integer (signed means it is contains negative as well, unsigned will be only positive no negative)
	- TINYINT (Signed and unsigned)
	- SMALLINT
	- MEDIUMINT
	- INT
	- BIGINT		
-  Number with Decimal point - floating point
        - Float : 4 bytes
        - Double : 8 bytes
        - DECIMAL(X,Y) : X - total number of the digit, Y - the number after the decimal

![DECIMAL](https://github.com/prince3453/moviesDBSQL/assets/47770221/2b706999-4dd0-4976-bfe4-58d8e0a71b23)

## String
- Fixed length (CHAR(3)) —> If the field has 2 char then it will pad one space at the end
  	- example: CHAR(150) : it is always uses 150 character no matter what is the size of the column
- Variable length
  	- VARCHAR(150) : it is use mostly but until 150 character if the column has name with 4 char then it will only use 4 character
- ENUM —> we know the minimum field for that and we can use from those fields just like the dropdown menu in any of the form

## Date/Time:
 -  DATETIME (yyyy mm dd hh:mm:ss)
 -  TIMESTAMP (to get the latest update and if we update hte new data then it will automatically add that in the field)

## Other Datatype:
 - Other DType:
    - features : Key/value pair (JSON DTYPE)
        - how to get that in the datatype:
            - SELECT * FROM items where properties->”$.color” = “blue”;
            - SELECT * FROM items where JSON_EXTRACT(properties,”$.color”) = “blue”; — alternative of that
            - SELECT * FROM items where isnull(properties->”$.color”); — when there is not the column available 
    - Spatial data for the geomatry data Like line, Point,polygon:
  

# Models and important things about models
- Primary key
    - Natural key : IT is a part of data
    - surrogate key : it is artificial key, we are generating
    - composite key : it is a collection of the database which is used as an primary key, and also it is a natrual key
- Foriegn key
    - non-identifiable key : the foriegn key is not the primary key in that table
    - identifiable key : the foreign key is the primary key in that table

- Forward engineer —> to create the database from the model of the database
- reverse engineer —> to update and create the model from the given database
- Backfilling is the process of adding records in bulk to database

### INSERT, UPDATE, DELETE data statment:

- ```INSERT INTO `moviesdb`.`movies` (`title`, `industry`, `release_year`, `imdb_rating`, `studio`) VALUES ('Bahubali 3', 'Bollywood', 2024, '8.3', 'Arka media');```
- updating single rows using moive_id
```
UPDATE movies
SET studio = "Marvel Studios"
WHERE movie_id =141;
```
- updating multiple rows using LIKE
```
UPDATE movies
SET studio = "Marvel Studios"
WHERE title LIKE "%Captain%";
```
- deleting the rows
```
DELETE FROM movies where movie_id=141;
```

- delete the table
```
DROP TABLE movies; -- to delete the table
DROP SCHEMA moviesDB; -- to delete the Database
```

# Improve the performance by two things in the Query
 - Using Lookup table
 - Using adding the additional column in the table

```
-- Using Lookup table
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
```

```
-- Using adding the additional column in the table
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
```


# views

- This is a virtual table just like the physical table but it will be useful during the complex execution
- The view is the same as the CTE but CTE is temporary and views are permanent we can use it just as a table.

### Benefits of views

 1.  Simplify quieres
 2.  Central place to store logic
 3.  User access control

```
CREATE VIEW sales_invoice_prediscount AS
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
```


# Window function

- Over Clause: To do the comparison between certain rows and with all rows

```
WITH CTE AS (
select ns.customer, ROUND(SUM(net_sales)/1000000,2) as net_sales_mln, dc.region 
FROM net_sales ns
INNER JOIN dim_customer dc
ON dc.customer_code = ns.customer_code
WHERE fiscal_year = 2021 
GROUP BY customer,region
ORDER BY region 
)
SELECT *, net_sales_mln*100/sum(net_sales_mln) over(partition by region) as pct_by_region  FROM CTE
ORDER BY region,pct_by_region DESC;
```


All of the following window functions are used with over() clause
- row_number: to get the number of the row by partition means by window
- rank(): it will give the rank to the category that has the same value and skip the next number according to the occurrence of the previous number
- dense_rank(): it will use just the same as rank but it will give true rank means it will not skip any number.

```
-- To get the top 2 highest selling amount of restaurant from the each of the category

WITH cte AS (select *,
		row_number() over(partition by category) as rn,
        rank() over(partition by category order by amount desc) as rnk,
        dense_rank() over(partition by category order by amount desc) as drnk
From expenses)
SELECT * FROM CTE
WHERE drnk<=2;
```

```
-- To get the first 5 person from the class who got the highest marks and we can have multiple students at the same position
WITH Cte AS(
SELECT *,
		row_number() over(order by marks desc) as rn,
        rank() over(order by marks desc) as rnk,
        dense_rank() over(order by marks desc) as drnk
FROM student_marks
) 
SELECT * FROM 
Cte WHERE drnk<=5
```

# Triggers

- Triggers are used when we are adding the data into the table and we want to update the other table. E.g. when we are doing the join on the sales table for accuracy and want to add that into the another table for the actual accuracy and forecast accuracy
  ```
  -- it helps us to know how many triggers we have to know which trigger will work during the insertion or updation of the data.
  
  Show triggers

  --Create the trigger after inserting the data into the table

  CREATE TRIGGER `fact_sales_monthly_AFTER_INSERT` AFTER INSERT ON `fact_sales_monthly` FOR EACH ROW BEGIN
    insert into fact_act_est
    	(date, product_code, customer_code, sold_quantity)
    values
    (
	NEW.date,
        NEW.product_code,
        NEW.customer_code,
        NEw.sold_quantity
    )
    on duplicate key update
     sold_quantity = values(sold_quantity); -- it will be updated if there is already the same key available with the primary key
    END
  ```
  
# Events

- It is the thing that we can use during everyday tasks just like a cronjob where we need to update the data every day at 5 AM suppose in the morning, suppose we want to run the ETL pipeline every day at 2 PM after the udpation of the pipeline.

```
-- to show the available events

show events

-- To check if we can do the event then we need to check that event_schedular is ON

show variables like "%event%"

show events
```

```
-- Example of the creation of the events, it will delete all the records that are from 1 month old and it will run at every 5 second

delimiter |
create event e_daily_expese_monthly
on schedule 
	every 5 second
	    comment "removed the expenses that are 1 month old."
	    do
	    begin
			delete from random_tables.expenses
			where DATE(date) < DATE("2022-10-25") - interval 1 month - interval 1 week;
	    END |
delimiter ;
```

```
-- To drop an event from the list

drop event if exists e_daily_expese_monthly
```

