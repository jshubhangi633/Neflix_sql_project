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

## 1- Count the Number of Movies vs TV Shows
``` sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
## 2- Find the Most Common Rating for Movies and TV Shows
``` sql
SELECT
type, rating
FROM

(
SELECT
type, rating, count(*),
rank()over(partition by type order by count(*)desc) as ranking
FROM netflix
GROUP BY 1,2
) as t1 where ranking = 1;
``` 
