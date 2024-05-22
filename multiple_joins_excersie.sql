-- Write SQL queries for the following,

-- 1. Generate a report of all Hindi movies sorted by their revenue amount in millions.
-- Print movie name, revenue, currency, and unit

SELECT 
    m.title,
    CASE
        WHEN revenue = 'Billions' THEN ROUND(revenue * 1000, 2)
        WHEN revenue = 'Thousands' THEN ROUND(revenue / 1000)
        ELSE revenue
    END AS revenue_mln
FROM
    movies m
        JOIN
    financials f ON m.movie_id = f.movie_id
        JOIN
    languages l ON l.language_id = m.language_id
WHERE
    l.name = 'Hindi'
ORDER BY revenue_mln DESC;
