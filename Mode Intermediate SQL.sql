-- Mode SQL Intermediate

-- COUNT(null이 아닌 행의 개수를 셈, 숫자가 아닌 열에도 사용 가능)
-- 1번
SELECT COUNT(low) AS low
FROM tutorial.aapl_historical_stock_price

-- 2번
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
-- 1번
SELECT MIN(low)
FROM tutorial.aapl_historical_stock_price

-- 2번
SELECT MAX(close - open)
FROM tutorial.aapl_historical_stock_price

--AVG(숫자인 열에만 사용 가능, null 값 완전 무시)
SELECT AVG(volume) as avg_volume
FROM tutorial.aapl_historical_stock_price

--GROUP BY
-- 1번
SELECT year, month, SUM(volume) AS sum_volume
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month

-- 2번
SELECT year, AVG(close-open) AS avg_daily_change
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

--3번
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
-- 1번
SELECT player_name,
       state,
       CASE WHEN state = 'CA' THEN 'yes'
              ELSE NULL END AS is_from_cali
FROM benn.college_football_players
ORDER BY 3

-- 2번 (집계함수와 함께 CASE 사용)  
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

-- 3번
SELECT CASE WHEN year IN ('FR', 'SO') THEN 'underclass'
            WHEN year IN ('JR', 'SR') THEN 'upperclass'
            ELSE NULL END AS class_group,
       SUM(weight) AS combined_player_weight
  FROM benn.college_football_players
 WHERE state = 'CA'
 GROUP BY 1

-- 4번 (집계함수 내부에서 CASE 사용)       
SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players
  FROM benn.college_football_players
 GROUP BY state
 ORDER BY total_players DESC

-- 5번
SELECT CASE WHEN school_name < 'n' THEN 'A-M'
            WHEN school_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS school_name_group,
       COUNT(1) AS players
  FROM benn.college_football_players
 GROUP BY 1

-- DISTINCT
-- 고유한 값을 보기 위해서 사용, 한번만 포함하면 됨
-- 1번
SELECT DISTINCT year
FROM tutorial.aapl_historical_stock_price
ORDER BY year

-- 2번 (집계에서 DISTINCT 사용)
-- MAX, MIN과는 사용하면 안됨
SELECT COUNT(DISTINCT month) AS unique_values
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year

-- 3번
SELECT COUNT(DISTINCT month) AS month_values,
       COUNT(DISTINCT year) AS year_values
FROM tutorial.aapl_historical_stock_price

-- Joins
SELECT players.school_name,
       players.player_name,
       players.position,
       players.weight
  FROM benn.college_football_players players -- 테이블 이름 뒤에 공백 추가 후 별칭 이름 입력
 WHERE players.state = 'GA'
 ORDER BY players.weight DESC

-- INNER JOIN or JOIN
-- join 조건을 만족하지 않는 행은 제거 (교집합)
SELECT players.player_name,
       players.school_name,
       teams.conference
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
 WHERE teams.division = 'FBS (Division I-A Teams)'

-- OUTER JOIN
-- 두 테이블 중 하나 또는 둘 다에서 일치하는 값 과 일치하지 않는 값을 반환하는 조인
-- LEFT JOIN은 왼쪽 테이블에서 일치하지 않는 행만 반환하고 , 두 테이블에서 일치하는 행도 반환
-- RIGHT JOIN은 오른쪽 테이블에서 일치하지 않는 행만 반환하고 , 두 테이블에서 일치하는 행도 반환
-- FULL OUTER JOIN은 두 테이블 모두에서 일치하지 않는 행 과 두 테이블 모두에서 일치하는 행을 반환

-- LEFT JOIN
-- 1번
SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM tutorial.crunchbase_companies companies
  JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink

-- 2번
SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink

-- 3번
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_companies_acquired
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC

-- RIGHT JOIN
-- RIGHT JOIN은 LEFT JOIN과 비슷하지만, RIGHT JOIN 절의 모든 행을 반환하고 FROM 절에 있는 행과 일치하는 것만 반환한다.
-- LEFT JOIN에서 조인된 두개의 테이블 이름만 바꾸면 RIGHT JOIN이 되기 때문에 RIGHT JOIN은 잘 사용하지 않음
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS acquired_companies
  FROM tutorial.crunchbase_acquisitions acquisitions
 RIGHT JOIN tutorial.crunchbase_companies companies
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC

-- Joins using WHERE or ON
-- WHERE 절 사용시 테이블이 조인된 후에 필터가 적용됨
-- 1번
SELECT companies.name AS company_name,
       companies.status,
       COUNT(DISTINCT investments.investor_name) AS unqiue_investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 WHERE companies.state_code = 'NY'
 GROUP BY 1,2
 ORDER BY 3 DESC

-- 2번
SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1
 ORDER BY 2 DESC

-- FULL OUTER JOIN
-- 일반적으로 집계와 함께 사용되며, 두 테이블 간의 겹치는 정도를 확인하기 위해 사용
    SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NULL
                      THEN companies.permalink ELSE NULL END) AS companies_only,
           COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments.company_permalink IS NOT NULL
                      THEN companies.permalink ELSE NULL END) AS both_tables,
           COUNT(CASE WHEN companies.permalink IS NULL AND investments.company_permalink IS NOT NULL
                      THEN investments.company_permalink ELSE NULL END) AS investments_only
      FROM tutorial.crunchbase_companies companies
      FULL JOIN tutorial.crunchbase_investments_part1 investments
        ON companies.permalink = investments.company_permalink

-- UNION
-- 고유한 값만 추가
-- 추가된 테이블에서 첫 번째 테이블의 행과 정확히 동일한 행은 삭제
-- 1번
SELECT company_permalink,
       company_name,
       investor_name
  FROM tutorial.crunchbase_investments_part1
 WHERE company_name ILIKE 'T%'
 
 UNION ALL

SELECT company_permalink,
       company_name,
       investor_name
  FROM tutorial.crunchbase_investments_part2
 WHERE company_name ILIKE 'M%'

-- 2번
SELECT 'investments_part1' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1,2

 UNION ALL
 
 SELECT 'investments_part2' AS dataset_name,
       companies.status,
       COUNT(DISTINCT investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part2 investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1,2

-- Joins with Comparison Operators
-- ON 문에 어떤 유형의 조건문이든 입력할 수 있다.

-- Joins on Multiple Keys
-- 여러 외래 키를 기준으로 테이블을 조인하는 것은 정확성과 성능과 관련이 있음(쿼리 속도 향상)

-- Self Joins
-- 때로는 테이블을 자기 자신과 조인하는 것이 유용할 수 있음
-- 같은 테이블이 다른 별칭으로 여러번 조인될 수 있음
