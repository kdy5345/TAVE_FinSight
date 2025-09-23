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