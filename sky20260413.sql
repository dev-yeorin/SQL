SQL> SHOW USER
USER은 "SKY"입니다

에 작업
------------------------------------------------------
새 계정으로 접속한 후 작업

SKY에서 HR 계정의 DATA를 가져온다
SQLPLUS 에서 작업
1. 먼저 HR로 로그인한다
win+r : cmd
   >SQLPLUS hr/1234
SQL> GRANT SELECT ON EMPLOYEES TO SKY;


2. HR에서 다른 계정인 SKY에게 SELECT 할 수 있는 권한을 부여
SQL> GRANT SELECT ON EMPLOYEES TO SKY;
권한이 부여되었습니다.
SQL> SHOW USER
USER은 "HR"입니다

3. SKY 로그인
SQL> CONN SKY/1234
연결되었습니다.

4. SKY에서 HR 계정의 EMPLOYEES를 조회
SQL> SELECT * FROM HR.EMPLOYEES;   -- 조회 성공
SQL> SELECT * FROM HR.DEPARTMENTS; -- 조회 실패

-------------------------------------------------------
ORACLE 의 TABLE 복사하기
HR 의 EMPLOYEES TABLE을 복사해서 SKY로 가져온다

[1] 테이블 생성
1. 테이블 복사
  대상: 테이블 구조, 데이터 (제약 조건의 일부만 복사(NOT NULL))
  
  1) 구조, 데이터 다 복사, 제약 조건은 일부만 복사
  CREATE TABLE EMP1
  AS
    SELECT * FROM HR.EMPLOYEES;
    
  2) 구조, 데이터 다 복사, 50번, 80번 부서만 복사
  CREATE TABLE EMP2
  AS
    SELECT * FROM HR.EMPLOYEES
    WHERE DEPARTMENT_ID IN (50, 80);

  3) DATA 빼고 구조만 복사
  CREATE TABLE EMP3
  AS
    SELECT * FROM HR.EMPLOYEES
    WHERE 1 = 0 ;
    
    
  4) 구조만 복사된 TABLE EMP3에 DATA만 추가 
  CREATE TABLE EMP4
  AS
    SELECT * FROM HR.EMPLOYEES
    WHERE 1 = 0 ;
    
 -- DATA만 추가
   INSERT INTO EMP4
   SELECT * FROM HR.EMPLOYEES;
   COMMIT;
   
   5) 일부 칼럼만 복사해서 새로운 테이블 생성
   CREATE TABLE EMP5
   AS
     SELECT EMPLOYEE_ID                    EMPID,
            FIRST_NAME || ' ' || LAST_NAME  ENAME,
            SALARY                          SAL,
            SALARY * COMMISSION_PCT         BONUS,
            MANAGER_ID                      MGR,
            DEPARTMENT_ID                   DEPTID
    FROM    HR.EMPLOYEES;
    
    