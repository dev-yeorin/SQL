시퀀스 : SEQUENCE : 번호 자동 증가
-- 번호 칼럼에 자동으로 번호를 증가
-- // 자동 번호 증가가 가능하지만 삭제 후 다시 증가하면 이전 번호의 자동 증가가 됨

CREATE TABLE TABLE1 (
    ID        NUMBER            PRIMARY KEY,
    TITLE     VARCHAR2(400),
    MEMO      VARCHAR2(4000)
);


--INSERT INTO TABLE1 VALUES (1, 'A', 'AAAA');
--INSERT INTO TABLE1 VALUES (2, 'B', 'ㅋㅋㅋㅋ');
--INSERT INTO TABLE1 VALUES (3, 'A', 'ㅇㅇ');

CREATE SEQUENCE SEQ_ID;
SEQ_ID.NEXTVAL
SEQ_ID.CURRVAL

SELECT SEQ_ID.CURRVAL FROM DUAL; -- 6 : 시퀀스의 현재 번호
SELECT SEQ_ID.NEXTVAL FROM DUAL; -- 7 : 시퀀스의 새로운 번호를 발급받음
-- 중간에 데이터 삭제되면 빈 번호 공간이 생김
-- 대체 방안: (SELECT NVL(MAX(ID),0)+1 FROM TABLE1)



INSERT INTO TABLE1 VALUES (SEQ_ID.NEXTVAL, 'A', 'AAAA');
INSERT INTO TABLE1 VALUES (SEQ_ID.NEXTVAL, 'B', 'ㅋㅋㅋㅋ');
INSERT INTO TABLE1 VALUES (SEQ_ID.NEXTVAL, 'A', 'ㅇㅇ');
INSERT INTO TABLE1 VALUES ((SELECT NVL(MAX(ID),0)+1 FROM TABLE1), 'A', 'AAAA');

COMMIT;

DELETE FROM TABLE1;

번호자동 증가
MSSQL: IDENTITY(), SEQUENCE
    CREATE TABLE ATABLE(
        ID INT IDENTITY(1,1)       -- 1부터 시작에서 1씩 증가
    )

MSSQL
    CREATE TABLE ATABLE(
        ID INT AUTO_INCREMENT
    )

------------------------------------------------------------------------------
PRIMARY KEY 값 수정 가능/불가능


UPDATE TABLE1
SET    STID = 1
WHERE  STID = 4;
-- 외래키 미설정으로 수정 가능



UPDATE STUDENT
SET    STID = 7
WHERE  STID = 1;
-- 외래키 설정으로 수정 불가 : 오류 발생(자식 레코드)

------------------------------------------------------------------------------
인덱스: INDEX (찾아보기 표)
-- 검색할 때 해당 칼럼에 인덱스를 사용하면 검색이 빨라진다
단, INSERT, DELETE, UPDATE를 사용할 때 새로 인덱스를 고쳐야 하므로
    추가, 수정 같은 작업이 많으면 더 느려질 수 있다
    
WHERE 문에 사용하는 칼럼이나 JOIN ON 에 사용하는 칼럼에 설정
PRIMARY KEY, UNIQUE -> 자동으로 인덱스 생성


CREATE TABLE emp_big AS
SELECT
    e.employee_id + (lv * 100000) AS employee_id,
    e.first_name,
    e.last_name,
    e.email || lv AS email,
    e.phone_number,
    e.hire_date,
    e.job_id,
    e.salary,
    e.commission_pct,
    e.manager_id,
    e.department_id
FROM hr.employees e
CROSS JOIN (
    SELECT LEVEL AS lv
    FROM dual
    CONNECT BY LEVEL <= 10000
);

SELECT COUNT(*) FROM EMP_BIG; -- 1090000


-- 인덱스가 지정된 칼럼으로 초건을 걸어서 검색
SET TIMING ON;
SELECT  *
FROM    EMP_BIG
WHERE   EMAIL LIKE 'SKING5000'; -- 경과 시간: 00:00:00.426

-- 인덱스 생성
CREATE INDEX    IDX_EMAIL
  ON   EMP_BIG( EMAIL );  -- 경과 시간: 00:00:00.352
  
CREATE INDEX    IDX_NAME
    ON         EMP2(FIRST_NAME || ' ' || LAST_NAME );
    
  ------------------------------------------------------------------------
트리거 TRIGGER 방아쇠
 회원정보가 추가되면 로그에 기록을 남기는 작업을 해야 할 때
 
 상황
 1) INSERT 회원정보
 2) INSERT 로그기록
 두번 실행
 
 자동화
 1) INSERT 회원정보 -> TRIGGER 가 INSERT 로그기록 명령을 호출해서 실행
 
 단점 : 로직 추적이 쉽지 않다
    -> 트리거 남발 금지
    

    CREATE OR REPLACE TRIGGER TRG_EMP
    AFTER INSERT ON EMP_BIG
    FOR EACH ROW
        BEGIN
            INSERT 로그
        END;
    /
--------------------------------------------------------------------------
트랜잭션 TRANSACTION

송금
    1) 내 계좌에서 금액 -
    2) 상대 계좌에서 금액 +
    

1) UPDATE MTABLE
    SET   내계좌 = 내계좌 - 100
    

2) UPDATE YTABLE
    SET   상대계좌 = 상대계좌 + 100
    
    1) 번 종류 후 문제 발생 시 2) 번이 실행되지 않으면 문제 발생
    
    BEGIN TRAN
        UPDATE MTABLE
            SET   내계좌 = 내계좌 - 100
        UPDATE YTABLE
            SET   상대계좌 = 상대계좌 + 100
        COMMIT;
    END;
    
    1) 2) 번을 다 한 개의 작업 단위로 묶어서 처리
            문제 발생 시 처음으로 돌아감
            
-----------------------------------------------------------------------
LOCK : DB 잠김 - 상태;
--------------------------------------------------------------------
INSERT INTO TABLE1 VALUES ( 7, 'C', 'ㅎㅎ');

SELECT * FROM TABLE1;

WIN+R , CMD
>SQLPLUS SKY/1234
SQL> INSERT INTO TABLE1 VALUES ( 7, 'C', 'ㅎㅎ');
컴퓨터 화면이 멈춤 : RECORD LOCK 걸린 상태가 됨


SQLDELAVER에서
COMMIT;
화면
ROLLBACK;
SQLPLUS 화면에서
SQL> INSERT INTO TABLE1 VALUES ( 7, 'C', 'ㅎㅎ');
INSTER INTO TABLE1 VALUES (7, 'C', 'ㅎㅎ');
-> 무결성 제약 조건 위배


SQL> 