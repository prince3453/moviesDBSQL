USE moviesdb;

#Write SQL queries for the following statments:
# 1. Print all movie titles and release year for all Marvel Studios movies.
SELECT title, release_year 
From movies
WHERE studio = "Marvel Studios";


# 2. Print all movies that have Avenger in their name.
SELECT *
FROM movies
WHERE title LIKE '%Avenger%';


# 3. Print the year when the movie "The Godfather" was released.
SELECT release_year
FROM movies
WHERE title = 'The Godfather';


# 4. Print all distinct movie studios in the Bollywood industry.
SELECT DISTINCT studio 
FROM movies
WHERE industry = 'Bollywood';




