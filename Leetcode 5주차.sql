-- Leetcode 5주차

-- [Leetcode 1164] Product Price at a Given Date
-- 2019-08-16에 해당하는 모든 제품의 가격을 찾는 솔루션
-- 변경 전인 처음에는 모든 제품의 가격은 10

SELECT product_id, new_price AS price   -- 기준일 이전에 변경된 제품의 최신 가격을 선택
FROM Products
WHERE(product_id,change_date) IN    -- (제품ID, 변경일) 쌍이 최신 변경일과 일치하는 행만 선택
(SELECT product_id, MAX(change_date)    -- 각 제품별 기준일 이전(포함) 가장 최근 변경일을 구함
    FROM Products
    WHERE change_date <= '2019-08-16'   -- 기준일 포함 조건
    GROUP BY product_id)       -- 제품별로 그룹화하여 최신 변경일만 남김
UNION   -- 위 결과(변경 이력 있는 제품)와 아래 결과(변경 이력 없는 제품)를 합침
SELECT product_id, 10 AS price      -- 변경 이력이 전혀 없는 제품은 기본가 10으로 설정
FROM Products
WHERE(product_id) NOT IN    -- 기준일 이전에 단 한 번도 변경되지 않은 제품만 선택
(SELECT product_id
    FROM Products
    WHERE change_date <= '2019-08-16'); 


-- [Leetcode 1174] Immediate Food Delivery III
-- 고객이 선호하는 배송 날짜가 주문 날짜와 같으면 해당 주문을 즉시 배송이라고 합니다. 그렇지 않으면 예약 배송 이라고 합니다 .
-- 고객의 첫 주문 은 고객이 주문한 날짜 중 가장 빠른 주문입니다. 고객은 첫 주문을 단 하나만 보유하도록 보장됩니다.
-- 모든 고객의 첫 번째 주문 중 즉시 주문 비율을 소수점 둘째 자리까지 반올림하여 구하는 솔루션

SELECT
ROUND(                                       -- 결과를 소수점 둘째 자리까지 반올림
    100 * SUM(order_date = customer_pref_delivery_date) / COUNT(*), 2
) AS immediate_percentage                    -- 결과 컬럼명 지정
FROM Delivery
WHERE (customer_id, order_date) IN (         -- 고객별 첫 주문만 선택
    SELECT customer_id, MIN(order_date)      -- 고객별 최소 주문일(=첫 주문일)
    FROM Delivery
    GROUP BY customer_id                     -- 고객 단위 그룹화
);


-- [Leetcoe 1193] Monthly Transactions I
-- 각 월과 국가별로 거래 건수와 총액, 승인된 거래 건수와 총액을 찾는 SQL 쿼리를 작성
SELECT 
DATE_FORMAT(trans_date, '%Y-%m') AS month, -- 날짜를 연-월 형식으로 변환
country,                                  -- 거래 발생 국가
COUNT(id) AS trans_count,                 -- 전체 거래 건수
SUM(amount) AS trans_total_amount,        -- 전체 거래 금액 합계
SUM(state = 'approved') AS approved_count, -- 승인된 거래 건수 (TRUE=1, FALSE=0)
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount -- 승인된 거래 금액 합계
FROM Transactions
GROUP BY month, country;                  -- 월별, 국가별 집계


-- [Leetcode 1204] Last Person to Fit in the Bus
-- 버스 무게 제한이 1000킬로그램 이라 탑승이 불가능한 사람도 있을 수 있음
-- 한 번에 한 사람만 버스 에 탑승할 수 있다는 점을 유의
-- 무게 제한을 초과하지 않고 버스에 탑승할 수 있는 마지막 사람person_name 의 무게를 구하는 솔루션
SELECT person_name FROM
(SELECT person_name, turn, SUM(weight) OVER (ORDER BY turn) AS total_weight FROM queue) AS a    -- 줄 선 순서대로 누적합
WHERE total_weight <= 1000  -- 총무게가 1000을 초과하지 않은 사람까지만 필터링
ORDER BY total_weight DESC  -- 가장 마지막으로 탑승한 사람(누적합 최대)
LIMIT 1;    -- 한 명만 출력


-- [Leetcode 1321] Restaurant Growth
-- 고객이 7일 기간(즉, 현재 날짜 + 6일 전) 동안 지불한 금액의 이동 평균을 계산. 소수점 이하 두 자리까지 반올림.
-- visited_on 오름차순 으로 정렬된 결과 테이블을 반환
SELECT 
    visited_on,                                         -- 현재 날짜
    SUM(amount) OVER (ORDER BY visited_on 
                     ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount, -- 7일 누적 매출
    ROUND(SUM(amount) OVER (ORDER BY visited_on 
                     ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) / 7, 2) AS average_amount -- 7일 평균 매출
FROM (SELECT visited_on, SUM(amount) AS amount            -- 날짜별 매출 합계
    FROM Customer
    GROUP BY visited_on) AS daily
WHERE visited_on >= (                                  -- 최소 7일 이상 누적된 시점부터 출력
    SELECT DATE_ADD(MIN(visited_on), INTERVAL 6 DAY) 
    FROM Customer
);