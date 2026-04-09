SELECT * FROM TAB;

------------------------------------
SUBQUERY : SQL 문 안에 SQL 문을 넣어서 실행한 방법
         : 반드시 () 안에 있어야 한다
         : () 안에는 ORDER BY 사용 불가
         : WHERE 조건에 맞도록 작성
         : 쿼리 실행하는 순서가 필요할 때
------------------------------------


-- IT 부서의 직원 정보를 출력하시오
1) IT 부서의 부서 번호를 찾는다 -- 60
SELECT DEPARTMENT_ID
FROM    DEPARTMENTS
WHERE  DEPARTMENT_NAME = 'IT';

2) 60번 부서의 직원 정보를 출력
SELECT  EMPLOYEE_ID    사번,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        DEPARTMENT_ID
FROM  EMPLOYEES
WHERE DEPARTMENT_ID = 60;

1) + 2)
SELECT EMPLOYEE_ID    사번,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        DEPARTMENT_ID        부서번호
FROM  EMPLOYEES
WHERE DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID
    FROM    DEPARTMENTS
    WHERE  DEPARTMENT_NAME = 'IT');


SELECT EMPLOYEE_ID    사번,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        DEPARTMENT_ID        부서번호
FROM  EMPLOYEES
WHERE DEPARTMENT_ID IN ( 
    SELECT DEPARTMENT_ID
    FROM    DEPARTMENTS
    WHERE  DEPARTMENT_NAME IN ('IT', 'Sales'));


-- 평균 월급보다 많은 월급을 받는 사람의 명단
1) 평균 월급
SELECT AVG(SALARY)
FROM    EMPLOYEES;


2) 월급이 평균 월급보다 많은 직원 -- 6461.831775700934579439252336448598130841
SELECT EMPLOYEE_ID 사번,
        SALARY      월급
FROM   EMPLOYEES
WHERE SALARY > 6461.831775700934579439252336448598130841;


1) + 2) 
SELECT EMPLOYEE_ID 사번,
        SALARY      월급
FROM   EMPLOYEES
WHERE SALARY >= (SELECT AVG(SALARY)
FROM    EMPLOYEES);


-- 60번 부서의 평균 월급보다 많이 받는 사람의 명단
1) 
SELECT DEPARTMENT_ID  부서번호
FROM   EMPLOYEES
WHERE DEPARTMENT_ID = 60;
/*
SELECT DEPARTMENT_ID  부서번호,
        AVG(SALARY)   월급
FROM   EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING DEPARTMENT_ID = 60;
*/

2)
SELECT AVG(SALARY)
FROM    EMPLOYEES
WHERE  DEPARTMENT_ID = 60;


3) 2) 보다 월급이 많은 사원
SELECT EMPLOYEE_ID,
        FIRST_NAME, LAST_NAME,
        SALARY
FROM   EMPLOYEES
WHERE SALARY >= 5760;

SELECT EMPLOYEE_ID,
        FIRST_NAME, LAST_NAME,
        SALARY
FROM   EMPLOYEES
WHERE SALARY >= (SELECT AVG(SALARY)
FROM    EMPLOYEES
WHERE  DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID
    FROM    DEPARTMENTS
    WHERE  DEPARTMENT_NAME = 'IT'
));


/*
SELECT EMPLOYEE_ID  사번,
        SALARY          월급,
        DEPARTMENT_ID   부서번호
FROM EMPLOYEES
WHERE  SALARY > (
SELECT AVG(SALARY)   월급
FROM   EMPLOYEES
WHERE DEPARTMENT_ID = 60);
*/

-- 50번 부서의 최고 월급자의 이름을 출력
1)
SELECT MAX(SALARY)
FROM   EMPLOYEES;
WHERE  DEPARTMENT_ID = 50;


2) 최고 월급자의 이름
SELECT EMPLOYEE_ID ,
        FIRST_NAME, LAST_NAME,
        SALARY
FROM    EMPLOYEES
WHERE SALARY = 8200;

1) + 2)
SELECT EMPLOYEE_ID ,
        FIRST_NAME, LAST_NAME,
        SALARY,
        DEPARTMENT_ID
FROM    EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY)
FROM   EMPLOYEES
WHERE DEPARTMENT_ID = 50)
AND DEPARTMENT_ID = 50;

-- SALES 부서의 평균 월급보다 많은 월급을 받는 사람의 명단
1) SALES 부서의 부서 번호
SELECT DEPARTMENT_ID
FROM    DEPARTMENTS
WHERE  UPPER(DEPARTMENT_NAME) = 'Sales';

2) 1) 부서의 평균 월급  -- 8955.882352941176470588235294117647058824
SELECT AVG(SALARY)
FROM    EMPLOYEES
WHERE  DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID
    FROM    DEPARTMENTS
    WHERE  DEPARTMENT_NAME = 'Sales'
);


3) 2)보다 많은 월급자의 명단
SELECT EMPLOYEE_ID,
        FIRST_NAME, LAST_NAME,
        SALARY
FROM   EMPLOYEES
WHERE SALARY >= 8955.882352941176470588235294117647058824;


SELECT EMPLOYEE_ID,
        FIRST_NAME, LAST_NAME,
        SALARY
FROM   EMPLOYEES
WHERE SALARY >= (
    SELECT AVG(SALARY)
    FROM    EMPLOYEES
    WHERE  DEPARTMENT_ID = (
        SELECT DEPARTMENT_ID
        FROM    DEPARTMENTS
        WHERE  UPPER(DEPARTMENT_NAME) = 'Sales'
));

----------------------------------------------------
-- employees 테이블에서 job_id별로 가장 낮은 salary가 얼마인지 찾아보고, 
-- 찾아낸 job_id별 salary에 해당하는 직원이 누구인지 다중 열 서브쿼리를 이용해 찾아보세요.
        SELECT  *
        FROM    employees 
        WHERE   (job_id, salary) IN (
                       SELECT   job_id
                                ,MIN(salary) 그룹별급여
                       FROM     employees
                       GROUP BY job_id
        )
        ORDER BY A.salary DESC
        ;
        

-- 상관 서브 쿼리 CORELATIVE SBQUARY      
-- JOB_HISTORY에 있는 부서번호와 DEPARTMENTS에 있는 부서번호가 같은 부서를 찾아서 DEPARTMENTS에 있는 부서번호와 부서명을 출력
-- 사원명과 부서명을 가져오려고 서브쿼리 SELECT절에서 사용

        SELECT  DEPARTMENT_ID, DEPARTMENT_NAME                      -- JOB_HISTORY에 한번이라도 등장한 부서만 출력 
        FROM    DEPARTMENTS A                                       -- DEPARTMENTS에서 한 행씩 꺼냄(A)- > 그 부서번호를 가지고 JOB_HISTORY에서 같은 부서 있는지 확인 
        WHERE   EXISTS(SELECT 1                                     -- EXISTS (서브쿼리) = 결과가 한건이라도 있으면 TRUE
                        FROM JOB_HISTORY B
                        WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
         )
        ;
        
        
-- SHIPPING 부서의 직원 명단
SELECT EMPLOYEE_ID,  FIRST_NAME, LAST_NAME
FROM    EMPLOYEES
WHERE DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID 
    FROM    DEPARTMENTS
    WHERE UPPER(DEPARTMENT_NAME) = 'SHIPPING');
    
    
------------------
JOIN
------------------
직원 이름, 부서명 -- 출력줄수 109줄

ORACLE OLD 문법
1) 카티션 프로덕트: 109 * 27 = 2943개 - > CROSS JOIN  
SELECT 109 * 27 FROM DUAL;
SELECT FIRST_NAME || ' ' || LAST_NAME   직원이름, 
        DEPARTMENT_NAME                  부서명
FROM   EMPLOYEES, DEPARTMENTS
WHERE DEPARTMENT_ID = DEPARTMENT_ID
;

2) INNERJOIN(내부조인): 양쪽 다 존재하는 DATA, NULL 제외 
                      : 109-3(부서번호 NULL) = 106 개
                        비교 조건 필수
            
SELECT FIRST_NAME || ' ' || LAST_NAME   직원이름, 
        DEPARTMENT_NAME                  부서명
FROM   EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME   직원이름, 
        D.DEPARTMENT_NAME                  부서명
FROM   EMPLOYEES         E, DEPARTMENTS          D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
;


3) LEFT OUTER JOIN -- 기준을 정해서
모든 직원을 출력하라 : 109줄
직원의 부서 번호가  NULL이라도 출력해야 함
(+) : 기준(직원)이 되는 조건의 반대반향 쪽에 붙인다
    NULL이 출력될 뜻

SELECT  E.FIRST_NAME || ' ' || E.LAST_NAME  이름,
        D.DEPARTMENT_NAME                   부서명  
FROM    EMPLOYEES E, DEPARTMENTS  D
WHERE   E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);

4) RIGHT OUTER JOIN
SELECT  E.FIRST_NAME || ' ' || E.LAST_NAME  이름,
        D.DEPARTMENT_NAME                   부서명  
FROM    EMPLOYEES E, DEPARTMENTS  D
WHERE   D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID;

4) RIGHT OUTER JOIN
모든 직원을 출력하라                 -- 122 : (109 - 3) + (27 - 11)
직원 정보가 NULL이라도 출력해야 함
SELECT  E.FIRST_NAME || ' ' || E.LAST_NAME  이름,
        D.DEPARTMENT_NAME                   부서명  
FROM    EMPLOYEES E, DEPARTMENTS  D
WHERE   E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID;

5) FULL OUTER JOIN - OLD 문법에 존재하지 않는 명령
    모든 직원과 모든 부서를 출력
    
--------------------------------------------------------
표준 SQL 문법
1. CROSS JOIN : 2943 개
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM    EMPLOYEES E CROSS JOIN DEPARTMENTS D
;

2. (INNER) JOIN -- 106
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D 
ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID;


3. OUTER JOIN
 1) LEFT OUTER JOIN -- 109
SELECT  E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM    EMPLOYEES E LEFT JOIN DEPARTMENTS D 
ON      E.DEPARTMENT_ID = D.DEPARTMENT_ID;


 2) RIGHT OUTER JOIN -- 122
SELECT  E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM    EMPLOYEES E RIGHT JOIN DEPARTMENTS D 
ON      E.DEPARTMENT_ID = D.DEPARTMENT_ID;

 3) FULL OUTER JOIN -- 125: 109 + 27 - 16
SELECT  E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM    EMPLOYEES E FULL JOIN DEPARTMENTS D 
ON      E.DEPARTMENT_ID = D.DEPARTMENT_ID;



-- 직원 이름, 담당업무(JOB_TITLE) : 109
SELECT E.FIRST_NAME, E.LAST_NAME, 
        J.JOB_TITLE
FROM   EMPLOYEES E JOIN JOBS J
ON      E.JOB_ID = J.JOB_ID
ORDER BY E.FIRST_NAME, E.LAST_NAME;


-- 부서명, 부서위치(CITY, STREET_ADDRESS)
SELECT D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM DEPARTMENTS D JOIN LOCATIONS L
ON      D.LOCATION_ID = L.LOCATION_ID
ORDER BY D.DEPARTMENT_NAME;


-- 직원명, 부서명, 부서위치(CITY, STREET_ADDRESS)
SELECT E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                  LEFT JOIN LOCATIONS L ON   D.LOCATION_ID = L.LOCATION_ID
ORDER BY E.FIRST_NAME, E.LAST_NAME
;

SELECT E.FIRST_NAME || ' ' || E.LAST_NAME    직원명, 
        D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND   D.LOCATION_ID = L.LOCATION_ID
ORDER BY E.FIRST_NAME, E.LAST_NAME
;

-- 직원명, 부서명, 국가, 부서위치(CITY, STREE_ADDRESS)
SELECT  E.FIRST_NAME || ' ' || E.LAST_NAME 직원명
        , D.DEPARTMENT_NAME                부서명
        , C.COUNTRY_NAME                   국가명
        , L.CITY                           도시명
        , L.STREET_ADDRESS                 주소명
FROM EMPLOYEES E 
        LEFT JOIN DEPARTMENTS D  ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        LEFT JOIN LOCATIONS L    ON D.LOCATION_ID = L.LOCATION_ID
        LEFT JOIN COUNTRIES C    ON L.COUNTRY_ID = C.COUNTRY_ID
        
ORDER BY  부서명 ASC
;


-- 부서명, 국가 : 모든 부서: 27 줄이상
SELECT D.DEPARTMENT_ID
        , D.DEPARTMENT_NAME                부서명
        , C.COUNTRY_NAME                   국가명
        , L.CITY                           도시명
        , L.STREET_ADDRESS                 주소명
FROM DEPARTMENTS D 
        LEFT JOIN LOCATIONS L    ON D.LOCATION_ID = L.LOCATION_ID
        LEFT JOIN COUNTRIES C    ON L.COUNTRY_ID = C.COUNTRY_ID
ORDER BY 직원명, 부서명 ASC;

-- 직원명, 부서위치 단 IT 부서만
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME 직원명
        , L.STATE_PROVINCE || ', ' || L.CITY || ', ' || L.STREET_ADDRESS                부서위치
FROM    EMPLOYEES E
LEFT JOIN    DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN    LOCATIONS L  ON D.LOCATION_ID = L.LOCATION_ID
WHERE   D.DEPARTMENT_NAME = 'IT'
;

SELECT *
FROM    EMPLOYEES
WHERE  JOB_ID = 'IT_PROG';

-- 부서명별 월급 평균
1) 부서번호, 월급 평균
SELECT DEPARTMENT_ID            부서번호,
             월급평균
FROM    EMPLOYEES E
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID
;

2) 부서명, 월급 평균 
SELECT  D.DEPARTMENT_NAME 부서명,
        ROUND(AVG(SALARY),2)     월급평균
FROM    EMPLOYEES E LEFT JOIN DEPARTMENTS  D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME
ORDER BY D.DEPARTMENT_NAME;

3)모든 부서 출력
SELECT  D.DEPARTMENT_NAME                   부서명,
       -- NVL(ROUND(AVG(E.SALARY),2), '0')     월급평균 -- 0으로 정상 출력
       -- NVL(ROUND(AVG(E.SALARY),2), '직원없음') -- ORA-01722: 수치가 부적합합니다
        DECODE(AVG(E.SALARY), NULL, '직원없음',  ROUND(AVG(E.SALARY),2)) 월급평균
FROM    EMPLOYEES E RIGHT JOIN DEPARTMENTS  D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME
ORDER BY D.DEPARTMENT_NAME;


-- 직원의 근무연수
-- MONTH_BEWTEEN(날짜1, 날짜2) : 날짜 1 - 날짜 2 : 월단위로
-- ADD_MONTH(날짜, N): 날짜+N개월 / 날짜-N개월
직원명, 입사일, 입사월의 첫번째날, 입사월의 마지막날, 근무일수, 근무연수
SELECT FIRST_NAME || ' ' || LAST_NAME 직원명,
        TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')   입사일,
        TO_CHAR(TRUNC(HIRE_DATE, 'MONTH'), 'YYYY-MM-DD')          "입사월의 첫번째날",
        TO_CHAR(LAST_DAY(HIRE_DATE), 'YYYY-MM-DD')               "입사월의 마지막날",
        TRUNC(SYSDATE - HIRE_DATE, 0)                 근무일수,
        TRUNC((SYSDATE - HIRE_DATE) / 365.2422)       근무연수,
        TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) 근무연수2
FROM    EMPLOYEES;

-- 60번 부서 최소 월급과 같은 월급자의 명단 출력
1) 60번 부서의 최소 월급
SELECT MIN(SALARY)
        DEPARTMENT_ID
FROM    EMPLOYEES
WHERE DEPARTMENT_ID = 60; -- 4200

SELECT MIN(SALARY)
        DEPARTMENT_ID
FROM    EMPLOYEES
;
2) 1) 월급을 받는 사람의 이름
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM    EMPLOYEES
WHERE   SALARY = (
        SELECT MIN(SALARY)
        DEPARTMENT_ID
FROM    EMPLOYEES
);

3) 1) + 2)
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME 직원명
        , E.SALARY                           월급
FROM EMPLOYEES E 
WHERE E.SALARY = (
    SELECT MIN(SALARY)
FROM    EMPLOYEES
WHERE DEPARTMENT_ID = 60);


-- 부서명, 부서장의 이름 출력
1) INNER JOIN : 양쪽 다 존재하는 데이터만 출력
SELECT D.DEPARTMENT_NAME                   부서명,
        E.FIRST_NAME || ' ' || E.LAST_NAME 직원명
FROM    DEPARTMENTS D 
   JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
;

2) 모든 부서에 대해 출력
SELECT D.DEPARTMENT_NAME                   부서명,
        E.FIRST_NAME || ' ' || E.LAST_NAME 직원명
FROM    DEPARTMENTS D 
   LEFT JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
;

-------------------------------------------------
결합 연산자 - 줄 단위 결합
조건 -- 두 테이블의 칸수와 타입이 동일해야 함
1) UNION            중복 제거
2) UNION ALL        중복 포함
3) INTERSECT        교집합: 공통 부분
4) MINUS            차집합: A - B

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80; -- 34
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 45

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80
UNION
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 79

-- 칼럼수와 칼럼들의 TYPE이 같으면 합쳐짐 -> 주의할 것: 의미 없는 결합 가능
SELECT EMPLOYEE_ID, FIRST_NAME FROM EMPLOYEES
UNION
SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS;


-- 직원 정보, 담당 업무
SELECT E.EMPLOYEE_ID                    사번,
        E.FIRST_NAME || ' ' || E.LAST_NAME 직원명,
        J.JOB_TITLE                     "담당 업무"
FROM    EMPLOYEES E
    LEFT JOIN JOBS  J ON E.JOB_ID = J.JOB_ID
    ;
    
    
-- 직원명, 담당 업무, 담당업무 히스토리

-- 사번, 업무시작일, 업무종료일, 담당업무, 부서 번호
SELECT E.EMPLOYEE_ID                    사번,
        H.START_DATE                     업무시작일,
        H.END_DATE                      업무종료일,
        J.JOB_TITLE                       담당업무,
        E.DEPARTMENT_ID                 부서번호
FROM    EMPLOYEES E
    LEFT JOIN JOBS J          ON E.JOB_ID = J.JOB_ID
    LEFT JOIN JOB_HISTORY  H  ON H.JOB_ID = J.JOB_ID;