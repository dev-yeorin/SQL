select * from tab ; -- 테이블 목록 조회

/*
SELECT   칼럼명1 별칭1, 칼럼명2 별칭2, 
FROM     테이블명
WHERE    조건
ORDER BY 정렬할 칼럼1 ASC, 정렬할 칼럼2 DESC;
*/

-- 직원 이름
SELECT  FIRST_NAME, LAST_NAME,
         FIRST_NAME || ' ' || LAST_NAME EMPNAME
FROM    EMPLOYEES
-- ORDER BY FIRST_NAME
ORDER BY 3 -- 3번째 칼럼 기준 정렬
;



-- 직원의 이름을 성과 이름으로 붙여서 출력
SELECT EMPLOYEE_ID                     번호,
        FIRST_NAME || ' ' || LAST_NAME   이름,
        EMAIL                           이메일,
        DEPARTMENT_ID                     부서
FROM    EMPLOYEES
ORDER BY 이름 ASC;

-- 부서 번호가 60인 직원 정보
-- 조건: =, !=(<>, ^=)
--     : >, <, >=, <=
--     : NOT, AND, OR(우선순위 순)
SELECT EMPLOYEE_ID                     번호,
        FIRST_NAME || ' ' || LAST_NAME   이름,
        EMAIL                           이메일,
        DEPARTMENT_ID                     부서
FROM    EMPLOYEES
WHERE  DEPARTMENT_ID = 60
ORDER BY 이름 ASC;


-- 부서 번호가 90인 직원 정보
SELECT EMPLOYEE_ID                     번호,
        FIRST_NAME || ' ' || LAST_NAME   이름,
        EMAIL                           이메일,
        DEPARTMENT_ID                     부서
FROM    EMPLOYEES
WHERE  DEPARTMENT_ID = 90
ORDER BY 이름 ASC;


-- 부서 번호가 60, 90 부서의 직원 정보
-- IN 명령어 => OR 대체재
SELECT     E.EMPLOYEE_ID                       번호,
            E.FIRST_NAME || ' ' || E.LAST_NAME   이름,
            E.EMAIL                              이메일,
            DEPARTMENT_ID                        부서번호
FROM        EMPLOYEES  E
/*
WHERE       DEPARTMENT_ID = 60
 OR         DEPARTMENT_ID = 90
*/
WHERE       DEPARTMENT_ID IN(60, 90, 80)
ORDER BY  번호 ASC, 이름 ASC ;  -- 부서번호순, 부서 번호가 같으면 이름순

-- 1. 월급이 12,000 이상인 직원의 번호, 이름, 이메일, 월급을 월급순으로 출력
SELECT EMPLOYEE_ID                      번호, 
        FIRST_NAME || ' ' || LAST_NAME   이름,
        EMAIL                            이메일,
        SALARY                           월급
FROM    EMPLOYEES
WHERE   SALARY >= 12000
ORDER BY SALARY DESC;

-- 2. 월급이 10000~15000 인 직원의 사번, 이름, 월급, 부서번호
SELECT EMPLOYEE_ID,                     
        FIRST_NAME || ' ' || LAST_NAME,
        SALARY,
        DEPARTMENT_ID        
FROM    EMPLOYEES
WHERE  SALARY BETWEEN 10000 AND 15000
ORDER BY SALARY DESC;

-- 3. 직업 ID가 IT_PROG인 직원 명단
-- 2) upper(), lower(), INITCAP() 함수
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        JOB_ID                직업,
        SALARY               월급,
        DEPARTMENT_ID           부서번호
FROM      EMPLOYEES
WHERE UPPER(JOB_ID) = 'IT_PROG'
ORDER BY 번호 ASC;


-- 4. 직원 이름 grant
select EMPLOYEE_ID,
        FIRST_NAME || ' ' || LAST_NAME,
        JOB_ID,
        SALARY,
        DEPARTMENT_ID
FROM    EMPLOYEES
WHERE  UPPER(FIRST_NAME) LIKE '%GRANT%' 
OR     UPPER(LAST_NAME) LIKE '%GRANT%';


-- 5. 사번, 월급, 10% 인상한 월급
/*
SELECT EMPLOYEE_ID,
        FIRST_NAME || ' ' || LAST_NAME,
        SALARY,
        COMMISSION_PCT
FROM    EMPLOYEES
WHERE  COMMISSION_PCT = 0.1;
*/

SELECT EMPLOYEE_ID     사번,
        FIRST_NAME || ' ' || LAST_NAME  이름,
        SALARY          월급,
        SALARY * 1.1    인상월급
FROM    EMPLOYEES
ORDER BY SALARY * 1.1  DESC;       
       
-- 6. 50번 부서의 직원 명단, 월급, 부서번호
SELECT EMPLOYEE_ID,
        FIRST_NAME || ' ' || LAST_NAME,
        SALARY,
        DEPARTMENT_ID
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID = 50;

-- 7. 20, 80, 60, 90 번 부서의 직원 명단, 월급, 부서번호
SELECT EMPLOYEE_ID,
        FIRST_NAME || ' ' || LAST_NAME,
        SALARY,
        DEPARTMENT_ID
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID IN (20, 60, 80, 90);

-- 중요 데이터 2개 추가
 SELECT   COUNT(*)
 FROM     EMPLOYEES; -- 107 ROW의 COUNT
 
 -- 신입사원 입사(박보검, 카리나)
 INSERT  INTO EMPLOYEES
 VALUES ( 207, '보검', '박', 'BOKUM', '1.515.555.8888', SYSDATE, 
        'IT_PROG', NULL, NULL, NULL, NULL);
        
INSERT INTO EMPLOYEES
VALUES ( 208, '리나', '카', 'LINA', '1.515.555.9999', SYSDATE,
        'IT_PROG', NULL, NULL, NULL, NULL);
        
SELECT *         FROM EMPLOYEES;
SELECT COUNT(*) FROM EMPLOYEES;

UPDATE EMPLOYEES
SET     EMAIL = 'KARINA',
        PHONE_NUMBER = '010-1234-5678'
WHERE EMPLOYEE_ID = 208;



COMMIT;


-- 8. 보너스 없는 직원 명단(COMMISSION_PCT가 없다)
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        SALARY               월급,
        COMMISSION_PCT          보너스,
        DEPARTMENT_ID           부서번호
FROM      EMPLOYEES
WHERE COMMISSION_PCT IS NULL;




-- 9. 전화번호가 010으로 시작하는
-- PATTERN MATCHING
-- % : 0 자 이상의 모든 숫자 글자
-- _ : 1 자의 모든 숫자 글자
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        PHONE_NUMBER              전화번호,
        SALARY               월급,
        DEPARTMENT_ID           부서번호
FROM      EMPLOYEES
--WHERE PHONE_NUMBER LIKE '010%'; -- 010으로 시작하는(STARTS WITH)
WHERE PHONE_NUMBER LIKE '%555%'; -- CONTAINS를 포함하는
--WHERE PHONE_NUMBER LIKE '%16'  ; -- ENDS WITH 로 끝나는 




-- 10. LAST_NAME 세번째, 네번째 글자가 LL인 것을 찾기
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        PHONE_NUMBER              전화번호,
        SALARY               월급,
        DEPARTMENT_ID           부서번호
FROM      EMPLOYEES
WHERE UPPER(LAST_NAME) LIKE '__LL%';

------------------------------------------
SELECT EMPLOYEE_ID, FIRST_NAME, HIRE_DATE
FROM   EMPLOYEES
WHERE 
;



-- 날짜 26/04/07 : 표현법이 틀림 년/월/일
-- 2026-04-07    : ANSI 표준
-- 04/07/26      : 월/일/년 -> 미국식
-- 07/04/26      : 일/월/년 -> 영국식

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT  SYSDATE     FROM DUAL;       -- 26/04/07, 2026-04-07 16:27:43
SELECT 7/2          FROM DUAL;       -- 3.5
SELECT 0/2          FROM DUAL;       -- 0
SELECT 2/0          FROM DUAL;       -- ORA-01476 : 제수가 0입니다
SELECT SYSTIMESTAMP FROM DUAL;       -- 26/04/07 15:35:44.551000000 +09:00

SELECT SYSDATE - 7     "일주일 전 날짜"
    ,  SYSDATE          "오늘 날짜"
    ,  SYSDATE + 7      "일주일 후 날짜"
FROM  DUAL;
날짜 + N, 날짜 - N : 며칠 전, 후
날짜1 - 날짜2 : 두 날짜 사이의 차이를 날 수로 계산
날짜1 + 날짜 : 오류, 잘못된 표현 - 의미 없음


-- 크리스마스 - 오늘날짜의 차이
SELECT TO_DATE('26/12/25') - SYSDATE
FROM  DUAL;  -- 261.341018518518518518518518518518518519

-- 소수이하 3자리 반올림: ROUND(VAL, 3)
-- 소수이하 3자리 절사: TRUNC(VAL, 3)
-- 15일 기준으로 반올림 날짜 : ROUND(SYSDATE, 'MONTH')
-- 해당 달의 첫번째 날짜: TRUNC(SYSDATE, 'MONTH')
SELECT SYSDATE, ROUND(SYSDATE, 'MONTH'), TRUNC(SYSDATE, 'MONTH')
FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '월요일') FROM DUAL;    -- 26/04/13: 다음 월요일
SELECT TRUNC(SYSDATE, 'MONTH') FROM DUAL;       -- 26/04/01: 날짜에 해당 월의 첫번째 날
SELECT LAST_DAY(SYSDATE) FROM DUAL;             -- 26/04/30: 날짜에 해당 월의 마지막 날

-- 11. 입사년월이 17년 2월인 사원 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT *
FROM      EMPLOYEES
-- WHERE TRUNC(HIRE_DATE, 'MONTH') = '2017-02-07';
/*
WHERE HIRE_DATE
    BETWEEN'2017-02-07'
    AND     LAST_DAY('2017-02-01');
*/
WHERE TO_CHAR(HIRE_DATE, 'YYYY-MM') = '2017-02';


-- 12. '17/02/07' 에 입사한 사람 출력
-- '12/06/07' 에 입사한 사람 출력
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        HIRE_DATE               입사일,
        SALARY               월급,
        DEPARTMENT_ID           부서번호
FROM      EMPLOYEES
WHERE HIRE_DATE = '2017-02-07'
OR    HIRE_DATE = '2012-06-07';


-- 13. 오늘 '26/04/07' 입사한 사람
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        HIRE_DATE               입사일,
        SALARY               월급,
        DEPARTMENT_ID           부서번호
FROM      EMPLOYEES
-- WHERE TRUNC(HIRE_DATE) = '26/04/07 00:00:00';
WHERE '2026-04-07 00:00:00' <= HIRE_DATE
AND    HIRE_DATE <= '2026-04-07 23:59:59';

-- TYPE 변환
-- TO_DATE(문자) -> 날짜
-- TO_NUMBER(문자) -> 숫자
-- TO_CHAR(숫자, '포맷') -> 글짜
-- TO_CHAR(날짜, '포맷') -> 날짜 형태의 문자
-- FORMAT : YYYY-MM-DD HH24:MI:SS DAY AM
    -- YYYY : 연도
    -- MM   : 월
    -- DD   : 일
    -- HH24 : 24시 (HH12 : 12시) /  MI : 분  / SS : 초
    -- DAY  : 요일 , 일요일
    -- DY   : 요일 , 일
    -- AM/PM   : 오전/ 오후



-- 입사 후 일주일 이내인 직원 명단
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') 입사일
FROM EMPLOYEES
WHERE SYSDATE - HIRE_DATE <= 7;

-- 화요일 입사자 출력
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        TO_CHAR(HIRE_DATE, 'YYYY-MM-DD'),
        TO_CHAR(HIRE_DATE, 'DAY')
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'DY') = '화'
ORDER BY HIRE_DATE ASC;

-- 08월 입사자의 사번, 이름, 입사일을 입사일 순으로
SELECT EMPLOYEE_ID          번호,
        FIRST_NAME || ' ' || LAST_NAME 이름,
        TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') 입사일
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'MM') = 08
ORDER BY HIRE_DATE ASC;

-- 부서번호 80이 아닌 직원
SELECT EMPLOYEE_ID,
        FIRST_NAME || ' ' || LAST_NAME,
        SALARY,
        DEPARTMENT_ID
FROM    EMPLOYEES
WHERE   DEPARTMENT_ID != 80;


/* 직원 사번, 입사일 */

-- 2026년 04월 07일 10시 05분 04초 오전 수요일
-- 한자로 출력

