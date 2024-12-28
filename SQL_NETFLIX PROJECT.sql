
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
SELECT*FROM netflix

select count(*) as total_content from netflix
SELECT*FROM netflix
--types of shows on netflix (Movie or TV Shows)

SELECT DISTINCT type FROM netflix
SELECT*FROM netflix


--15 BUSINESS PROBLEMS
-- Q1) Count the number of Movies or Tv Shows

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1

--Q2) Find the most common rating for movie and TV Show 
    
SELECT
type, rating
FROM

(
SELECT
type, rating, count(*),
rank()over(partition by type order by count(*)desc) as ranking
FROM netflix
group by 1,2
) as t1 where ranking = 1;


--	Q3) List all movies in a specific year say 2020

SELECT*FROM netflix 
--filter 2020
--movies
SELECT*FROM netflix
        WHERE type='Movie'
        AND 
        release_year=2020 ;

--Q4) Find the top 5 countries with the most content on netflix
SELECT * 
FROM
(
	SELECT 
		-- country,
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5

--this shows combination of countries combined which have released the movie 
UNNEST(string_to_array(country,','))AS new_country
FROM netflix

--Q5) Identify the longest movie
SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

--Q6) Find content added in the last 5 years
SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE- interval '5 years';

--Q7) Find all the movies/tv shows by director Rajiv Chilaka
SELECT*FROM netflix
WHERE director ilike '%Rajiv Chilaka%' --to tackle the problem of multiple directors 
--use ilike to tackle the problem of lowercase and uppercase

--Q8) List all tv shows with more than 5 seasons
SELECT*FROM netflix
WHERE type='TV Show'
duration> 5 seasons 


-- List all TV Shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(split_part(duration, ' ', 1) AS INTEGER) > 5;
  
--Q9) count the number of contents in each genre
SELECT*FROM netflix
SELECT listed_in, show_id,
string_to_array(listed_in,',')FROM netflix

SELECT*FROM netflix
SELECT UNNEST(string_to_array(listed_in,',')) AS genre ,
COUNT(show_id)

FROM netflix
GROUP BY 1;

--Q10) Select all the movies that are documentaries
SELECT*FROM netflix
WHERE listed_in ILIKE '%documentaries%'


--Q11) Find each year and the average numbers of content release in India on netflix.
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


--Q12) Find all content without a director
SELECT*FROM netflix
WHERE director is NULL;

--Q13) Find in how many movies did Salman Khan appear in the last 10 years
SELECT*FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year> extract(year from current_date) - 10;

--Q14)Find the top 10 actors who have appeared in the highest number of movies produced in india
SELECT
UNNEST(string_to_array(casts,',')) AS actors,
COUNT(*) AS total_content 
    FROM netflix 
    WHERE country ilike '%india%' 
    GROUP BY  1 
ORDER BY 2 desc
LIMIT 10;


--Q15) categorize the content based on the presence of keywords 'kill' and 'violence' in the description field. label content containing these keywords as 'bad' and all other content as 'good'
--count how many items fall under each category 

SELECT
*, CASE
 WHEN description ilike '%kill%'
OR 
description ilike '%violence%' THEN 'bad_content'
ELSE 'good_content'
END category 

FROM netflix

WHERE description ilike '%kill%'
OR 
description ilike '%violence%'

WITH new_table 
AS
(SELECT
*, CASE
 WHERE description ilike '%kill%'
OR 
description ilike '%violence%' THEN 'bad_content'
ELSE 'good_content'
  END category 

FROM netflix) SELECT category,
    COUNT(*) AS total_content
FROM new_table GROUP BY 1;
