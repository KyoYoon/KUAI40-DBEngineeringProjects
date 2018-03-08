# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## CREATE ~ SELECT, INSERT ~ SELECT, 제약 조건의 조회, 추가, 삭제
- SELECT한 결과를 새로운 테이블을 생성하면서 INSERT 실행이 가능함.
- SELECT한 결과를 기존에 생성된 테이블에 INSERT 실행이 가능함.

-------------------------------------------------------------------------------------
1. 실습 테이블 생성
DROP TABLE notice;

CREATE TABLE notice(
  noticeno NUMBER(7)     NOT NULL,
  title       VARCHAR(100) NOT NULL,
  rname    VARCHAR(15)  NOT NULL,
  rdate     DATE                     NULL,
  PRIMARY KEY(noticeno)
);


2. INSERT
INSERT INTO notice
VALUES((SELECT NVL(MAX(noticeno), 0)+1 as noticeno FROM notice),
            '알림1', '관리자', sysdate);
INSERT INTO notice
VALUES((SELECT NVL(MAX(noticeno), 0)+1 as noticeno FROM notice),
            '알림2', '관리자', sysdate);
INSERT INTO notice
VALUES((SELECT NVL(MAX(noticeno), 0)+1 as noticeno FROM notice),
            '알림3', '관리자', sysdate);

SELECT noticeno, title, rname, rdate
FROM notice
ORDER BY noticeno ASC;

NOTICENO | TITLE | RNAME | RDATE
-------- | ----- | ----- | ---------------------
1  | 알림1  | 관리자 |  2018-02-23  13:40:12.0
2 | 알림2  | 관리자  | 2018-02-23 13:40:37.0
3 | 알림3  |  관리자 |  2018-02-23 13:40:38.0


3. 테이블 생성과 모든 컬럼의 데이터 입력처리
DROP TABLE notice_bak1;

CREATE TABLE notice_bak1
AS
SELECT *
FROM notice;

SELECT noticeno, title, rname, rdate
FROM notice_bak1
ORDER BY noticeno ASC;

NOTICENO | TITLE | RNAME | RDATE
-------- | ----- | ----- | ---------------------
1 | 알림1 |   관리자  | 2018-02-23 13:40:12.0
2 | 알림2  |  관리자  | 2018-02-23 13:40:37.0
3 | 알림3 |  관리자 |  2018-02-23 13:40:38.0


4. 테이블 생성과 필요한 컬럼의 데이터 입력처리
DROP TABLE notice_bak2;

CREATE TABLE notice_bak2
AS
SELECT noticeno, title, rname
FROM notice;

-- 에러 발생
SELECT noticeno, title, rname, rdate
FROM notice_bak2
ORDER BY noticeno ASC;

SELECT noticeno, title, rname
FROM notice_bak2
ORDER BY noticeno ASC;

NOTICENO | TITLE | RNAME
-------- | ----- | -----
1 | 알림1 |  관리자
2 | 알림2 |  관리자
3 | 알림3 |  관리자


5. SELECT 결과를 INSERT 하기

DROP TABLE notice2;
CREATE TABLE notice2(
  noticeno NUMBER(7)     NOT NULL,
  title       VARCHAR(100) NOT NULL,
  rname    VARCHAR(15)  NOT NULL,
  rdate     DATE                     NULL,
  PRIMARY KEY(noticeno)
);

INSERT INTO notice2
SELECT *
FROM notice;

SELECT noticeno, title, rname, rdate
FROM notice2
ORDER BY noticeno ASC;

NOTICENO | TITLE | RNAME | RDATE
-------- | ----- | ----- | ---------------------
1 | 알림1 |  관리자 |  2018-02-23 13:47:06.0
2 | 알림2 |  관리자 |  2018-02-23 13:47:07.0
3 | 알림3 |  관리자 |  2018-02-23 13:47:08.0


6. 필요한 컬럼만 SELECT한 결과를 INSERT 하기
DROP TABLE notice3;
CREATE TABLE notice3(
  noticeno NUMBER(7)     NOT NULL,
  title       VARCHAR(100) NOT NULL,
  rname    VARCHAR(15)  NOT NULL,
  PRIMARY KEY(noticeno)
);

INSERT INTO notice3
SELECT noticeno, title, rname
FROM notice;

또는

INSERT INTO notice3(noticeno, title, rname)
SELECT noticeno, title, rname
FROM notice;

SELECT noticeno, title, rname
FROM notice3
ORDER BY noticeno ASC;


NOTICENO | TITLE | RNAME
-------- | ----- | -----
1 | 알림1 |  관리자
2 | 알림2 |  관리자
3 | 알림3 |  관리자


7. 여러 테이블의 동시 INSERT
DROP TABLE notice4_1;
CREATE TABLE notice4_1(
  noticeno NUMBER(7)     NOT NULL,
  title       VARCHAR(100) NOT NULL,
  rname    VARCHAR(15)  NOT NULL,
  PRIMARY KEY(noticeno)
);

DROP TABLE notice4_2;
CREATE TABLE notice4_2(
  noticeno NUMBER(7)     NOT NULL,
  title       VARCHAR(100) NOT NULL,
  rname    VARCHAR(15)  NOT NULL,
  PRIMARY KEY(noticeno)
);

INSERT ALL
  INTO notice4_1(noticeno, title, rname)
  INTO notice4_2(noticeno, title, rname)
SELECT noticeno, title, rname
FROM notice;

SELECT noticeno, title, rname
FROM notice4_1
ORDER BY noticeno ASC;

NOTICENO | TITLE | RNAME
-------- | ----- | -----
1 | 알림1 |  관리자
2 | 알림2 |  관리자
3 | 알림3 |  관리자

SELECT noticeno, title, rname
FROM notice4_2
ORDER BY noticeno ASC;

NOTICENO | TITLE | RNAME
-------- | ----- | -----
1 | 알림1 |  관리자
2 | 알림2 |  관리자
3 | 알림3 |  관리자



-------------------------------------------------------------------------------------



[02] 제약 조건의 조회, 추가, 삭제

▷ /WEB-INF/doc/dbms/constraint_c.sql
-------------------------------------------------------------------------------------
1) 테이블 구조 생성
-- parent table
DROP TABLE employee;

CREATE TABLE employee(
  employeeno NUMBER(7) NOT NULL PRIMARY KEY,
  name VARCHAR(30) NOT NULL
);

INSERT INTO employee(employeeno, name)
VALUES((SELECT NVL(MAX(employeeno), 0)+1 as employeeno FROM employee), '아로미');

INSERT INTO employee(employeeno, name)
VALUES((SELECT NVL(MAX(employeeno), 0)+1 as employeeno FROM employee), '왕눈이');

SELECT employeeno, name FROM employee;

EMPLOYEENO | NAME
----------  | ----
1 | 아로미
2 | 왕눈이

-- child table
CREATE TABLE sungjuk(
  sungjukno NUMBER(7) NOT NULL PRIMARY KEY,
  subject     VARCHAR(30) NOT NULL,
  score       NUMBER(7) DEFAULT 0,
  employeeno NUMBER(7) NOT NULL,
  FOREIGN KEY (employeeno) REFERENCES employee (employeeno)
);

INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JAVA', 90, 1);
INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JSP', 75, 1);
INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JAVA', 80, 2);
INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JSP', 65, 2);

SELECT employeeno, sungjukno, subject, score
FROM sungjuk
ORDER BY employeeno, subject;

EMPLOYEENO | SUNGJUKNO | SUBJECT | SCORE
---------- | --------- | -------|  -----
1 |        1 | JAVA  |      90
1 |         2 | JSP   |       75
2 |         3 | JAVA |      80
2 |        4 | JSP    |    65


2) 제약조건 조회(대소문자 주의)
- CONSTRAINT_TYPE: P: Primary Key, F: Foreign Key, C: Not NULL
SELECT * FROM  ALL_CONSTRAINTS
WHERE  TABLE_NAME = 'SUNGJUK';

 OWNER CONSTRAINT_NAME CONSTRAINT_TYPE TABLE_NAME SEARCH_CONDITION         R_OWNER R_CONSTRAINT_NAME DELETE_RULE STATUS  DEFERRABLE     DEFERRED  VALIDATED GENERATED      BAD  RELY LAST_CHANGE           INDEX_OWNER INDEX_NAME  INVALID VIEW_RELATED
 ----- --------------- --------------- ---------- ------------------------ ------- ----------------- ----------- ------- -------------- --------- --------- -------------- ---- ---- --------------------- ----------- ----------- ------- ------------
 KOR1  SYS_C007193     R               SUNGJUK    NULL                     KOR1    SYS_C007188       NO ACTION   ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:19:11.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007189     C               SUNGJUK    "SUNGJUKNO" IS NOT NULL  NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:19:11.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007190     C               SUNGJUK    "SUBJECT" IS NOT NULL    NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:19:11.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007191     C               SUNGJUK    "EMPLOYEENO" IS NOT NULL NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:19:11.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007192     P               SUNGJUK    NULL                     NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:19:11.0 NULL        SYS_C007192 NULL    NULL


3) 제약 조건이 선언되지 않은 테이블
-- parent table
DROP TABLE sungjuk;
DROP TABLE employee;

CREATE TABLE employee(
  employeeno NUMBER(7) NOT NULL,
  name VARCHAR(30) NOT NULL
);

-- child table
DROP TABLE sungjuk;

CREATE TABLE sungjuk(
  sungjukno NUMBER(7) NOT NULL,
  subject     VARCHAR(30) NOT NULL,
  score       NUMBER(7) DEFAULT 0,
  employeeno NUMBER(7) NOT NULL
);


4) PK 제약조건 추가
ALTER TABLE employee ADD PRIMARY KEY (employeeno);

-- 제약조건 조회(대소문자 주의)
SELECT * FROM ALL_CONSTRAINTS
WHERE  TABLE_NAME = 'EMPLOYEE';

 OWNER CONSTRAINT_NAME CONSTRAINT_TYPE TABLE_NAME SEARCH_CONDITION         R_OWNER R_CONSTRAINT_NAME DELETE_RULE STATUS  DEFERRABLE     DEFERRED  VALIDATED GENERATED      BAD  RELY LAST_CHANGE           INDEX_OWNER INDEX_NAME  INVALID VIEW_RELATED
 ----- --------------- --------------- ---------- ------------------------ ------- ----------------- ----------- ------- -------------- --------- --------- -------------- ---- ---- --------------------- ----------- ----------- ------- ------------
 KOR1  SYS_C007201     C               EMPLOYEE   "EMPLOYEENO" IS NOT NULL NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:38:56.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007202     C               EMPLOYEE   "NAME" IS NOT NULL       NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:38:56.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007203     P               EMPLOYEE   NULL                     NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:39:58.0 NULL        SYS_C007203 NULL    NULL

-- 테이블의 PK 제약조건 삭제
ALTER TABLE employee DROP PRIMARY KEY;

-- 제약조건 조회(대소문자 주의)
SELECT * FROM ALL_CONSTRAINTS
WHERE  TABLE_NAME = 'EMPLOYEE';

OWNER                          CONSTRAINT_NAME                C TABLE_NAME                     SEARCH_CONDITION                                                                 R_OWNER                        R_CONSTRAINT_NAME              DELETE_RU STATUS   DEFERRABLE     DEFERRED  VALIDATED     GENERATED      BAD RELY LAST_CHANGE INDEX_OWNER                    INDEX_NAME                     INVALID VIEW_RELATED
------------------------------ ------------------------------ - ------------------------------ -------------------------------------------------------------------------------- ------------------------------ ------------------------------ --------- -------- -------------- --------- ------------- -------------- --- ---- ----------- ------------------------------ ------------------------------ ------- --------------
KOR1                           SYS_C007276                    C EMPLOYEE                       "EMPLOYEENO" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28
KOR1                           SYS_C007277                    C EMPLOYEE                       "NAME" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28


5) PK 제약조건 추가(제약조건명 지정), 제약 조건 이름을 확인하고 처리하기가 쉬움.
ALTER TABLE employee ADD CONSTRAINT employee_pk PRIMARY KEY (employeeno);

-- 제약조건 조회(대소문자 주의)
SELECT * FROM ALL_CONSTRAINTS
WHERE TABLE_NAME = 'EMPLOYEE';

 OWNER CONSTRAINT_NAME CONSTRAINT_TYPE TABLE_NAME SEARCH_CONDITION         R_OWNER R_CONSTRAINT_NAME DELETE_RULE STATUS  DEFERRABLE     DEFERRED  VALIDATED GENERATED      BAD  RELY LAST_CHANGE           INDEX_OWNER INDEX_NAME  INVALID VIEW_RELATED
 ----- --------------- --------------- ---------- ------------------------ ------- ----------------- ----------- ------- -------------- --------- --------- -------------- ---- ---- --------------------- ----------- ----------- ------- ------------
 KOR1  SYS_C007201     C               EMPLOYEE   "EMPLOYEENO" IS NOT NULL NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:38:56.0 NULL        NULL        NULL    NULL
 KOR1  SYS_C007202     C               EMPLOYEE   "NAME" IS NOT NULL       NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED GENERATED NAME NULL NULL 2018-02-28 12:38:56.0 NULL        NULL        NULL    NULL
 KOR1  EMPLOYEE_PK     P               EMPLOYEE   NULL                     NULL    NULL              NULL        ENABLED NOT DEFERRABLE IMMEDIATE VALIDATED USER NAME      NULL NULL 2018-02-28 12:42:22.0 NULL        EMPLOYEE_PK NULL    NULL


6) FK 제약조건 추가
ALTER TABLE sungjuk ADD CONSTRAINT sungjuk_fk FOREIGN KEY(employeeno)
REFERENCES employee(employeeno);

-- 제약조건 조회(대소문자 주의)
SELECT * FROM ALL_CONSTRAINTS
WHERE TABLE_NAME = 'SUNGJUK';

OWNER                          CONSTRAINT_NAME                C TABLE_NAME                     SEARCH_CONDITION                                                                 R_OWNER                        R_CONSTRAINT_NAME              DELETE_RU STATUS   DEFERRABLE     DEFERRED  VALIDATED     GENERATED      BAD RELY LAST_CHANGE INDEX_OWNER                    INDEX_NAME                     INVALID VIEW_RELATED
------------------------------ ------------------------------ - ------------------------------ -------------------------------------------------------------------------------- ------------------------------ ------------------------------ --------- -------- -------------- --------- ------------- -------------- --- ---- ----------- ------------------------------ ------------------------------ ------- --------------
KOR1                           SUNGJUK_FK                     R SUNGJUK                         KOR1                           EMPLOYEE_PK                    NO ACTION ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     USER NAME               18/02/28
KOR1                           SYS_C007278                    C SUNGJUK                        "SUNGJUKNO" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28
KOR1                           SYS_C007279                    C SUNGJUK                        "SUBJECT" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28
KOR1                           SYS_C007280                    C SUNGJUK                        "EMPLOYEENO" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28


7) 제약조건 삭제
ALTER TABLE sungjuk DROP CONSTRAINT sungjuk_fk;

-- 제약조건 조회(대소문자 주의)
SELECT * FROM ALL_CONSTRAINTS
WHERE TABLE_NAME = 'SUNGJUK';

OWNER                          CONSTRAINT_NAME                C TABLE_NAME                     SEARCH_CONDITION                                                                 R_OWNER                        R_CONSTRAINT_NAME              DELETE_RU STATUS   DEFERRABLE     DEFERRED  VALIDATED     GENERATED      BAD RELY LAST_CHANGE INDEX_OWNER                    INDEX_NAME                     INVALID VIEW_RELATED
------------------------------ ------------------------------ - ------------------------------ -------------------------------------------------------------------------------- ------------------------------ ------------------------------ --------- -------- -------------- --------- ------------- -------------- --- ---- ----------- ------------------------------ ------------------------------ ------- --------------
KOR1                           SYS_C007278                    C SUNGJUK                        "SUNGJUKNO" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28
KOR1                           SYS_C007279                    C SUNGJUK                        "SUBJECT" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28
KOR1                           SYS_C007280                    C SUNGJUK                        "EMPLOYEENO" IS NOT NULL                                                                         ENABLED  NOT DEFERRABLE IMMEDIATE VALIDATED     GENERATED NAME          18/02/28


8) ON DELETE CASCADE 옵션
-- parent table
DROP TABLE sungjuk;
DROP TABLE employee;

CREATE TABLE employee(
  employeeno NUMBER(7) NOT NULL CONSTRAINT employeeno_pk PRIMARY KEY,
  name VARCHAR(30) NOT NULL
);

INSERT INTO employee(employeeno, name)
VALUES((SELECT NVL(MAX(employeeno), 0)+1 as employeeno FROM employee), '아로미');

INSERT INTO employee(employeeno, name)
VALUES((SELECT NVL(MAX(employeeno), 0)+1 as employeeno FROM employee), '왕눈이');

SELECT employeeno, name FROM employee;

EMPLOYEENO | NAME
----------  | ----
1 | 아로미
2 | 왕눈이

-- child table
DROP TABLE sungjuk;
CREATE TABLE sungjuk(
  sungjukno NUMBER(7) NOT NULL PRIMARY KEY,
  subject     VARCHAR(30) NOT NULL,
  score       NUMBER(7) DEFAULT 0,
  employeeno NUMBER(7) NOT NULL,
  CONSTRAINT employeeno_fk FOREIGN KEY (employeeno) REFERENCES employee (employeeno) ON DELETE CASCADE
);

INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JAVA', 90, 1);
INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JSP', 75, 1);
INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JAVA', 80, 2);
INSERT INTO sungjuk(sungjukno, subject, score, employeeno)
VALUES((SELECT NVL(MAX(sungjukno), 0)+1 as sungjukno FROM sungjuk),
            'JSP', 65, 2);

-- sungjuk 테이블의 FK는 'employeeno' 컬럼임.
SELECT employeeno, sungjukno, subject, score
FROM sungjuk
ORDER BY employeeno, subject;

EMPLOYEENO | SUNGJUKNO | SUBJECT  | SCORE
---------- | --------- | ------- | -----
1  |       1  | JAVA     |  90
1  |       2  | JSP       |  75
2   |      3  | JAVA     |  80
2   |      4  | JSP        |  65


DELETE FROM employee WHERE employeeno=2;

SELECT employeeno, name FROM employee;

------------

EMPLOYEENO | NAME
---  | -----
1      | 아로미




SELECT employeeno, sungjukno, subject, score
FROM sungjuk
ORDER BY employeeno, subject;

EMPLOYEENO | SUNGJUKNO | SUBJECT  | SCORE
---------- | ---------- | -------- | --------
1         |  1                   | JAVA       | 90
1          | 2                    | JSP        | 75



9) UNIQUE 제약조건 추가
ALTER TABLE 테이블명 ADD UNIQUE (컬럼명);

ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 UNIQUE (칼럼명);



-------------------------------------------------------------------------------------
