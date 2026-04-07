SELECT * FROM TAB;

DESC EMPLOYEES;

SELECT * FROM EMPLOYEES;


-- 직원번호가 100인 사람을 출력 --
SELECT *
FROM    EMPLOYEES
WHERE   EMPLOYEE_ID = 100;


-- King이라는 직원 출력 --
SELECT *
FROM EMPLOYEES
WHERE LAST_NAME = 'King';


-- 월급 내림차순으로 직원 정보 출력 --
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
ORDER BY SALARY DESC; -- 107


-- 월급이 5000 이상 내림차순으로 직원 정보 출력 --
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM   EMPLOYEES
WHERE  SALARY >= 5000 
ORDER BY SALARY DESC; -- 58


-- 전화번호에 100이 포함된 직원
SELECT *
FROM   EMPLOYEES
WHERE phone_number like '%010%'
ORDER BY EMPLOYEE_ID ASC;

-- 50번 부서의 직원을 출력
SELECT EMPLOYEE_ID                            사번, -- 사번 : ALIAS, 별칭, 별명
        FIRST_NAME || ' ' || LAST_NAME         이름,
        DEPARTMENT_ID                          부서번호
FROM EMPLOYEES
WHERE department_id = 50
-- ORDER BY FIRST_NAME || ' ' || LAST_NAME ASC;
 ORDER BY FIRST_NAME ASC, LAST_NAME ASC;

-- 부서가 없는 직원을 출력
SELECT EMPLOYEE_ID
       , FIRST_NAME || ' ' || LAST_NAME   ENANE
       , DEPARTMENT_ID
FROM EMPLOYEES
WHERE department_id is NULL;  -- NULL (작동안함), IS NULL, IS NOT NULL