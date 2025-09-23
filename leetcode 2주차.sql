-- leetcode 176, 177, 178, 180, 184, 185

-- [Leetcode 176] Second Highest Salary
-- Employee 테이블에서 두 번째로 높은 급여를 찾는 쿼리
-- 1) salary 컬럼에서 중복을 제거한 뒤(DISTINCT) 내림차순 정렬
-- 2) 가장 높은 값은 건너뛰고(limit 1 offset 1) 두 번째 값을 선택
-- 3) 해당 값을 SecondHighestSalary 라는 이름으로 반환
select (
    select distinct salary
    from Employee
    order by salary desc
    limit 1 offset 1
) as SecondHighestSalary;

-- [Leetcode 177] Nth Highest Salary
-- Employee 테이블에서 N번째로 높은 급여를 반환 (없으면 NULL)
-- DISTINCT: 같은 급여가 여러 행에 있어도 1번만 취급
-- ORDER BY salary DESC: 높은 급여부터 내림차순 정렬
-- LIMIT 1 OFFSET N-1: 상위 N-1개를 건너뛰고 1개 선택 → N번째 급여
-- 결과 행이 없으면 이 서브쿼리는 NULL을 반환
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
      LIMIT 1 OFFSET N-1
  );
END

-- [Leetcode 178] Rank Scores
-- Scores 테이블에서 점수별 순위를 매기는 쿼리
-- DENSE_RANK(): 동일 점수는 같은 순위를 주고,
-- 다음 순위는 바로 이어지는 정수로 표시
SELECT 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS rank
FROM Scores;

-- [Leetcode 180] Consecutive Numbers
-- Logs 테이블에서 3번 연속으로 같은 num이 등장하는 값 찾기
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l1.id = l2.id - 1        -- l1과 바로 다음 행 비교
JOIN Logs l3 ON l2.id = l3.id - 1        -- l2와 바로 다음 행 비교
WHERE l1.num = l2.num AND l2.num = l3.num; -- 세 행의 num이 모두 같은 경우만 선택

-- [LeetCode 184] Department Highest Salary
-- 각 부서에서 가장 높은 급여를 받는 직원(여러 명일 수 있음)을 찾기
SELECT d.name AS Department,     
       e.name AS Employee,       
       e.salary AS Salary        
FROM Employee e
JOIN Department d
  ON e.departmentId = d.id       -- 직원 테이블과 부서 테이블을 연결해 부서명을 가져옴
WHERE e.salary = (               
  SELECT MAX(salary)             -- 해당 부서에서 가장 높은 급여를 찾음
  FROM Employee
  WHERE departmentId = e.departmentId -- 현재 직원이 속한 부서 기준으로 검색
);

-- [LeetCode 185] Department Top Three Salaries (Hard)
-- 각 부서에서 상위 3위까지의 급여를 받는 직원 전원을 찾기
SELECT d.name AS Department,     
       e.name AS Employee,       
       e.salary AS Salary        
FROM (
    SELECT e.*, 
           DENSE_RANK() OVER (              -- 순위를 매기는 함수
             PARTITION BY departmentId      -- 부서별로 나누어 독립적으로 순위 계산
             ORDER BY salary DESC           -- 급여 높은 순서대로 1위부터 시작
           ) AS rnk
    FROM Employee e
) e
JOIN Department d ON e.departmentId = d.id  -- 부서명을 가져오기 위해 Department와 JOIN
WHERE e.rnk <= 3;                           -- 부서별 순위가 3위 이하인 직원만 선택