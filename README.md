# Netflix Movie and TV Shows Data Analysis using SQL
This project is a comprehensive analysis of Netflix's movies and TV shows dataset, conducted using SQL. The primary objective is to uncover valuable insights and address key business questions to inform decision-making. 
![Netflix Logo](https://github.com/jshubhangi633/Neflix_sql_project/blob/main/BrandAssets_Logos_01-Wordmark.jpg)

## Objective 
-Analyze the distribution of content types (movies vs TV shows).
-Identify the most common ratings for movies and TV shows.
-List and analyze content based on release years, countries, and durations.
-Explore and categorize content based on specific criteria and keywords.

## Dataset link
- [Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
``` sql
DROP TABLE IF EXISTS netflix;
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
```
## Business Problems and Solutions

## 1) Count the Number of Movies vs TV Shows
``` sql
select*from netflix
select type,count(*) as total_content from netflix group by type;
```
## 2) Find the Most Common Rating for Movies and TV Shows
``` sql
select
type, rating
FROM

(
select
type, rating, count(*),
rank()over(partition by type order by count(*)desc) as ranking
from netflix
group by 1,2
) as t1 where ranking = 1;
```

## 3) List All Movies Released in a Specific Year (e.g., 2020)
``` sql
select*from netflix
where type='Movie'
and
release_year=2020 ;
```

## 4) Find the Top 5 Countries with the Most Content on Netflix
``` sql
select
    unnest(string_to_array(country,','))as new_country,
        count(show_id)as total_content 
from netflix
group by 1 
order by 2 desc
limit 5;
```
## 5) Identify the Longest Movie
``` sql
select*from netflix
where type='Movie'
            and
duration=(select max(duration)from netflix
);
```
## 6) Find Content Added in the Last 5 Years
``` sql
select*
from netflix
where to_date(date_added,'Month DD,YYYY')>=current_date-interval '5 years'


select current_date- interval '5 years';
```

## 7) Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```
## 8)  List All TV Shows with More Than 5 Seasons
``` sql
select*from netflix
where type='TV Show'
duration> 5 seasons 


-- List all TV Shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(split_part(duration, ' ', 1) AS INTEGER) > 5;
```

## 9) Count the Number of Content Items in Each Genre
``` sql
select*from netflix
select listed_in, show_id,
string_to_array(listed_in,',')from netflix

select*from netflix
select unnest(string_to_array(listed_in,',')) as genre ,
count(show_id)

from netflix
group by 1;
```
## 10) Select all the movies that are documentaries
``` sql
select*from netflix
WHERE listed_in ILIKE '%documentaries%';
```

## 11) Find each year and the average numbers of content release in India on netflix

```
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
```
## 12)  Find all content without a director
``` sql
select *from netflix
where director is NULL;
```
## 13) Find in how many movies did Salman Khan appear in the last 10 years
``` sql
select*from netflix
where casts ILIKE '%Salman Khan%'
and release_year> extract(year from current_date) - 10;
```
## 14) Find the top 10 actors who have appeared in the highest number of movies produced in india

``` sql
select
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content from netflix where country ilike '%india%' group by 1 
order by 2 desc
limit 10;
```
## 15) Categorize the content based on the presence of keywords 'kill' and 'violence' in the description field. label content containing these keywords as 'bad' and all other content as 'good'. Count how many items fall under each category.

```sql
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
```
## Conclusion 
-Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
-Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
-Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
-Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

