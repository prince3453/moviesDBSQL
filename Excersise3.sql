-- Summary analytics (MIN, MAX, AVG, GROUP BY), HAVING, IF, CASE

-- 1. How many movies were released between 2015 and 2022
SELECT COUNT(*) AS Movie_count 
FROM movies
WHERE release_year BETWEEN 2015 AND 2022;

-- 2. Print the max and min movie release year
SELECT MIN(release_year) AS Min_movie_Release_Year,
		MAX(release_year) AS MAX_movie_Release_Yeasr
FROM movies;

-- 3. Print a year and how many movies were released in that year starting with the latest year
SELECT release_year,
		COUNT(release_year)
FROM movies
GROUP BY release_year
ORDER BY release_year DESC;

-- 4. Print profit % for all the movies
SELECT *, ROUND((revenue-budget)*100/budget,2) AS Profit_Percentage
FROM financials
