-- Write SQL queries for the following

-- 1. Show all the movies with their language names
SELECT movie_id, title, industry, release_year, studio , name AS language_name
FROM movies m
INNER JOIN languages l
USING (language_id);

-- 2. Show all Telugu movie names (assuming you don't know the language id for Telugu)
SELECT m.movie_id, title 
FROM movies m
INNER JOIN languages l
ON l.language_id = m.language_id
WHERE l.name = 'Telugu'
ORDER BY m.movie_id;

-- 3. Show the language and number of movies released in that language
SELECT name, COUNT(movie_id) AS total
FROM movies m
RIGHT JOIN languages l
USING (language_id)
Group by name;
