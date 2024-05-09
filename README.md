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

