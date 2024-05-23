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
