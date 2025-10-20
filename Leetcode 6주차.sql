-- Leetcode 6주차

-- [Leetcode 1341] Movie Rating
-- 가장 많은 영화를 평가한 사용자의 이름을 구하세요. 평가 수가 같으면 사전순으로 더 작은 사용자 이름을 반환하세요.
-- Feburary 2020에서 평균 평점이 가장 높은 영화 제목을 찾으세요. 동점인 경우, 사전순으로 더 작은 영화 제목을 반환하세요.
-- 사용자 관련 쿼리와 영화 관련 쿼리를 각각 작성하여 UNION ALL 사용

(SELECT name AS results
FROM MovieRating JOIN Users USING(user_id) -- user_id를 통하여 두 테이블 조인
GROUP BY name   -- 사용자 이름으로 그룹화
ORDER BY COUNT(*) DESC, name  -- 평점 수로 내림차순 정렬, 동점인 경우 사용자 이름으로 정렬
LIMIT 1)  -- 가장 자주 사용한 사용자 출력

UNION ALL   -- 두 쿼리 결과 합산

(SELECT title AS results
FROM MovieRating JOIN Movies USING(movie_id)    -- movie_id를 통하여 두 테이블 조인
WHERE EXTRACT(YEAR_MONTH FROM created_at) = 202002  -- 2020년 2월에 해당하는 평점만
GROUP BY title  -- 영화 제목을 기준으로 그룹화
ORDER BY AVG(rating) DESC, title    -- 평균 평점을 내림차순으로 정렬, 동점인 경우 제목으로 정렬
LIMIT 1);

-- [Leetcode 1393] Capital Gain/Loss
-- 각 주식에 대한 자본 이득/손실을 보고하는 솔루션을 작성하세요 .
-- 주식의 자본 이득 /손실은 주식을 한 번 또는 여러 번 사고 파는 데 따른 총 이득 또는 손실입니다.
-- SUM 과 CASE문을 통해 총 이득/손실을 구함

SELECT 
    stock_name,
    SUM(        
        CASE 
            WHEN operation = 'buy' THEN -price      -- 구매 시 금액 음수 처리
            WHEN operation = 'sell' THEN price      -- 판매 시 금액 양수 처리
        END
    ) AS capital_gain_loss       
FROM Stocks
GROUP BY stock_name

-- [Leetcode 1907] Count Salary Categories
-- 각 급여 등급별 은행 계좌 수를 계산하는 해를 작성하세요. 급여 등급은 다음과 같습니다.
-- "Low Salary": 모든 급여는 $20000보다 엄격히 낮습니다
-- "Average Salary": [$20000, $50000] 포함된 범위 내의 모든 급여
-- "High Salary": 모든 급여가 $50000 보다 엄격히 높습니다.
-- 결과 테이블에는 세 가지 범주가 모두 포함 되어야 합니다. 범주에 계정이 없으면 0을 반환합니다.
-- 급여 등급 별로 계좌 수 COUNT 후 UNION ALL
-- 서브쿼리 사용

(SELECT "Low Salary" AS category,
    (SELECT COUNT(*)
    FROM Accounts
    WHERE income<20000) AS accounts_count
)

UNION ALL

(SELECT "Average Salary"AS category,
    (SELECT COUNT(*)
    FROM Accounts
    WHERE income>=20000 AND income<=50000) AS accounts_count
)

UNION ALL 

(SELECT "High Salary"AS category,
    (SELECT COUNT(*)
    FROM Accounts
    WHERE income>50000) AS account_count
)

--[Leetcode 1934] Confirmation Rate
-- 사용자의 확인률은 요청된 확인 메시지의 총 개수로 메시지 수를 나눈 값입니다. 
-- 확인'confirmed' 메시지를 요청하지 않은 사용자의 확인률은 0 입니다. 확인률은 소수점 둘째 자리까지 반올림합니다.
-- 각 사용자의 확인률을 구하는 솔루션을 작성하세요
-- 가입한 회원 모두 포함하기 위해 LEFT JOIN으로 테이블 조인
-- ROUND를 통해 반올림
-- IFNULL을 통해 확인 메시지 요청하지 않은 사용자 0 처리

 SELECT 
    S.user_id ,
    IFNULL(ROUND(SUM(action = 'confirmed')/COUNT(*),2),0)
    AS confirmation_rate
FROM Signups S
LEFT JOIN Confirmations C   -- 가입한 외원 모두를 포함하기 위해 LEFT JOIN
ON S.user_id = C.user_id 
GROUP BY S.user_id 


-- [Leetcode 3220] Odd and Even Transactions
-- 각 날짜의 홀수 및 짝수 거래 금액 의 합계 를 구하는 해를 작성하세요 . 특정 날짜에 홀수 또는 짝수 거래가 없으면 0으로 표시하세요
-- 오름차순 으로 정렬 된 결과 transaction_date 테이블을 반환합니다
-- 홀수와 짝수 별 거래 금액의 합계를 SUM과 CASE를 통해 구함
-- transaction_date로 그룹화 후 ASC로 오름차순 정렬

SELECT 
    transaction_date
    ,SUM(CASE WHEN amount % 2 != 0 THEN amount ELSE 0 END
    )AS odd_sum
    ,SUM(CASE WHEN amount % 2 = 0 THEN amount ELSE 0 END
    )AS even_sum
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date ASC