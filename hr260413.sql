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
파라미터는  IN_EMPID   IN NUMBER 괄호와 숫자 사용하지 않는다
내부 변수는 V_NAME                반드시 괄호와 숫자가 필요하다 
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
    DBMS_OUTPUT.PUT_LINE('월급:' || V_SAL );
    END;
/
테스트
SET SERVEROUTPUT ON; --  DBMS_OUTPUT.PUT_LINE(); 의 결과를 화면에 출력
CALL GET_EMPSAL( 107 );
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- 부서번호 입력, 해당부서의 최고월급자의 이름, 월급 출력
CREATE OR REPLACE PROCEDURE GET_NAME_MAXSAL(
        IN_DEPTID   IN  NUMBER,
        O_NAME      OUT VARCHAR2,
        O_SAL       OUT NUMBER
        
        
)
IS
        V_MAXSAL    NUMBER(8, 2);
    BEGIN
        SELECT MAX(SALARY)
        INTO    V_MAXSAL
        FROM   EMPLOYEES
        WHERE  DEPARTMENT_ID    = IN_DEPTID;
        
        SELECT FIRST_NAME || ' ' || LAST_NAME, SALARY
        INTO    O_NAME,                         O_SAL
        FROM   EMPLOYEES
        WHERE   SALARY        = V_MAXSAL
        AND     DEPARTMENT_ID = IN_DEPTID;
        
        DBMS_OUTPUT.PUT_LINE( O_NAME );
        DBMS_OUTPUT.PUT_LINE( O_SAL );
    END;
/
테스트 : 90, 60, 50
SET SERVEROUTPUT  ON;
VAR O_NAME  VARCHAR2;
VAR O_SAL   NUMBER;
CALL GET_NAME_MAXSAL(60, :O_NAME, :O_SAL);
PRINT   O_NAME;
PRINT   O_SAL;
-- > JAVA에서 호출해서 쓴다


-- 90번 부서번호입력, 직원들 출력: 결과가 여러 줄일 때
CREATE  OR REPLACE PROCEDURE GETEMPLIST(
    IN_DEPTID NUMBER
)
IS
    V_EMPID   NUMBER(6);      
    V_FNAME VARCHAR2(20);      
    V_LNAME VARCHAR2(25);   
    V_PHONE VARCHAR2(20);
    BEGIN
        SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER
        INTO    V_EMPID,      V_FNAME,      V_LNAME,   V_PHONE       
        FROM   EMPLOYEES
        WHERE  DEPARTMENT_ID = IN_DEPTID;
        
        DBMS_OUTPUT.PUT_LINE( V_EMPID );
    END;
/
-- 테스트
SET          SERVEROUTPUT ON;
EXECUTE    GETEMPLIST(  90  );

*
오류 발생 행: 1:
ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
ORA-06512: "HR.GETEMPLIST",  10행
ORA-06512:  1행

결과가 3줄인데 한번만 출력함
***  SELECT INTO는 결과가 한줄일 때만 사용 가능
-- 정상 작동
해결책 커서(CURSOR) 사용
CREATE  OR REPLACE PROCEDURE GET_EMPLIST(
    IN_DEPTID IN    NUMBER,
    O_CUR     OUT   SYS_REFCURSOR
)
IS
    BEGIN
    OPEN O_CUR FOR
        SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER     
        FROM   EMPLOYEES
        WHERE  DEPARTMENT_ID = IN_DEPTID;
        
    END;
/
-- 테스트
VARIABLE O_CUR      REFCURSOR;
EXECUTE GET_EMPLIST(50, :O_CUR)
PRINT   O_CUR;


---------------------------------------------------------
DDL: DATA DEFINITION LANGUAGE
구조를 생성, 변경, 제거

CREATE
ALTER
DROP

계정 생성
아이디  : SKY
비밀번호: 1234
CMD
Microsoft Windows [Version 10.0.19045.6218]
(c) Microsoft Corporation. All rights reserved.

C:\Users\GGG>sqlplus /nolog

SQL*Plus: Release 21.0.0.0.0 - Production on 월 4월 13 14:06:41 2026
Version 21.3.0.0.0
Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SQL> conn /as sysdba
연결되었습니다.
SQL> show user
USER은 "SYS"입니다
SQL> ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
세션이 변경되었습니다.

SQL> CREATE USER SKY IDENTIFIED BY 1234;
사용자가 생성되었습니다.

SQL> GRANT CONNECT, RESOURCE TO SKY;
권한이 부여되었습니다.

SQL> ALTER USER SKY DEFAULT TABLESPACE
  2  USERS QUOTA UNLIMITED ON USERS;
사용자가 변경되었습니다.

SQL> CONN SKY/1234
연결되었습니다.
SQL> SHOW USER
USER은 "SKY"입니다


------------------------------------------------------
새 계정으로 접속한 후에 작업