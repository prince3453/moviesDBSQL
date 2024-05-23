-- Write SQL queries for the following,

-- 1. Select all the movies with minimum and maximum release_year. Note that there
-- can be more than one movie in min and a max year hence output rows can be more than 2
explain analyze
SELECT * FROM movies m
WHERE release_year IN ((SELECT min(release_year) from movies), 
(SELECT max(release_year) from movies));


-- 2. Select all the rows from the movies table 
-- whose imdb_rating is higher than the average rating
explain analyze
SELECT * FROM movies 
WHERE imdb_rating > ANY (SELECT ROUND(AVG(imdb_rating),2) AS avg_imdb_rating FROM movies)
