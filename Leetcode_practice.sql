-- Leetcode practice

-- 1. Employees with missing informations(easy)
-- Write a solution to report the IDs of all the employees with missing information. The information of an employee is missing if:
-- The employee's name is missing, or
-- The employee's salary is missing.
-- Return the result table ordered by employee_id in ascending order.

SELECT employee_id FROM Employees
WHERE employee_id NOT IN (SELECT employee_id FROM Salaries)
UNION
SELECT employee_id FROM Employees
WHERE employy_id NOT IN(SELECT emplyee_id FROM Employees)
ORDER BY employee_id

-- 2. Customers who bought all products(medium)
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
-- Return the result table in any order.

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product) -- DISTINCT는 상품의 종류 수만 세기 위해서 필요(중복 제거)

-- 3. Rank Scores(medium)
-- Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:
-- The scores should be ranked from the highest to the lowest.
-- If there is a tie between two scores, both should have the same ranking.
-- After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
-- Return the result table ordered by score in descending order.

SELECT 
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS rank  -- DENSE_RANK()라는걸 처음 알았음..
FROM Scores
ORDER BY score DESC