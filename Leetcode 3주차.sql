-- Leetcode 3주차

-- [Leetcode 262] Trips and Users(hard)
-- 차량 공유(택시/카풀) 플랫폼에서 특정 조건을 만족하는 취소율(Cancellation Rate)을 구하는 것
-- 2013-10-01 ~ 2013-10-03 사이에 요청된 모든 Trip을 대상으로, 운전자와 고객이 둘 다 “banned = No”인 경우만 필터링하고, 각 날짜별 취소율(취소 건수 ÷ 총 건수)을 계산

SELECT 
  Request_at AS Day, -- 날짜 기준으로 집계 결과 표시
  ROUND(
    SUM(CASE WHEN Status LIKE 'cancelled%' THEN 1 ELSE 0 END) -- 분자: 취소 건수
    / COUNT(*),                                               -- 분모: 전체 건수
    2                                                         -- 소수 둘째 자리 반올림
  ) AS "Cancellation Rate"
FROM Trips t
JOIN Users c 
  ON t.Client_Id = c.Users_Id AND c.Banned = 'No'  -- 고객이 banned가 아닌 경우만
JOIN Users d 
  ON t.Driver_Id = d.Users_Id AND d.Banned = 'No'  -- 운전자가 banned가 아닌 경우만
WHERE t.Request_at BETWEEN '2013-10-01' AND '2013-10-03' -- 분석 대상 기간
GROUP BY t.Request_at   -- 날짜별 그룹화
ORDER BY t.Request_at;  -- 날짜순으로 정렬


-- [Leetcode 550] Game Play Analysis IV
-- 게임 로그 데이터를 기반으로, 사용자가 설치 후 다음 날에 다시 접속했는지 여부(리텐션율)를 계산
-- 모든 유저 중에서 첫 접속일 다음 날에도 접속한 유저 비율을 구하는 것.
-- retention = (첫날 이후 바로 다음 날 접속한 유저 수) ÷ (전체 유저 수).

WITH firsts AS (                                      -- CTE: 플레이어별 '첫 접속일'만 추출해 1행으로 축약
  SELECT player_id, MIN(event_date) AS first_login    -- MIN(event_date): 가장 이른 접속일 = 온보딩 기준일
  FROM Activity                                       -- 소스 로그 테이블(여러 날, 여러 번 접속 가능)
  GROUP BY player_id                                  -- 플레이어 단위로 집계해 중복 행 제거
)
SELECT 
  ROUND(                                              -- 최종 지표를 소수 둘째 자리로 반올림
    COUNT(DISTINCT a.player_id)                       -- 분자: '첫 접속 다음 날에 실제 접속한' 고유 플레이어 수
    / CAST((SELECT COUNT(*) FROM firsts) AS DECIMAL(10,2)), -- 분모: 전체 온보딩 플레이어 수. CAST로 정수 나눗셈 방지
    2
  ) AS fraction                                       -- 결과 컬럼명: 요구 사항과 동일
FROM firsts f                                         -- 기준 집합: 각 플레이어의 첫 접속일
JOIN Activity a                                       -- 실제 접속 로그와 조인해 '다음 날 접속'만 선별
  ON a.player_id = f.player_id                        -- 같은 플레이어 매칭
 AND a.event_date = DATE_ADD(f.first_login, INTERVAL 1 DAY); -- '첫 접속일 + 1일' 접속 로그만 남김(중복 로그는 DISTINCT로 1회 인정)

-- [Leetcode 570] Managers with at Least 5 Direct Reports
-- 회사 직원(Employee) 테이블에서 직속 부하직원이 5명 이상인 매니저를 찾는 것

SELECT e.Name AS Manager              -- 매니저 이름을 출력
FROM Employee e
JOIN Employee m 
  ON e.Id = m.ManagerId               -- e는 매니저, m은 직원. 조인 조건: 직원의 ManagerId = 매니저의 Id
GROUP BY e.Id, e.Name                 -- 매니저별로 그룹화
HAVING COUNT(m.Id) >= 5;              -- 부하 직원 수가 5명 이상인 매니저만 추출

-- [Leetcode 585] Investments in 2016
-- 투자(Investments) 테이블에서 2016년에 발생한 투자 중 이익이 음수(손실)인 거래를 제외하고, 2016년 투자들의 평균 금액보다 큰 투자 건을 찾는 것

SELECT pid                                      -- 조건을 만족하는 투자 ID만 출력
FROM Insurance
WHERE tiv_2016 > (SELECT AVG(tiv_2016) 
                  FROM Insurance)               -- 조건1: 2016년 투자액이 평균보다 큰 경우
AND tiv_2015 IN (SELECT tiv_2015 
                 FROM Insurance
                 GROUP BY tiv_2015
                 HAVING COUNT(*) > 1)           -- 조건2: 2015 투자액이 다른 행과 중복되는 경우
AND (lat, lon) IN (SELECT lat, lon 
                   FROM Insurance
                   GROUP BY lat, lon
                   HAVING COUNT(*) > 1)         -- 조건3: 동일한 지역(lat, lon)이 여러 건 있는 경우
ORDER BY pid;                                   -- 최종 정렬

-- [Leetcode 601] Human traffic of stadium(hard)
-- 경기장 출입 기록 중에서 연속된 3일 이상 방문자 수가 100명 이상인 구간을 찾아내는 것

SELECT id, visit_date, people
FROM Stadium s1
WHERE people >= 100                                     -- 조건1: 방문자 수가 100명 이상인 날만 고려
  AND (
        -- 현재 날짜가 '3일 연속 구간'의 첫째 날인지 확인
        (EXISTS (SELECT 1 FROM Stadium s2 
                 WHERE s2.people >= 100 
                   AND s2.id = s1.id + 1)              -- 다음 날도 100명 이상
     AND EXISTS (SELECT 1 FROM Stadium s3 
                 WHERE s3.people >= 100 
                   AND s3.id = s1.id + 2))             -- 다다음 날도 100명 이상

     OR
        -- 현재 날짜가 '3일 연속 구간'의 둘째 날인지 확인
        (EXISTS (SELECT 1 FROM Stadium s2 
                 WHERE s2.people >= 100 
                   AND s2.id = s1.id - 1)              -- 전날도 100명 이상
     AND EXISTS (SELECT 1 FROM Stadium s3 
                 WHERE s3.people >= 100 
                   AND s3.id = s1.id + 1))             -- 다음 날도 100명 이상

     OR
        -- 현재 날짜가 '3일 연속 구간'의 셋째 날인지 확인
        (EXISTS (SELECT 1 FROM Stadium s2 
                 WHERE s2.people >= 100 
                   AND s2.id = s1.id - 2)              -- 이틀 전도 100명 이상
     AND EXISTS (SELECT 1 FROM Stadium s3 
                 WHERE s3.people >= 100 
                   AND s3.id = s1.id - 1))             -- 전날도 100명 이상
      )
ORDER BY visit_date;                                   -- 결과를 날짜순으로 출력

-- [Leetcode 602] Friend Requests II: Who Has the Most Friends
-- 가장 많은 친구 수를 가진 사람을 찾는 것

SELECT id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id
    FROM RequestAccepted
    UNION ALL                                     -- 요청자/수락자 모두를 하나의 id 컬럼으로 합침
    SELECT accepter_id AS id
    FROM RequestAccepted
) AS all_ids
GROUP BY id                                       -- 사람별로 집계
ORDER BY num DESC                                 -- 친구 수 많은 순서대로 정렬
LIMIT 1;                                          -- 가장 많은 친구를 가진 사람 1명만 출력