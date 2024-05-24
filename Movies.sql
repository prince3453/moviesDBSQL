-- Concepts --
USE moviesdb;

SELECT * FROM movies;

SELECT COUNT(*) As "Total Hollywood Movies" -- Count(*) so * is the arguments in the count 
FROM movies 
WHERE industry = "hollywood"; -- case insensitive

SELECT DISTINCT industry 
FROM movies; -- Only take that are not repetative

SELECT * FROM movies
WHERE title LIKE '%K.G.F%'; --  wild card search (LIKE)

SELECT * 
FROM movies
WHERE imdb_rating>=6 AND imdb_rating<=8;

SELECT * 
FROM movies
WHERE imdb_rating BETWEEN 6 AND 8;

SELECT * 
FROM movies
WHERE release_year = 2022 or release_year = 2021 or release_year= 2019;

SELECT *
FROM movies
WHERE release_year IN (2022,2021,2019);

SELECT *
FROM movies
WHERE studio IN ("Marvel Studios", "Zee Studios");

SELECT * 
FROM movies WHERE imdb_rating is NULL;

SELECT *
FROM movies
WHERE industry = "bollywood"
ORDER BY imdb_rating DESC
LIMIT 5
OFFSET 2; -- starting from 0 the index means the first two rows will be skipped

-- To get the float number until particular decimal points 
SELECT ROUND(avg(imdb_rating),2) AS averge_rating,
	   MIN(imdb_rating) AS min_rating,
       MAX(imdb_rating) AS max_rating
FROM movies
WHERE industry = "bollywood";

 
-- GROUP BY 
SELECT studio,
		ROUND(AVG(imdb_rating),2) AS avg_rating,
	    COUNT(studio) AS cnt
FROM movies
GROUP BY studio
ORDER BY cnt DESC;

 -- Execution order : FROM --> Where --> GROUP BY--> HAVING --> ORDER BY
SELECT release_year,
	COUNT(*) As movie_count
FROM movies
group by release_year
having movie_count>2
order by movie_count DESC;

-- curdate to get the current date
SELECT name, YEAR(CURDATE()) - birth_year as age 
FROM actors;

SELECT *, (revenue - budget) AS Profit
FROM financials;


SELECT DISTINCT unit from financials;

-- to convert the currency inot one currencymovie_actormovie_actormovie_actormovie_actor
-- IF(Condition, True, False)
SELECT *, ROUND(IF(unit="Billions", revenue*1000, IF(unit="Thousands", revenue/1000, revenue)),2) AS revenue_in_million 
From financials;


-- CASE Statment for the Same Query
SELECT *,
CASE
	WHEN unit="Thousands" THEN revenue/1000
	WHEN unit="Billions" THEN revenue*1000
    WHEN unit="Millions" THEN revenue
END AS revenue_mln
FROM financials;

-- Write SQL queries for the following,

-- 1. Print profit % for all the movies
SELECT *, ROUND((revenue-budget)*100/budget,2) AS Profit_Percentage
FROM financials;

SELECT dt.movie_id, dt.title, dt.budget_inr_Millions, dt.revenue_inr_Millions,
	dt.revenue_inr_Millions - dt.budget_inr_Millions AS Profit
FROM (SELECT m.movie_id, title,
	ROUND(CASE 
     WHEN currency = "USD" and unit = "Billions" THEN budget*83000
     WHEN currency = "USD" and unit = "Millions" THEN budget*83
     WHEN currency = "USD" and unit = "Thousands" THEN budget*83/1000
     WHEN currency = "INR" and unit = "Billions" THEN budget*1000
     WHEN currency = "INR" and unit = "Thousands" THEN budget/1000
     ELSE budget 
	END,2) AS budget_inr_Millions,
    ROUND(CASE 
     WHEN currency = "USD" and unit = "Billions" THEN revenue*83000
     WHEN currency = "USD" and unit = "Millions" THEN revenue*83
     WHEN currency = "USD" and unit = "Thousands" THEN revenue*83/1000
     WHEN currency = "INR" and unit = "Billions" THEN revenue*1000
     WHEN currency = "INR" and unit = "Thousands" THEN revenue/1000
     ELSE revenue
	END,2) AS revenue_inr_Millions
FROM movies m 
INNER JOIN financials f
ON m.movie_id = f.movie_id) dt;

-- Making the Full Join on two tables using the union operator
SELECT m.movie_id, title, budget, revenue
FROM movies m
LEFT JOIN financials f
ON m.movie_id = f.movie_id
UNION
SELECT f.movie_id, title, budget, revenue
FROM movies m
RIGHT JOIN financials f
ON m.movie_id = f.movie_id;

-- -------------ADDED FOODDB ONLY FOR THE CROSS JOIN----
USE food_db;

SELECT CONCAT(v.variant_name, " ", i.name) As item_name,
	   ROUND(i.price + v.variant_price, 2) AS item_price
FROM items i
CROSS JOIN variants v
ORDER BY item_price;
-- -----------------------------------------------------

-- One movie have the multiple actor under the same movie
SELECT 
    m.title, group_concat(a.name SEPARATOR " | " ) as actors_name
FROM
    movies m
        JOIN
    movie_actor ma USING (movie_id)
        JOIN
    actors a ON ma.actor_id = a.actor_id
GROUP BY m.movie_id;

-- The actor who have the multiple movie under their name
SELECT 
    a.name, group_concat(m.title SEPARATOR " | " ) as movies_name,
    COUNT(m.title) as movie_count
FROM
    movies m
        JOIN
    movie_actor ma USING (movie_id)
        JOIN
    actors a ON ma.actor_id = a.actor_id
GROUP BY a.actor_id
ORDER BY movie_count DESC;

-- Subqueries
-- returns single value, multiple value, and table
SELECT 
    *
FROM
    movies
WHERE
    imdb_rating = (SELECT 
            MAX(imdb_rating)
        FROM
            movies);

SELECT 
    *
FROM
    movies
WHERE
    imdb_rating IN 
    ((SELECT 
            MAX(imdb_rating)
        FROM
            movies) , 
		(SELECT 
                MIN(imdb_rating)
            FROM
                movies));


SELECT * 
FROM 
(SELECT name,
	YEAR(curdate())-birth_year as age
FROM actors) as age_actor_table
WHERE age>70 and age<85
;

SELECT * FROM movies 
WHERE imdb_rating > (select min(imdb_rating) from movies where studio = "Marvel studios");

-- the imdb_rating should be more than any of the list that we are getting from the subquies
SELECT * FROM movies 
WHERE imdb_rating > ANY (select imdb_rating from movies where studio = "Marvel studios");

-- the imdb_rating should be more than all of the list that we are getting from the subquies
SELECT * FROM movies 
WHERE imdb_rating > ALL (select imdb_rating from movies where studio = "Marvel studios");

-- movies count by the actor_name using JOINS  
explain analyze
SELECT a.name AS Actorname, COUNT(*) as total_movie_by_actor FROM movie_actor ma
JOIN actors a ON a.actor_id = ma.actor_id
GROUP BY ma.actor_id
ORDER BY total_movie_by_actor DESC;

-- movies count by the actor_name using Subqueries
explain analyze -- to analyze query pe rformance
SELECT 
	name,
    (SELECT count(*) FROM movie_actor WHERE actor_id= actors.actor_id) AS total_movie
FROM actors 
ORDER BY total_movie DESC;
