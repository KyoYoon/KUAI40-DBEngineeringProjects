▷ procedure_exam.sql
-------------------------------------------------------------------------------------
 
1. sungjuk 테이블에서 총점과 평균을 계산하면서 레코드를 1000개 추가하는
      프로시저를 작성하세요.
 
-- SQL Editor에서 작업
 
DROP TABLE sungjuk PURGE;
 
CREATE TABLE sungjuk(
    no number(5) not null,
    kuk number(3) not null,
    eng number(3) not null,
    tot number(3) not null,
    avg number(5,2) not null
);
  
-- Procedure Editor에서 작업
 
CREATE OR REPLACE PROCEDURE sungjuk_ins1000
IS
    v_i   number(5) DEFAULT 0;
    v_no  sungjuk.no%TYPE;  -- sungjuk테이블의 no컬럼의 타입을 가져다 사용, 프로시저에서 사용하는 내부 지역변수
    v_kuk sungjuk.kuk%TYPE; 
    v_eng sungjuk.eng%TYPE;
    v_tot number(3); 
    v_avg number(5,2); -- -999.99 ~ +999.99
BEGIN
    FOR v_i IN 1..1000 LOOP
        v_no  := v_i;  -- v_i변수의 값을 v_no에 할당합니다.
        v_kuk := 100;
        v_eng := 93;
        v_tot := v_kuk + v_eng;
        v_avg := v_tot / 2.0;
        INSERT INTO sungjuk(no, kuk, eng, tot, avg)
        VALUES(v_no, v_kuk, v_eng, v_tot, v_avg);
    END LOOP;
 
    COMMIT WORK;  -- transaction commit
END sungjuk_ins1000;
/
  
  
2. 실행
 
-- SQL Editor에 작업
begin
  sungjuk_ins1000;
end;
/
 
SELECT count(*) FROM sungjuk;
 
SELECT * FROM sungjuk WHERE no <= 10;
 
exec sungjuk_ins1000; -- SQLExplorer은 안됨
  
   
    
[02] IN 매개변수
   - 프로시져로 파라미터를 전달 할 수 있습니다.
 
 
1. INSERT의 구현
 
-- SQL Editor에서 작업
 
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
    
DROP SEQUENCE emp_seq;
 
CREATE SEQUENCE emp_seq
start with 1    -- 일련 번호 시작 값
increment by 1  -- 증가 값
cache 2;   
   
   
INSERT INTO emp(empno, ename, deptno) VALUES(emp_seq.NextVal, '홍길동', 10);
INSERT INTO emp(empno, ename, deptno) VALUES(emp_seq.NextVal, '가길동', 20);
INSERT INTO emp(empno, ename, deptno) VALUES(emp_seq.NextVal, '나길동', 30);
INSERT INTO emp(empno, ename, deptno) VALUES(emp_seq.NextVal, '홍길순', 40);
 
COMMIT;
 
SELECT * FROM emp;
 
    
--Procedure Editor에서 작업합니다.
 
CREATE OR REPLACE PROCEDURE ins_emp(
    i_emp_name IN emp.ename%TYPE, -- 프로시저 호출시 이용할 가인수
    i_emp_job  IN emp.job%TYPE,   -- 테이블명.컬럼명%TYPE
    i_emp_mgr  IN emp.mgr%TYPE,
    i_emp_sal  IN emp.sal%TYPE
)
IS
    v_emp_comm emp.comm%TYPE; --프로시저에서 사용하는 지역변수
BEGIN
    IF i_emp_job ='SALESMAN' THEN -- 영업부 직원이면
        v_emp_comm :=0.03;   -- 3 % 수당 지급
    ELSE
        v_emp_comm :=0.01;   -- 1 % 수당 지급
    END IF;
 
    INSERT INTO emp(empno, ename, job, mgr, hiredate, sal, comm)
    VALUES(emp_seq.NextVal, i_emp_name, i_emp_job, i_emp_mgr, sysdate, i_emp_sal, v_emp_comm);
 
    COMMIT WORK;
END ins_emp;
/
 
 
--SQL Editor에서 작업합니다.
begin
  ins_emp('가길동', 'SALESMAN',1,1500000);
  ins_emp('나길동', 'developer',1,2000000);
end;
/
 
-- 대소문자 구분합니다. SQL Explorer는 안됨
exec ins_emp('다길동', 'salesman',1,1800000);
 
 
SELECT * FROM emp;
 
 
2. stu 테이블에서 총점, 평균을 구하고 INSERT 쿼리를 실행하는 
   프로시저를 작성하세요.
 
-- SQL Editor에서 작업
  
CREATE TABLE stu(
    stuno   NUMBER(5)    NOT NULL,
    name VARCHAR2(10) NOT NULL,
    kuk  NUMBER(3)    NOT NULL,
    eng  NUMBER(3)    NOT NULL,
    tot  NUMBER(3)    NOT NULL,
    avg  NUMBER(5,2)  NOT NULL,
    CONSTRAINT stu_no_pk PRIMARY KEY(stuno)  --중복된 값이 올수 없음, 반드시 값을 입력
);
 
 
CREATE SEQUENCE stu_seq
START WITH 1    -- 일련 번호 시작 값
INCREMENT BY 1  -- 증가 값
CACHE 2;   
 
  
--Procedure Editor에서 작업합니다.
 
CREATE OR REPLACE PROCEDURE stu_ins(
    i_name     IN stu.name%TYPE, -- 가인수
    i_kuk      IN stu.kuk%TYPE,  
    i_eng      IN stu.eng%TYPE
)
IS
    v_tot stu.tot%TYPE; --프로시저에서 사용하는 내부 지역변수
    v_avg stu.avg%TYPE;
BEGIN
    v_tot := i_kuk + i_eng; -- 총점 계산
    v_avg := v_tot/2.0;     -- 평균 계산 
 
    INSERT INTO stu(stuno, name, kuk, eng, tot, avg)
    VALUES(stu_seq.NextVal, i_name, i_kuk, i_eng, v_tot, v_avg);
    
    COMMIT WORK;  
END stu_ins;
/
 
  
--SQL Editor에서 작업합니다.
begin
  stu_ins('가길동', 100, 93);
  stu_ins('나길동', 90, 85);
  stu_ins('다길동', 100, 90);
end;
/
 
SELECT * FROM stu;
 
 
--Procedure Editor에서 작업합니다.
 
CREATE OR REPLACE PROCEDURE stu_ins2(
    i_name     IN stu.name%TYPE, -- 가인수
    i_kuk      IN stu.kuk%TYPE,  
    i_eng      IN stu.eng%TYPE
)
IS
    v_tot stu.tot%TYPE; --프로시저에서 사용하는 내부 지역변수
    v_avg stu.avg%TYPE;
BEGIN
    v_tot := i_kuk + i_eng; -- 총점 계산
    v_avg := v_tot/2.0;     -- 평균 계산 
 
    INSERT INTO stu(stuno, name, kuk, eng, tot, avg)
    VALUES((SELECT NVL(MAX(stuno), 0) + 1 FROM stu),
     i_name, i_kuk, i_eng, v_tot, v_avg);
    
    COMMIT WORK;  
END stu_ins2;
/
  
 
--SQL Editor에서 작업합니다.
begin
  stu_ins2('가길동', 100, 93);
  stu_ins2('나길동', 90, 85);
  stu_ins2('다길동', 100, 90);
end;
/
 
SELECT * FROM stu;
  
   
    
[03] OUT 매개변수
   - 프로시져로부터 값을 가져올 수 있습니다.
 
1. 컬럼값을 출력하는 프로시져
 
--Procedure Editor에서 작업합니다.
 
CREATE OR REPLACE PROCEDURE query_emp (
    i_emp_no    IN  emp.empno%TYPE, -- IN 값 입력
    o_emp_name  OUT emp.ename%TYPE, -- OUT 값 출력
    o_emp_sal   OUT emp.sal%TYPE,   -- OUT 값 출력
    o_emp_comm  OUT emp.comm%TYPE   -- OUT 값 출력
)
IS
BEGIN
    SELECT ename, sal, comm
    INTO o_emp_name, o_emp_sal, o_emp_comm -- output 매개변수 목록 ★
    FROM emp
    WHERE empno = i_emp_no;  -- IN 매개 변수의 값과 비교
END query_emp;
/
 
 
-- SQL Editor에서 작업합니다.
 
SELECT * FROM emp;
 
DECLARE
    emp_name varchar2(10) := null;
    emp_sal number := 0;
    emp_comm number := 0;
BEGIN
   query_emp(6, emp_name, emp_sal, emp_comm);
   DBMS_OUTPUT.PUT_LINE(emp_name);
   DBMS_OUTPUT.PUT_LINE(emp_sal);
   DBMS_OUTPUT.PUT_LINE(emp_comm);
END;
/
 
 
2. IN/OUT 매개변수
 
--Procedure Editor에서 작업합니다.
 
CREATE OR REPLACE PROCEDURE add_one(
    io_phone_no       IN OUT VARCHAR2
)
IS
BEGIN
    io_phone_no := SUBSTR(io_phone_no, 1, 3) || '-' || SUBSTR(io_phone_no, 4, length(io_phone_no));
END add_one;
/
 
 
-- SQL Editor에서 작업합니다.
 
DECLARE
    phone_num VARCHAR2(15) := '12312341234';
BEGIN
   add_one(phone_num);
   DBMS_OUTPUT.PUT_LINE(phone_num);
END;
/
 
  
   
[04] 쿼리 실행 정보를 저장하는 프로시저
 
1. 로그인 정보를 저장하는 프로시저
 
--SQL Editor에서 실행하세요.
 
DROP TABLE log2 PURGE;
 
CREATE TABLE log2(
    num       NUMBER(5) NOT NULL,  -- 일련번호
    userid    VARCHAR2(20),        -- oracle user ID
    log_date  DATE,                -- 쿼리 실행일
    query     VARCHAR2(1000),      -- 실행 쿼리 내용   
    CONSTRAINT log2_num_pk PRIMARY KEY(num)  --중복된 값이 올수 없음, 반드시 값을 입력
);
 
 
CREATE SEQUENCE log2_seq
start with 1    -- 일련 번호 시작 값
increment by 1  -- 증가 값
cache 2;  
 
 
--Procedure Editor에서 실행하세요.
 
CREATE OR REPLACE PROCEDURE log_execution2(
    i_query  IN log2.query%TYPE -- 쿼리를 전달 받습니다.
)
IS
BEGIN
    INSERT INTO log2(num, userid, log_date, query)
    VALUES(log2_seq.NextVal, user, sysdate, i_query);
 
    COMMIT;
END log_execution2;
/
 
 
--SQL Editor에서 실행하세요.
 
SELECT user, sysdate FROM dual;
 
 
begin
  log_execution2('DELETE FROM sungjuk WHERE stuno=1');
end;
/
 
 
SELECT userid, TO_CHAR(log_date, 'YYYYMMDD HH:MI:SS'), query FROM log2;
 
 
-- 프로시져 삭제
DROP PROCEDURE log_execution2;
     
 
-------------------------------------------------------------------------------------