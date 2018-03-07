# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## Trigger 실습 - 매출액 관리
 - UPDATE, INSERT, DELETE 쿼리가 시행될 때마다 부가적으로 다른 쿼리를
    실행 할 수 있는 기술입니다.

  - ROLLBACK할 수 없습니다.

  - 너무 복잡한 트리거의 사용은 DB의 속도를 저하시키는 단점이 있습니다.
  - 참고파일: trigger_exam.sql 

  -------------------------------------------------------------------------------------

  1. 트리거의 구성요소

     - 트리거 유형: Statement Level, Row Level

     - 트리거 타이밍
       . BEFORE: 쿼리가 실행되기 전에 실행하는 트리거
       . AFTER : 쿼리가 실행되고 난후 실행하는 트리거

     - 트리거 이벤트: INSERT, UPDATE, DELETE

     - 트리거 몸체: PL/SQL 블럭

     - 트리거 조건: WHEN 조건





  2. 문장 레벨의 트리거
  -- 전체 transaction 작업에 대해 1번발생되는 트리거로 default 입니다.
  -- emp 테이블에 대해서 insert, update, delete가 발생하면 아래의
  -- 트리거가 자동으로 작동되어 요일이 '토, 일'인 경우는 아래처럼
  -- 메시지를 출력합니다.

  ⓐ Procedure editor에서 작업합니다.
     emp 테이블에 INSERT, UPDATE, DELETE가 발생할 때마다 자동으로
     실행됩니다.

  CREATE or REPLACE TRIGGER t_test1
  BEFORE INSERT or UPDATE or DELETE ON emp
  BEGIN
  IF (TO_CHAR(sysdate, 'DY') IN ('토', '일')) or (TO_CHAR(sysdate, 'DY') IN ('SAT', 'SUN')) THEN
      DBMS_OUTPUT.PUT_LINE('주말에는 데이터를 변경할 수 없습니다.!!');
  ELSE
      DBMS_OUTPUT.PUT_LINE('월요일 ~ 금요일에는 데이터를 변경할 수 있습니다.!!');
  END IF;
  END;
  /





  ⓑ 오라클 서버의 날짜를 토요일이나 일요일로 변경해 테스트합니다.

  INSERT INTO emp(empno, ename, deptno)
  VALUES(emp_seq.NextVal, '브래드피트', 10);

  SELECT * FROM emp;


  UPDATE emp SET sal = sal * 1.1;

  SELECT * FROM emp;


  DELETE FROM emp WHERE empno = 1;

  SELECT * FROM emp;






  [02] Trigger 실습 - 날짜별 매출액 관리

  1. 테이블 구조

  -- 사용자 정의어는 대소문자를 가립니다.(테이블명 주의)
  -- 예매 정보 테이블
  DROP TABLE advance_sale PURGE;

  CREATE TABLE advance_sale(
    NUM     NUMBER              NOT NULL,   -- 일련번호
    SDATE   VARCHAR2(30 BYTE)   NOT NULL,   -- 예매 날짜
    QTY     NUMBER              NOT NULL,   -- 수량
    AMOUNT  NUMBER              NOT NULL    -- 금액
  );

  SELECT * FROM advance_sale;
  DELETE FROM advance_sale;
  COMMIT;




  -- 총 매출액 테이블
  DROP TABLE sales PURGE;

  CREATE TABLE sales(
    SDATE      VARCHAR2(30 BYTE) NOT NULL, -- 날짜
    DAYAMOUNT  NUMBER            NOT NULL, -- 일단위 총 금액
    DAYQTY     NUMBER            NOT NULL  -- 일단위 총 수량
  )

  SELECT sdate, dayamount, dayqty FROM sales;





  2. 트리거

     - AFTER INSERT OR UPDATE OR DELETE ON advance_sale
       advance_sale 테이블에 INSERT, UPDATE, DELETE가 발생되고 난후
       자동으로 실행되는 트리거
     - FOR EACH ROW: 행 트리거, 각 행에 대해서 트리거가 발생된다.
     - :new - 추가된 레코드를 저장하고 있는 객체
     - :old - 삭제된 레코드를 저장하고 있는 객체



  CREATE OR REPLACE TRIGGER t_sales
  AFTER INSERT OR UPDATE OR DELETE ON advance_sale
  FOR EACH ROW       -- 각각의 행에 대해서 작동
  DECLARE
      v_cnt NUMBER;  -- 지역 변수 선언
  BEGIN
      -- 기존에 등록된 레코드의 날짜와 새로 추가되는 컬럼의 날짜를 비교하여
      -- 날짜가 같은 레코드의 수를 리턴합니다.
      SELECT count(*) INTO v_cnt
      FROM sales
      WHERE sdate = :new.sdate;


      IF INSERTING THEN -- advance_sale 테이블에 레코드 추가일경우
          IF v_cnt > 0 THEN
              -- 기존에 같은 날짜에 등록된 레코드가 있다면 금액, 수량 누적
              -- 금액 = 기존 금액 + 새로운 금액
              -- 수량 = 기존 수량 + 새로운 수량
              UPDATE sales
              SET dayamount = dayamount + :new.amount
                , dayqty = dayqty + :new.qty
              WHERE sdate = :new.sdate; -- 날짜가 같은 레코드

          ELSE -- 기존에 등록된 날짜가 없다면 새로 레코드 추가
              INSERT INTO sales(sdate, dayamount, dayqty)
              VALUES(:new.sdate, :new.amount, :new.qty);
          END IF;
      ELSIF DELETING THEN  -- 레코드 삭제일 경우, 금액, 수량 삭제
          -- :old: 삭제된 레코드를 가지고 있는 객체
          -- 같은 날짜에 한해서 금액 및 수량을 감산 합니다.
          UPDATE sales
          SET dayamount = dayamount - :old.amount
              , dayqty = dayqty - :old.qty
          WHERE sdate = :old.sdate;
      END IF;
  END;
  /





  DELETE FROM advance_sale;
  DELETE FROM sales;
  COMMIT;





  3. 새로운 날짜의 매출이 발생한 경우 INSERT Test

  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(1, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);

  SELECT * FROM advance_sale;

      NUM SDATE                       QTY     AMOUNT
  ------- -------------------- ---------- ----------
        1 2009-07-21                    1       5000



  -- 총 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales;

  SDATE                           DAYAMOUNT     DAYQTY
  ------------------------------ ---------- ----------
  2009-02-17                           5000          1





  4. 같은 날짜에 매출이 발생한 경우 UPDATE Test

  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(2, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);

  SELECT * FROM advance_sale;

      NUM SDATE                       QTY     AMOUNT
  ------- -------------------- ---------- ----------
        1 2009-02-17                    1       5000
        2 2009-02-17                    1       5000



  -- 총 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales;

  SDATE                           DAYAMOUNT     DAYQTY
  ------------------------------ ---------- ----------
  2009-02-17                          10000          2




  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(3, TO_CHAR(sysdate, 'yyyy-mm-dd'), 10, 50000);

  SELECT * FROM advance_sale;

      NUM SDATE                       QTY     AMOUNT
  ------- -------------------- ---------- ----------
        1 2009-02-17                    1       5000
        2 2009-02-17                    1       5000
        3 2009-02-17                   10      50000



  -- 총 매출액 테이블
  SELECT sdate, TO_CHAR(dayamount, '9,999,999'), dayqty FROM sales;

  SDATE                           DAYAMOUNT     DAYQTY
  ------------------------------ ---------- ----------
  2009-02-17                         60,000         12





  5. 날짜가 다른경우

  - Oracle Server의 시간 변경후 테스트를 하던지 또는 sysdate+1을 합니다.

  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(4, TO_CHAR(sysdate + 1, 'yyyy-mm-dd'), 3, 15000);

  SELECT * FROM advance_sale

      NUM SDATE                       QTY     AMOUNT
  ------- -------------------- ---------- ----------
        1 2009-02-17                    1       5000
        2 2009-02-17                    1       5000
        3 2009-02-17                   10      50000
        4 2009-02-18                    3      15000



  -- 총 매출액 테이블
  SELECT sdate, TO_CHAR(dayamount, '9,999,999'), dayqty FROM sales;

SDATE                         |   DAYAMOUNT    | DAYQTY
------------------ | ---------- | ----------
2009-02-17       |                  60,000     |    12
2009-02-18        |                 15,000      |    3





  6. 매출액이 취소되는 경우
     - Toad F5: 다중 쿼리 실행

     -- 실습을 위해서 전부 삭제
  DELETE FROM advance_sale;
  DELETE FROM sales;
  COMMIT;

  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(1, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);
  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(2, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);
  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(3, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);


  SELECT * FROM advance_sale;

NUM       | SDATE                     |  QTY     | AMOUNT
------- | ----------------- |  -----  |  ----------
1 |  2009-07-21                 |   1  |     5000
2 | 2009-07-21                  |  1    |   5000
3 | 2009-07-21                  |  1     |  5000



  -- 총 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales

SDATE                           | DAYAMOUNT   |   DAYQTY
------------------ | ---------- | ----------
2009-02-17 |                         15000   |       3




  --내역 테이블에서 1번 매출취소

  SELECT * FROM advance_sale;

  DELETE FROM advance_sale WHERE num=1;

  SELECT * FROM advance_sale;

NUM    | SDATE                       | QTY     | AMOUNT
-------  | ----------------  |  ----- |  ----------
2 | 2009-02-17    |                1     |  5000
3 | 2009-02-17     |               1     |   5000



  -- 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales;

SDATE                    | DAYAMOUNT     | DAYQTY
--------------- | ---------- | ----------
2009-02-17            |              10000    |      2





  7. 매출액이 수정되는 경우

  ⓐ 잘못된 매출액을 추가합니다.
  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(10, TO_CHAR(sysdate, 'yyyy-mm-dd'), 100, 500000);

  -- 매출 내역 테이블
  SELECT * FROM advance_sale;

  -- 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales;



  ⓑ 잘못된 매출액 삭제
  DELETE FROM advance_sale WHERE num=10;

  -- 매출 내역 테이블
  SELECT * FROM advance_sale;

  -- 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales;



  ⓒ 다시 새로운 데이터가 들어간 매출액을 추가합니다.
  INSERT INTO advance_sale(num, sdate, qty, amount)
  VALUES(10, TO_CHAR(sysdate, 'yyyy-mm-dd'), 20, 100000);

  -- 매출 내역 테이블
  SELECT * FROM advance_sale;


  -- 매출액 테이블
  SELECT sdate, dayamount, dayqty FROM sales;


  -------------------------------------------------------------------------------------
