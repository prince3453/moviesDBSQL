-- Write SQL queries for the following,

-- Select all Hollywood movies released after the year 2000 that made more than 500 million $ profit or more profit. Note that all Hollywood movies have millions as a unit hence you don't need to do the unit conversion. Also, you can write this query without CTE as well but you should try to write this using CTE only
-- Simple way of doing that using joins
explain analyze
SELECT m.movie_id, m.title, m.release_year, (f.revenue-f.budget) as profit_mln
FROM movies m
JOIN financials f
ON m.movie_id = f.movie_id
WHERE m.release_year>2000
HAVING profit_mln>500;

-- Using CTE (Common table expression)s
explain analyze
WITH movie AS(
	SELECT * from movies where release_year>2000
),
financial AS (
	SELECT *, revenue-budget as profit FROM financials where revenue-budget>500 
)
SELECT m.movie_id, m.title,m.release_year,f.profit 
FROM movie m
INNER JOIN financial f
ON m.movie_id=f.movie_id;

-- Joins is faster than the CTES after using the HAVING clause, we can analyze that using EXPLAIN ANALYZE
