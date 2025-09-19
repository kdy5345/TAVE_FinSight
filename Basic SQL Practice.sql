-- Mdoe Basic SQL Practice

-- SELECT
SELECT year,month, month_name, south, west, midwest, northeast
  from tutorial.us_housing_units

SELECT year as "Year",month as "Month", month_name as "Month Name", south as "South", west as "West", midwest as "Midwest", northeast as "Northeast"
  from tutorial.us_housing_units

-- LIMIT
SELECT *
  FROM tutorial.us_housing_units
 LIMIT 15

-- Comparison Operators
SELECT *
  FROM tutorial.us_housing_units
 WHERE west > 50

SELECT *
  FROM tutorial.us_housing_units
 WHERE south <= 20

SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name = 'February'

SELECT *
  FROM tutorial.us_housing_units
 WHERE month_name < 'o'

SELECT south + west + northeast + midwest as all_regions
  from tutorial.us_housing_units

SELECT *
  from tutorial.us_housing_units
  WHERE west > (midwest + northeast)

SELECT year, month, west/(west+south+midwest+northeast) * 100 as west_pct,
south/(west+south+midwest+northeast) * 100 as south_pct, 
midwest/(west+south+midwest+northeast) * 100 as midwest_pct, 
northeast/(west+south+midwest+northeast) * 100 as northeast_pct
FROM tutorial.us_housing_units
WHERE year > 2000

-- LIKE
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group_name" ILIKE '%ludacris%'

SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group_name" LIKE 'DJ%'

-- IN
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE artist IN ('Elvis Presley', 'M.C. Hammer', 'Hammer')

-- BETWEEN
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year BETWEEN 1985 AND 1990

-- IS NULL
SELECT * 
  FROM tutorial.billboard_top_100_year_end  
  WHERE song_name IS NULL

-- AND
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE group_name ILIKE '%ludacris%' AND year_rank <=10

SELECT *  
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank = 1 AND year IN(1990, 2000, 2001)

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name ILIKE '%love%' AND year BETWEEN 1960 AND 1969

-- OR
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10 AND (group_name ILIKE '%kate perry%' OR group_name ILIKE '%bon jovi%')

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name LIKE '%California%' AND (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 AND 1999)

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name ILIKE '%dr. dre%' AND (year <= 2000 OR year >= 2010)

-- NOT
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 AND song_name NOT ILIKE '%a%'


-- ORDER BY
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year >= 2012
ORDER BY song_name DESC

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year >= 2010
ORDER BY year_rank, artist


SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE group_name ILIKE '%t-pain%'
ORDER BY year_rank DESC


-- Using Comments
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year IN(1993, 2003, 2013) -- 연도 지정
AND year_rank BETWEEN 10 AND 20  -- 10위에서 20위 중
ORDER BY year, year_rank
