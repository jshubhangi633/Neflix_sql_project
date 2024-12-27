
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
--types of shows on netflix(movie or tvshow)

SELECT DISTINCT type FROM netflix
SELECT*FROM netflix


--15 BUSINESS PROBLEMS
-- Q1) Count the number of Movies or Tv Shows

select*from netflix
select type,count(*) as total_content from netflix group by type;

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
select*from netflix
where type='Movie'
and
release_year=2020 ;

--Q4) Find the top 5 countries with the most content on netflix
select
unnest(string_to_array(country,','))as new_country, count(show_id)as total_content 
from netflix
group by 1 
order by 2 desc
limit 5;

--this shows combination of countries combined which have released the movie 
select unnest(string_to_array(country,','))as new_country
from netflix

--Q5) Identify the longest movie
select*from netflix
where type='Movie'
and
duration=(select max(duration)from netflix
);
 
--Q6) Find content added in the last 5 years
select*
from netflix
where to_date(date_added,'Month DD,YYYY')>=current_date-interval '5 years'


select current_date- interval '5 years';

--Q7) Find all the movies/tv shows by director Rajiv Chilaka
SELECT*FROM netflix
where director ilike '%Rajiv Chilaka%' --to tackle the problem of multiple directors 
--use ilike to tackle the problem of lowercase and uppercase

--Q8) List all tv shows with more than 5 seasons
select*from netflix
where type='TV Show'
duration> 5 seasons 


-- List all TV Shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(split_part(duration, ' ', 1) AS INTEGER) > 5;
  
--Q9) count the number of contents in each genre
select*from netflix
select listed_in, show_id,
string_to_array(listed_in,',')from netflix

select*from netflix
select unnest(string_to_array(listed_in,',')) as genre ,
count(show_id)

from netflix
group by 1

--Q10) Select all the movies that are documentaries
select*from netflix
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
select *from netflix
where director is NULL;

--Q13) Find in how many movies did Salman Khan appear in the last 10 years
select*from netflix
where casts ILIKE '%Salman Khan%'
and release_year> extract(year from current_date) - 10;

--Q14)Find the top 10 actors who have appeared in the highest number of movies produced in india
select
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content from netflix where country ilike '%india%' group by 1 
order by 2 desc
limit 10;


--Q15) categorize the content based on the presence of keywords 'kill' and 'violence' in the description field. label content containing these keywords as 'bad' and all other content as 'good'
--count how many items fall under each category 

select
*, case 
 when description ilike '%kill%'
or 
description ilike '%violence%' then 'bad_content'
else 'good_content'
end category 

from netflix

where description ilike '%kill%'
or 
description ilike '%violence%'

with new_table 
as
(select
*, case 
 when description ilike '%kill%'
or 
description ilike '%violence%' then 'bad_content'
else 'good_content'
end category 

from netflix) select category, count(*) as total_content
from new_table group by 1;