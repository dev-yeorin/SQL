-- 소수이하 3자리 반올림: ROUND(VAL, 3)
-- 소수이하 3자리 절사: TRUNC(VAL, 3)
-- 15일 기준으로 반올림 날짜 : ROUND(SYSDATE, 'MONTH')
-- 해당 달의 첫번째 날짜: TRUNC(SYSDATE, 'MONTH')

SELECT SYSDATE FROM DUAL;
SELECT EMPLOYEE_ID, HIRE_DATE
FROM    EMPLOYEES
WHERE   HIRE_DATE = '2015-09-21';

ALTER SESSION SET NLS_DATE_FORMAT = "YYYY-MM-DD HH24:MI:SS";

SELECT EMPLOYEE_ID, HIRE_DATE
FROM   EMPLOYEES
WHERE  HIRE_DATE = '2015-09-21';

-----------------------------------------------
-- 앞으로 날짜 표현은 다음과 같이 표현
-- TO_CHAR
SELECT EMPLOYEE_ID, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
FROM   EMPLOYEES
WHERE  TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') = '2015-09-21';


-- 입사 후 일주일 이내인 직원 명단
SELECT   EMPLOYEE_ID, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
FROM     EMPLOYEES
WHERE    HIRE_DATE >= SYSDATE - 7;

-- 화요일 입사자 출력


-- 08월 입사자의 사번, 이름, 입사일을 입사일 순으로
SELECT EMPLOYEE_ID                          사번,
        FIRST_NAME || ' ' || LAST_NAME      이름,
        TO_CHAR(HIRE_DATE, 'YYYY-MM')    입사일
FROM    EMPLOYEES
WHERE   TO_CHAR(HIRE_DATE, 'MM') = '08';

-- 부서번호 80이 아닌 직원
SELECT EMPLOYEE_ID, DEPARTMENT_ID
FROM   EMPLOYEES
WHERE  DEPARTMENT_ID != 80;  -- <> , != 같지 않다
-- =.<>, >, <, >=, <=, BETWEEN~AND
-- +, -, *, /, MOD(7, 2) 


/* 직원 사번, 입사일 */
-- 2026년 04월 07일 10시 05분 04초 오전 수요일
-- 한자로 출력(午前 / 午後 / 年月日時分秒 /

SELECT TO_CHAR(SYSDATE, 'YYYY') || '年 '
    || TO_CHAR(SYSDATE, 'MM') || '月 '
    || TO_CHAR(SYSDATE, 'DD') || '日 '
    || TO_CHAR(SYSDATE, 'HH12') || '時 '
    || TO_CHAR(SYSDATE, 'MI') || '分 '
    || TO_CHAR(SYSDATE, 'SS') || '秒 '
    || CASE TO_CHAR(SYSDATE, 'DY')
        WHEN '일' THEN '日'
        WHEN '화' THEN '火'
        WHEN '수' THEN '水'
        WHEN '목' THEN '木'
        WHEN '토' THEN '金'
        WHEN '일' THEN '土'
        END                        || '曜日 '
    || DECODE(TO_CHAR(SYSDATE, 'AM') , '오전', '午前', 
                                         '오후', '午後')  
FROM DUAL;

--1. TO_CHAR 활용
SELECT SYSDATE,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY AM'), 
        TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초" DAY AM'),
        TO_CHAR(SYSDATE, 'YYYY"年"MM"月"DD"日" HH24"時"MI"分"SS"秒" DAY AM'),
        TO_CHAR(SYSDATE, 'AM')
FROM    DUAL;

--2. IF를 구현  -> DECODE() : ORARCLE
--2-1) NVL(), NVL2()
-- 사번, 이름, 월급, COMMISION_PCT(단 NULL이면 0이라고 출력)
SELECT  EMPLOYEE_ID                         사번,
        FIRST_NAME || ' ' || LAST_NAME      이름,
        SALARY                               월급,
        NVL(COMMISSION_PCT, 0)                보너스,
        NVL2(COMMISSION_PCT, SALARY+(SALARY*COMMISSION_PCT), SALARY)
FROM     EMPLOYEES;


--2-2) NULLIF()



-- 2-3) DECODE(expr, search1, search2)
--DECODE는 expr(기준값)과 search1을 비교해 두 값이 같으면 result1을, 
--ELSE 다시 search2와 비교해 값이 같으면 result2를 반환하고, 
--계속 비교한 뒤 같은 값이 없으면 default 값을 반환한다.
-- 사번, 부서번호(단 부서번호가 NULL이면 '부서없음')
SELECT  EMPLOYEE_ID                                         사번,
        --NVL(DEPARTMENT_ID,'부서없음')       부서번호
        DECODE(DEPARTMENT_ID,NULL,'부서없음',DEPARTMENT_ID) 부서번호
FROM    EMPLOYEES ;

-- 오전(오전)/오후(오후)
SELECT TO_CHAR(SYSDATE, 'AM'),
        DECODE(TO_CHAR(SYSDATE, 'AM'), '오전', '午前', '午後')
FROM DUAL;

--------------------------------------------
/*
10	Administration
20	Marketing
30	Purchasing
40	Human Resources
50	Shipping
60	IT
70	Public Relations
80	Sales
90	Executive
100	Finance
110	Accounting
*/
-- 사번, 이름, 부서명
SELECT  EMPLOYEE_ID                         사번,
        FIRST_NAME || ' ' || LAST_NAME      이름,
        DECODE(DEPARTMENT_ID, 60, 'IT',
                              90, 'Executive',
                              80, 'Sales'
                                ,  '그외'
        )                            부서명
FROM   EMPLOYEES;

-- 사번, 이름, 부서명: 모든 부서명, NULL: 부서없음
SELECT  EMPLOYEE_ID                    사번,
        FIRST_NAME || ' ' || LAST_NAME  이름,
        DECODE(DEPARTMENT_ID,  10,	'Administration',
                                20,	'Marketing',
                                30,	'Purchasing',
                                40,	'Human Resources',
                                50,	'Shipping',
                                60,	'IT',
                                70,	'Public Relations',
                                80,	'Sales',
                                90,	'Executive',
                                100,	'Finance',
                                110,	'Accounting',
                                     '부서없음'
        )                       부서명                         
FROM   EMPLOYEES;

-- NULL이 계산에 포함되면 결과는 NULL
-- 직원명단,직원월급, 보너스 출력, 연봉출력
SELECT EMPLOYEE_ID                                     사번,
        FIRST_NAME || ' ' || LAST_NAME                 이름,
        SALARY                                         월급,
        NVL(SALARY*COMMISSION_PCT, 0)                  보너스,
        SALARY * 13 + NVL(SALARY*COMMISSION_PCT, 0)    연봉
FROM   EMPLOYEES;

---------------------------------------
-- 3) CASE WHEN THEN END
-- WHEN SCORE BETWEEN 90 AND 100 THEN 'A'
-- WHEN 90 <= SCORE AND SCORE <= 100 THEN 'A'
-- 사번, 이름, 부서명
SELECT  EMPLOYEE_ID                     사번,
        FIRST_NAME || ' ' || LAST_NAME  이름,
        CASE DEPARTMENT_ID
            WHEN 60 THEN 'IT'
            WHEN 80 THEN 'Sales'
            WHEN 90 THEN 'Executive'
            ELSE          '그 외'
        END                             부서명
FROM     EMPLOYEES;

SELECT  EMPLOYEE_ID                     사번,
        FIRST_NAME || ' ' || LAST_NAME  이름,
        CASE 
            WHEN DEPARTMENT_ID = 60 THEN 'IT'
            WHEN DEPARTMENT_ID = 80 THEN 'Sales'
            WHEN DEPARTMENT_ID = 90 THEN 'Executive'
            ELSE          '그 외'
        END                             부서명
FROM     EMPLOYEES;


-----------------------------------
-- 집계 함수: AGGREGATE 함수
-- 모든 집계 함수는 NULL 값은 포함하지 않음
-- SUM(), AVG(), MIN(), MAX(), COUNT()
-- 그루핑: GROUP BY
-- ~별 인원수

SELECT * FROM EMPLOYEES;
SELECT COUNT(*) FROM EMPLOYEES; -- 109 : ROW 줄 수
SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES; -- 109
SELECT COUNT(DEPARTMENT_ID) FROM EMPLOYEES; -- 106

SELECT EMPLOYEE_ID          FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

SELECT COUNT(EMPLOYEE_ID)          FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

-- 전체 직원의 월급 합: 세로 합 (NULL 제외)
SELECT COUNT(SALARY) FROM EMPLOYEES;   -- 107
SELECT SUM(SALARY) FROM EMPLOYEES;     -- 691416
SELECT AVG(SALARY) FROM EMPLOYEES;     -- 6461.831775700934579439252336448598130841
SELECT MAX(SALARY) FROM EMPLOYEES;     -- 24000
SELECT MIN(SALARY) FROM EMPLOYEES;     -- 2100

SELECT SUM(SALARY) / COUNT(SALARY)  FROM EMPLOYEES; -- 6461.831775700934579439252336448598130841
SELECT SUM(SALARY) / COUNT(*)  FROM EMPLOYEES;      -- 6343.266055045871559633027522935779816514
--  평균값이 다른 이유:  ALL 했을 경우 NULL 값을 가진 데이터값이 있기 때문 평균값 변동

-- 60번 부서의 평균 월급
SELECT  AVG(SALARY)
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID = 60;


-- EMPLOYEES 테이블의 부서수를 알고 싶다
SELECT COUNT(DEPARTMENT_ID)
FROM    EMPLOYEES           ;   -- 106


-- 중복 제거(DISTINCT)한 부서의 수를 출력
-- 중복 제거한 부서번호 리스트: NULL이 출력됨
SELECT DISTINCT(DEPARTMENT_ID)
FROM    EMPLOYEES           ;               -- 12

SELECT COUNT(DISTINCT(DEPARTMENT_ID))
FROM    EMPLOYEES           ;               -- 11

-- 직원이 근무하는 부서의 수: 부서장이 있는 부서 수: DEPARTMENTS
SELECT COUNT(DISTINCT(DEPARTMENT_ID))
FROM    EMPLOYEES           ; 
SELECT COUNT(*) 
FROM    DEPARTMENTS           
WHERE MANAGER_ID IS NOT NULL; 


SELECT 7 / 2,
        ROUND(123.456, 2),   ROUND(123.456, -2),
        TRUNC(123.456, 2),   TRUNC(123.456, -2)
FROM DUAL;

-- 직원 수, 월급합, 월급평균, 최대월급, 최소월급
SELECT   COUNT(*)                직원수,
          SUM(SALARY)             월급합,
        ROUND(AVG(SALARY),3)     월급평균,
          MAX(SALARY)            최대월급,
          MIN(SALARY)            최소월급
FROM    EMPLOYEES; 

-----------------------
SQL 문의 실행 순서
1. FROM
2. WHERE
3. SELECT
4. ORDER BY
-----------------------

-- 부서 60번 부서 인원수, 월급 합, 월급 평균
SELECT  COUNT(*)        인원수,
        SUM(SALARY)      월급합,
        AVG(SALARY)      월급평균
FROM    EMPLOYEES           
WHERE  DEPARTMENT_ID = 60; 


-- 부서 50, 60, 80번 부서가 아닌 인원수, 월급합, 월급평균
SELECT  COUNT(*)        인원수,
        SUM(SALARY)      월급합,
        ROUND(AVG(SALARY),3)      월급평균
FROM    EMPLOYEES           
WHERE DEPARTMENT_ID IS NOT NULL
AND   DEPARTMENT_ID NOT IN(50, 60, 80); 
 