# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## VIEW
- View는 원본 테이블을 필터링하여 원하는 컬럼만 출력하는 역활을 합니다.

- 테이블 구조 전체를 공개하지 않아도 됨으로 보안성이 향상됩니다.

- 쿼리 전송을 최소화하여 네트워크 트래픽을 감소합니다.

- DB서버에 미리 쿼리를 등록하여 둠으로 App Server에서 전송된 쿼리보다
  빠르게 결과를 만들어 낼 수 있습니다.

- 일반적으로 View의 대상은 모든 JOIN과 Subquery가 대상이며, View를
  생성하면 App 개발자가 훨신 적은 수고를 들이고 프로그램을 개발할 수
  있습니다.

- 개발이 끝나고 테이블의 구조가 변경이 되더라도 View 계층에서 완충역활을 해
  App에 미치는 영향을 최소화 할 수 있습니다.

- View는 테이블과 같은 규칙을 적용받으며 같은 기능을 가지고 있으나
  INSERT, DELETE, UPDATE 관련 쿼리는 실행시 예측 할 수 없는 결과가 발생함으로
  사용되지 않고 SELECT 쿼리만 대상이 됩니다.

- 참고파일: view.sql

---

1. 기본적인 View의 생성

1) 테이블 구조
DROP TABLE test PURGE;

CREATE TABLE test(
    testno NUMBER(5)   NOT NULL, -- 일련번호
    name   VARCHAR(30) NOT NULL, -- 성명
    mat    NUMBER(3)   NOT NULL, -- 수학
    eng    NUMBER(3)   NOT NULL, -- 영어
    tot    NUMBER(3)       NULL, -- 총점
    avg    NUMBER(4, 1)    NULL, -- 평균
    PRIMARY KEY (testno)
);

DELETE FROM test;



2) 기초 데이터 추가

INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),
    '피어스 브러스넌', 80, 100
);

INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),
    '메릴스트립', 80, 100
);

INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),
    '사이프리드', 85, 80
);

INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),
    '콜린퍼스', 65, 60
);

INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),
    '스텔란 스카스가드', 75, 70
);


UPDATE test SET tot = mat+eng;

UPDATE test SET avg = tot/2;

SELECT * FROM test;

3) VIEW의 생성
-- 우수생 목록
DROP VIEW vtest_90;

CREATE VIEW vtest_90
AS
SELECT testno, name, mat, eng, tot, avg
FROM test
WHERE avg >= 90;

SELECT * FROM tab;

SELECT testno, name, mat, eng, tot, avg FROM vtest_90;


2. 일부 컬럼만 View의 대상으로 지정

DROP VIEW vtest_80;

CREATE VIEW vtest_80
AS
SELECT testno, name, tot, avg
FROM test
WHERE avg >= 80;


SELECT testno, name, tot, avg FROM vtest_80;

-- ERROR, View에 없는 컬럼 접근 못함.
SELECT testno, name, mat, eng, tot, avg FROM vtest_80;


3. ()안의 컬럼은 생성되는 View의 컬럼의 별명입니다.
- 실제 컬럼명이 감추어짐.
CREATE OR REPLACE VIEW vtest_70(
    hakbun, student_name, total, average
)
AS
SELECT testno, name, tot, avg
FROM test
WHERE avg >= 70;

SELECT * FROM vtest_70;


4. 함수를 이용한 View의 생성
CREATE OR REPLACE VIEW vtest_func(
    max_total, min_total, avg_total
)
AS
SELECT MAX(tot), MIN(tot), AVG(tot)
FROM test;


SELECT * FROM vtest_func;


5. WITH CHECK OPTION
   - WHERE문에 명시한 컬럼의 값을 변경 할 수 없습니다.

1) 실습용 테이블
DROP TABLE employee;

CREATE TABLE employee(
    name          varchar(10) not null,
    salary        number(7)   not null,
    department_id number(4)   not null
);

INSERT INTO employee(name, salary,department_id)
VALUES('aaa', 1000000, 20);
INSERT INTO employee(name, salary,department_id)
VALUES('bbb', 1100000, 20);
INSERT INTO employee(name, salary,department_id)
VALUES('ccc', 1200000, 20);


SELECT * FROM employee;

COMMIT;

2) WITH CHECK OPTION 사용하지 않은 경우
CREATE VIEW vemp20
AS
SELECT *
FROM employee
WHERE department_id=20;

SELECT * FROM vemp20;

-- vemp20은 20번 부서만 작업 대상으로 하나
-- WHERE문에 나타난 부서를 30번으로 변경함으로 논리적 에러가
-- 발생합니다.
-- View를 이용한 UPDATE는 권장이 아닙니다.
UPDATE vemp20 SET department_id=30;

-- 부서가 모두 30번으로 변경되어 결과가 없습니다.
SELECT * FROM vemp20;

SELECT * FROM employee;

ROLLBACK;



3) WITH CHECK OPTION을 사용한 경우
CREATE VIEW vemp_c20
AS
SELECT *
FROM employee
WHERE department_id=20
WITH CHECK OPTION CONSTRAINT vemp_c20_ck;

SELECT * FROM vemp_c20;

-- UPDATE가 금지되어 실행이 안됩니다. UPDATE를 실행하고자 할 경우는
-- 실제의 테이블을 대상으로 합니다.
-- SQL 오류: ORA-01402: view WITH CHECK OPTION where-clause violation
-- 01402. 00000 -  "view WITH CHECK OPTION where-clause violation"
UPDATE vemp_c20 SET department_id=30;

UPDATE vemp_c20 SET salary = 2000000 WHERE name = 'ccc';

SELECT * FROM vemp_c20;

SELECT * FROM employee;

ROLLBACK;


6. WITH READ ONLY 옵션
  - View에서 UPDATE, INSERT, DELETE 기능을 금지시킵니다.

CREATE VIEW test_read(
    num, name, total)
AS
SELECT testno, name, tot
FROM test
WHERE tot >= 60
WITH READ ONLY;


SELECT * FROM test_read;

INSERT INTO test_read(num,
    name, total)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),
    '줄리 월터스', 150
);

-- SQL 오류: ORA-42399: cannot perform a DML operation on a read-only view
-- 42399.0000 - "cannot perform a DML operation on a read-only view"
UPDATE test_read SET total = 200;


※ VIEW는 INSERT, UPDATE, DELETE에는 사용을 권장하지 않습니다.


7. FROM 절에 기록된 Subquery는 INLINE VIEW라고 해서
   SQL 내부에 포함된 임시 VIEW라고 부릅니다.
   - Top-n Analysis에서 많이 사용


1) 레코드 정렬

SELECT testno, name, mat, eng, tot, avg
FROM test
ORDER BY testno DESC;

2) rownum 산출
SELECT testno, name, mat, eng, tot, avg, rownum r
FROM(
    SELECT testno, name, mat, eng, tot, avg -- Inline View
    FROM test
    ORDER BY testno DESC
);

3) record 분할
SELECT testno, name, mat, eng, tot, avg, r
FROM(
    SELECT testno, name, mat, eng, tot, avg, rownum as r
    FROM(
        SELECT testno, name, mat, eng, tot, avg -- Inline View
        FROM test
        ORDER BY testno DESC
    )
)
WHERE r > =1 AND r <= 3;

SELECT testno, name, mat, eng, tot, avg, r
FROM(
    SELECT testno, name, mat, eng, tot, avg, rownum as r
    FROM(
        SELECT testno, name, mat, eng, tot, avg -- Inline View
        FROM test
        ORDER BY testno DESC
    )
)
WHERE r > =4 AND r <= 6;


4) 검색
SELECT testno, name, mat, eng, tot, avg, r
FROM(
    SELECT testno, name, mat, eng, tot, avg, rownum as r
    FROM(
        SELECT testno, name, mat, eng, tot, avg -- Inline View
        FROM test
        WHERE name LIKE '%메릴%'
        ORDER BY testno DESC
    )
)
WHERE r > =1 AND r <= 3;

5) Subquery의 View 생성

CREATE OR REPLACE VIEW test_list
AS
SELECT testno, name, mat, eng, tot, avg -- Inline View
FROM test
ORDER BY testno DESC;

6) Subquery의 View의 사용

SELECT testno, name, mat, eng, tot, avg, rownum r
FROM test_list;


SELECT testno, name, mat, eng, tot, avg, r
FROM (
    SELECT testno, name, mat, eng, tot, avg, rownum r
    FROM test_list
)
WHERE r > =1 AND r <= 3;


SELECT testno, name, mat, eng, tot, avg, r
FROM (
    SELECT testno, name, mat, eng, tot, avg, rownum r
    FROM test_list
)
WHERE r > = 4 AND r <= 6;

-- 검색
SELECT testno, name, mat, eng, tot, avg, r
FROM (
    SELECT testno, name, mat, eng, tot, avg, rownum r
    FROM test_list
    WHERE name LIKE '%메릴%'
)
WHERE r > = 1 AND r <= 3;


-------------------------------------------------------------------------------------
