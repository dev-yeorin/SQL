성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 CREATE TABLE STUDENT
 (
        STID  NUMBER(6)      NOT NULL     -- 학번 숫자(6) 기본키
    , STNAME  VARCHAR2(30)   NOT NULL     -- 이름 문자(30) 필수입력
    , PHONE   VARCHAR2(20)   UNIQUE       -- 전화 문자(20) 중복방지
    , INDATE  DATE    DEFAULT   SYSDATE  -- 입학일 날짜 기본값 오늘

 );
 
 -- 학생 정보 입력
INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE)
    VALUES               (1, '가나', 010-0000-0000, SYSDATE);

INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE)
    VALUES               (2, '나나', 011-0000-0000, SYSDATE);
    
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (3, '다나', 012-0000-0000);

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (4, '라나', 013-0000-0000);

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (5, '마나', 014-0000-0000);
    
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (NULL, '사나', 015-0000-0000); -- 압력 안 됨 PRIMARY KEY
    -- SQL 오류: ORA-01400: NULL을 ("SKY"."STUDENT"."STID") 안에 삽입할 수 없습니다

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (5, '마나', 014-0000-0000); -- 입력 안 됨, 기본키 중복 X
    -- ORA-00001: 무결성 제약 조건(SKY.SYS_C008390)에 위배됩니다
   
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (6, '하나', 014-0000-0000); -- 입력 안 됨, PHONE 넘버 중복
    -- ORA-00001: 무결성 제약 조건(SKY.SYS_C008391)에 위배됩니다
    
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (7, NULL, 015-0000-0000); -- 입력 안 됨 STNAME NOT NULL 제약 조건 위반
    -- SQL 오류: ORA-01400: NULL을 ("SKY"."STUDENT"."STNAME") 안에 삽입할 수 없습니다
    
COMMIT;

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES               (6, '하나', 019-0000-0000);
    
SELECT * FROM STUDENT;
    
COMMIT;
    
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 CREATE TABLE SCORES
 (
      SCID        NUMBER(7)       NOT NULL                                           -- 일련번호 숫자(7) 기본키, 번호자동증가
    , SUBJECT     VARCHAR2(60)    NOT NULL                                  -- 교과목 문자(60) 필수입력,
    , SCORE       NUMBER(3)       CHECK (SCORE BETWEEN 0 AND 100)          -- 숫자(3)         범위 0 ~ 100
    , STID        NUMBER(6)                                                  -- 학번     숫자(6) 외래키
    , CONSTRAINT SCID_PK
      PRIMARY KEY (SCID, SUBJECT)
    , CONSTRAINT STID_FK
      FOREIGN KEY (STID)
      REFERENCES STUDENT(STID)
 );
 
 SELECT * FROM SCORES;
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
  