-- Concepts --

SELECT * FROM movies;

SELECT COUNT(*) As "Total Hollywood Movies" 
FROM movies 
WHERE industry = "hollywood"; -- case insensitive

SELECT DISTINCT industry 
FROM movies; -- Only take that are not repetative

SELECT * FROM movies
WHERE title LIKE '%K.G.F%'; --  wild card search (LIKE)

SELECT * 
FROM movies
WHERE imdb_rating>=6 AND tmdb_rating<=8;

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













