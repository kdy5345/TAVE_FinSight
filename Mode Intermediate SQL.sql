-- Mode SQL Intermediate

-- COUNT(null이 아닌 행의 개수를 셈, 숫자가 아닌 열에도 사용 가능)
SELECT COUNT(low) AS low
FROM tutorial.aapl_historical_stock_price

SELECT COUNT(year) AS year,
       COUNT(month) AS month,
       COUNT(open) AS open,
       COUNT(high) AS high,
       COUNT(low) AS low,
       COUNT(close) AS close,
       COUNT(volume) AS volume
  FROM tutorial.aapl_historical_stock_price

-- SUM(숫자인 열에만 사용 가능, null값은 0으로 처리)
SELECT SUM(open)/COUNT(open) AS avg_opening_price
FROM tutorial.aapl_historical_stock_price

-- MIN/MAX(숫자가 아닌 열에도 사용 가능)
SELECT MIN(low)
FROM tutorial.aapl_historical_stock_price

SELECT MAX(close - open)
FROM tutorial.aapl_historical_stock_price

--AVG(숫자인 열에만 사용 가능, null 값 완전 무시)
SELECT AVG(volume) as avg_volume
FROM tutorial.aapl_historical_stock_price

--GROUP BY
SELECT year, month, SUM(volume) AS sum_volume
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month

SELECT year, AVG(close-open) AS avg_daily_change
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

SELECT year, month, MAX(high) AS highest_price, MIN(low) AS lowest_price
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month

-- HAVING
-- 집계 열에서 필터링할 시 사용
-- SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY 순서로 쿼리 작성

-- CASE
-- SQL에서 사용하는 if/then 로직
-- WHEN ~ THEN 절이 적어도 한쌍 이상은 따라와야함, ELSE는 선택적
-- END 절로 끝냄
SELECT player_name,
       state,
       CASE WHEN state = 'CA' THEN 'yes'
              ELSE NULL END AS is_from_cali
FROM benn.college_football_players
ORDER BY 3

-- 집계함수와 함께 CASE 사용       
SELECT *
       CASE WHEN year IN('JR', 'SR') THEN player_name ELSE NULL END AS upperclass_player_name
FROM benn.college_football_players

SELECT CASE WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS arbitrary_regional_designation,
            COUNT(1) AS players
  FROM benn.college_football_players
 WHERE weight >= 300
 GROUP BY 1

SELECT CASE WHEN year IN ('FR', 'SO') THEN 'underclass'
            WHEN year IN ('JR', 'SR') THEN 'upperclass'
            ELSE NULL END AS class_group,
       SUM(weight) AS combined_player_weight
  FROM benn.college_football_players
 WHERE state = 'CA'
 GROUP BY 1

-- 집계함수 내부에서 CASE 사용       
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players
  FROM benn.college_football_players
 GROUP BY state
 ORDER BY total_players DESC

SELECT CASE WHEN school_name < 'n' THEN 'A-M'
            WHEN school_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS school_name_group,
       COUNT(1) AS players
  FROM benn.college_football_players
 GROUP BY 1

-- DISTINCT
-- 고유한 값을 보기 위해서 사용, 한번만 포함하면 됨
SELECT DISTINCT year
FROM tutorial.aapl_historical_stock_price
ORDER BY year

-- 집계에서 DISTINCT 사용
-- MAX, MIN과는 사용하면 안됨
SELECT COUNT(DISTINCT month) AS unique_values
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

SELECT COUNT(DISTINCT month) AS month_values,
       COUNT(DISTINCT year) AS year_values
FROM tutorial.aapl_historical_stock_price
