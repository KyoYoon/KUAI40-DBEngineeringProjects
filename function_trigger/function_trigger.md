# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## Stored Function, Trigger
   - 처리결과를 리턴합니다.
   - 반복적으로 발생하는 컬럼 데이터 조작이 있는 경우 함수의 대상이 됩니다.
   - 다양한 쿼리(INSERT, DELETE, UPDATE, SELECT, GROUP BY...) 속에서 사용될 수 있습니다.
   - 프로시저는 여러값을 리턴하나 함수는 하나의 값만 리턴합니다.

   -------------------------------------------------------------------------------------
   1. 함수의 실습
   DROP TABLE emp PURGE;
    
   CREATE TABLE emp(
      empno    number(5)   not null,
      ename    varchar(20) null,
      job      varchar(10) null,
      mgr      number(5)   null,
      hiredate date        null,
      sal      number(10)  null,
      comm     number(3,2) null,
      deptno    number(5)  null,
      CONSTRAINT emp_empno_pk PRIMARY KEY(empno)  --중복된 값이 올수 없음, 반드시 값을 입력
   );

   -- Procedure editor에서 작업합니다.

   CREATE OR REPLACE FUNCTION f_tax(i_value IN NUMBER)
   RETURN NUMBER                -- 리턴 타입
   IS
   BEGIN
       return (i_value * 0.05); -- 세금 5 % 계산
   END f_tax;
   /


   SELECT ename as "성명", deptno as "번호", sal as "급여", f_tax(sal) as "세금 5% 산출 금액"
   FROM emp;


   2. emp.deptno 컬럼의 값이 10-전산부, 20-경리부, 30-영업부, 40-자재부
      - dept()

   CREATE OR REPLACE FUNCTION f_dept(i_deptno IN NUMBER)
       RETURN VARCHAR
       IS
           v_dept varchar(20) := null;
       BEGIN
           if i_deptno = 10 then
               v_dept := '전산부';
           end if;
           if i_deptno = 20 then
               v_dept := '경리부';
           end if;
           if i_deptno = 30 then
               v_dept := '영업부';
           end if;
           if i_deptno = 40 then
               v_dept := '자재부';
           end if;

           return v_dept;
       END f_dept;
   /


   -- ELSIF의 사용
   CREATE OR REPLACE FUNCTION f_dept(i_deptno IN NUMBER)
       RETURN VARCHAR
       IS
           v_dept varchar(20) := null;
       BEGIN
           if i_deptno = 10 then
               v_dept := '전산부';
           elsif i_deptno = 20 then
               v_dept := '경리부';
           elsif i_deptno = 30 then
               v_dept := '영업부';
           elsif i_deptno = 40 then
               v_dept :='자재부';
           else
               v_dept :='부서미지정';
           end if;

           return v_dept;
       END f_dept;
   /

   SELECT * FROM emp;

   SELECT ename as "성명", deptno as "번호"
          , f_dept(deptno) as "부서명"
   FROM emp;



   [02] Trigger

      - UPDATE, INSERT, DELETE 쿼리가 시행될 때마다 부가적으로 다른 쿼리를
        실행 할 수 있는 기술입니다.

      - ROLLBACK할 수 없습니다.

      - 너무 복잡한 트리거의 사용은 DB의 속도를 저하시키는 단점이 있습니다.


   1. 트리거의 구성요소

      - 트리거 유형: Statement Level, Row Level

      - 트리거 타이밍
        . BEFORE: 쿼리가 실행되기 전에 실행하는 트리거
        . AFTER : 쿼리가 실행되고 난후 실행하는 트리거

      - 트리거 이벤트: INSERT, UPDATE, DELETE

      - 트리거 몸체: PL/SQL 블럭

      - 트리거 조건: WHEN 조건


   2. 문장 레벨의 트리거
   -- 전체 transaction 작업에 대해 1번 발생되는 트리거로 default 입니다.
   -- emp 테이블에 대해서 insert, update, delete가 발생하면 아래의
   -- 트리거가 자동으로 작동되어 요일이 '토, 일'인 경우는 아래처럼
   -- 메시지를 출력합니다.

   ⓐ Procedure editor에서 작업합니다.
      emp 테이블에 INSERT, UPDATE, DELETE가 발생할 때마다 자동으로 실행됩니다.

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


   -------------------------------------------------------------------------------------
