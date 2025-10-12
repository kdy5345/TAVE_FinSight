-- Leetcode 4주차

-- [Leetcode 608] Tree Node
-- 트리 구조의 노드가 주어졌을 때, 각 노드가 Root, Leaf, 또는 Inner 중 어떤 유형인지 판별
-- p_id는 그 노드의 부모의 번호
SELECT id,
    CASE 
        WHEN p_id IS NULL THEN 'Root'  -- 부모가 없으면 Root
        WHEN id IN (SELECT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'  -- 다른 노드의 부모이면 Inner
        ELSE 'Leaf' -- 그 외는 Leaf
    END AS type
FROM Tree
ORDER BY id;


-- [Leetcode 626] Exchange Seats
-- 연속된 두 학생의 좌석 번호를 바꾸는 해법. 학생 수가 홀수이면 마지막 학생의 좌석 번호는 바꾸지 않음.
SELECT 
  CASE 
    WHEN id % 2 = 1 AND id = (SELECT COUNT(*) FROM Seat) THEN id    -- id가 홀수이고 전체 인원수와 같다면 마지막 홀수 좌석이므로 변경 x
    WHEN id % 2 = 1 THEN id + 1    -- 홀수 번호 → 바로 다음 자리로
    ELSE id - 1     -- 짝수 번호 → 바로 앞 자리로
  END AS id, student
FROM Seat
ORDER BY id;


-- [Leetcode 1045] Customers Who Bought All Products
--  모든 상품을 구매한 고객을 찾아라
SELECT customer_id
FROM Customer
GROUP BY customer_id   -- 고객별로 구매 목록을 묶음
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(DISTINCT product_key) FROM Product);  -- DISTINCT로 중복된 구매 제거, 고객이 산 서로 다른 다른 상품의 개수가 전체 상품 수와 같다면 "모든 상품을 다 산 사람"


-- [Leetcode 1070] Product Sales Analysis III
-- 각 제품이 판매된 첫 해 에 발생한 모든 매출을 찾는 솔루션
SELECT product_id, year AS first_year, quantity, price -- 첫 해의 판매 정보 출력  
FROM Sales
WHERE (product_id, year) IN (SELECT product_id, MIN(year) FROM Sales GROUP BY product_id); -- GROUP BY로 제품별로 묶음, MIN을 통해 첫 판매 연도 구함


--[Leetcode 1158] Market Analysis I
-- 각 사용자에 대해 구매자로서 가입 날짜와 주문 수를 찾는 솔루션
SELECT u.user_id AS buyer_id, join_date, COUNT(order_date) AS orders_in_2019 
FROM Users as u
LEFT JOIN Orders as o  -- 주문이 0인 사용자도 보여야하기 때문에 LEFT JOIN 사용
ON u.user_id = o.buyer_id  -- 조인 조건 1: 고객 id와 구매자 id가 동일 -> 고객 주문 내역
AND YEAR(order_date) = '2019'  -- 조인 조건 2: 2019년에만 한 주문
GROUP BY u.user_id  -- 사용자별로 주문수 집계, mysql에서만 가능 
