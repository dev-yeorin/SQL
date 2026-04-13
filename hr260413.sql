------------------------------------------------------------------------------
-- 부프로그램  , 함수
1. 프로시저 , (PROCEDURE) --  SUBROUTINE : 함수보다 더 많이 사용한다
   : 리턴값이 0개 이상
   STORED PROCEDURE
2. 함수 (FUNCTION)
   : 반드시 리턴값이 1개

USER DEFINE FUNCTION - 사용자 정의 함수, 우리가 함수를 만든다

------------------------------------------------------------------------------
------------------------------------------------------------------------------
--PROCEDURE

-- 107번 직원의 이름과 월급 조회
SELECT E.FIRST_NAME||' '||E.LAST_NAME,SALARY
FROM EMPLOYEES E
WHERE EMPLOYEE_ID = 107
;

익명 블록
SET SERVEROUTPUT ON;
DECLARE
    V_NAME  VARCHAR2(46);
    V_SAL   NUMBER(8, 2);
BEGIN
    V_NAME  := '카리나';
    V_SAL   := 10000;
    DBMS_OUTPUT.PUT_LINE(V_NAME);
    DBMS_OUTPUT.PUT_LINE(V_SAL);
    IF V_SAL >= 1000 THEN
        DBMS_OUTPUT.PUT_LINE('Good');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Not Good');
    END IF;
END;
/
저장 프로시저 (IN : INPUT, OUT : OUTPUT, INOUT : INPUTOUT)
CREATE PROCEDURE GET_EMPSAL( IN_EMPID   IN NUMBER)
IS 
    V_NAME      VARCHAR2(46);
    V_SAL       NUMBER(8, 2);
    BEGIN
        SELECT  FIRST_NAME||' '||LAST_NAME, SALARY
        INTO    V_NAME, V_SAL
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = IN_EMPID;
        
    DBMS_OUTPUT.PUT_LINE('이름:' || V_NAME);
    DBMS_OUTPUT.PUT_LINE('이름:' || V_SAL );
    END;
/

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- 부서번호 입력, 해당부서의 최고월급자의 이름, 월급 출력
SELECT  E.DEPARTMENT_ID
        ,E.FIRST_NAME || ' ' || E.LAST_NAME 
        ,E.SALARY
FROM    EMPLOYEES E
WHERE   (E.DEPARTMENT_ID, E.SALARY) IN (
            SELECT  DEPARTMENT_ID,
                    MAX(SALARY)
            FROM    EMPLOYEES
            GROUP BY DEPARTMENT_ID
        );
;
-- 90번 부서번호입력, 직원들 출력
SELECT E.FIRST_NAME||' '||E.LAST_NAME, E.EMPLOYEE_ID, E.DEPARTMENT_ID
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = 90
;