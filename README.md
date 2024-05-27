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
