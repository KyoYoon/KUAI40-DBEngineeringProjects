▷ transaction.sql
-------------------------------------------------------------------------------------
1. 견본 테이블 생성
   - SQL Explorer는 연결 옵션중에 'Auto commit'을 
     체크 해제합니다.
 
DROP TABLE pay PURGE;
 
CREATE TABLE pay(
    name varchar(10) NOT NULL,
    pay  number(7)   NOT NULL,
    tax  number(6)   DEFAULT 0
);
 
SELECT * FROM tab; -- 모든 테이블을 보여주는 명령
 
 
2. COMMIT(INSERT, UPDATE, DELETE 적용)
 
INSERT INTO pay(name,pay,tax) VALUES('왕눈이', 2000000, 100000);
 
-- 실제 DBMS에 적용
COMMIT;
 
SELECT * FROM pay;
 
 
3. ROLLBACK
 
DELETE FROM pay WHERE name='왕눈이';
 
SELECT * FROM pay;
 
-- 삭제된 레코드가 복구 됩니다., ROLLBACK
ROLLBACK WORK;  
 
SELECT * FROM pay;
 
 
 
4. 여러단계의 복구
 
DELETE FROM pay WHERE name='왕눈이';
 
SELECT * FROM pay;
 
 
-- 아로미 추가
INSERT INTO pay(name,pay,tax) VALUES('아로미', 2200000, 120000);
 
SELECT * FROM pay;
 
 
-- 아로미의 급여를 10% 인상합니다.
UPDATE pay SET pay=pay * 1.1 WHERE name='아로미';
 
SELECT * FROM pay;
 
 
-- 아로미의 세금을 11% 인상합니다.
UPDATE pay SET tax=tax * 0.11 WHERE name='아로미';
 
SELECT * FROM pay;
 
 
-- 최초 상태로 돌아갑니다.
ROLLBACK WORK;
 
SELECT * FROM pay;
 
 
 
5. SAVEPOINT
   - 특정 지점으로 ROLLBACK할 수 있는 기능을 제공합니다.
 
-- 원본 데이터 상태
SAVEPOINT first;
 
INSERT INTO pay(name,pay,tax) VALUES('아로미', 3000000, 300000);
 
SELECT * FROM pay;
 
 
UPDATE pay SET pay=3500000, tax=350000;
 
SELECT * FROM pay;
 
SAVEPOINT second;
 
 
INSERT INTO pay(name,pay,tax) VALUES('투투', 4000000, 400000);
 
SELECT * FROM pay;
 
-- SAVEPOINT second 지역으로 복구합니다.
ROLLBACK TO SAVEPOINT second;
 
SELECT * FROM pay;
 
 
ROLLBACK TO SAVEPOINT first;
 
SELECT * FROM pay;
 
 
6. READ Consistency(읽기 일관성)
   - iSQL+ 는 브러우저를 닫으면 COMMIT 됩니다.
   - SQL+는 창을 닫으면 ROLLBACK 됩니다.
   - SQL+는 exit명령을 내리면 COMMIT됩니다.
     따라서 로그아웃시에는 반드시 명시적으로 ROLLBACK, COMMIT명령 
     사용을 권장 합니다.
   - SQLExplorer는 'commit on close'를 선택하면
     프로그램 종료시 자동으로 'commit'됩니다.  
 
 
   USER 1 --- 임시 영역 ---+   +--- COMMIT  ----- Data Area
                                     +--+ 
   USER 2 --- 임시 영역 ---+   +--- ROLLBACK
 
 
--user1(SQL Explorer)
SELECT * FROM pay;
 
INSERT INTO pay(name, pay, tax) VALUES('아로미', 1700000, 50000);
 
SELECT * FROM pay;
 
--user2(SQL Explorer, SQL Plus), 변경된 데이터 아로미를 읽을 수 없습니다.
SELECT * FROM pay;
 
 
--user1(SQL Explorer)
COMMIT;
 
--user2(SQL Explorer, SQL Plus), COMMIT이 되었음으로 변경된 데이터를 읽을 수 있습니다.
SELECT * FROM pay;
 
 
 
    
[02] Sequecne
 
DROP TABLE emp;
 
CREATE TABLE emp(
    num           number(5)   not null,
    name          varchar(10) not null,
    salary        number(7)   not null,
    department_id number(4)   not null
);
 
CREATE SEQUENCE emp_seq
    INCREMENT BY 1      -- 증가 값
    START WITH   1      -- 1부터 시작
    MAXVALUE     99999  -- 최대값
    CACHE 20            -- 20단위로 시스템 테이블에 저장
    NOCYCLE;            -- 최대 99999까지가서 다시 순환하지 말것 
    
    
DROP SEQUENCE emp_seq;
 
 
INSERT INTO emp(num,name, salary,department_id)
VALUES(emp_seq.NextVal,'aaa', 1000000, 20);
INSERT INTO emp(num,name, salary,department_id)
VALUES(emp_seq.NextVal,'bbb', 1100000, 20);
INSERT INTO emp(num,name, salary,department_id)
VALUES(emp_seq.NextVal,'ccc', 1200000, 20);
 
SELECT * FROM emp;
 
 
COMMIT;
 
 
-- 생성된 Sequence 모두 출력
SELECT *
FROM user_sequences;
 
-- 다음 sequence값을 볼 수 있으나 계속적으로 값이 증가됩니다.
SELECT emp_seq.nextval as seq FROM dual;
 
-- 현재 sequence를 봅니다.
SELECT emp_seq.currval FROM dual;
 
 
 
[03] INDEX 생성
     - index 사용을 통하여 오라클의 검색 속도를 향상시킬 수 있습니다.
       도서의 목차를 미리 만들어 두는 것과 같은 원리입니다.
     
     - WHERE조건에 나오는 컬럼을 대상으로 합니다.
       PK컬럼은 자동으로 인덱스가 생성됩니다.
       하나의 index는 테이블 용량의 5%~20%까지도 점유할 수 있음으로
       과도한 인덱스 생성을 피해야합니다.
       index가 많아지면 Transaction시간이 길어집니다.
 
     - 생성된 index는 SQL실행시에 오라클서버로부터 자동으로
       사용됩니다.
 
       
1. index의 생성
       
CREATE INDEX emp_num_idx
ON emp(num);
 
 
2. index 목록의 출력
SELECT ic.index_name, ic.column_name,
       ic.column_position col_pos, ix.uniqueness
FROM user_indexes ix,user_ind_columns ic
WHERE ic.index_name = ix.index_name
AND ic.table_name = 'EMP';
 
 
3. 함수기반 인덱스 생성
CREATE INDEX emp_name_idx
ON emp(UPPER(name));
 
SELECT ic.index_name, ic.column_name,
       ic.column_position col_pos, ix.uniqueness
FROM user_indexes ix,user_ind_columns ic
WHERE ic.index_name = ix.index_name
AND ic.table_name = 'EMP';
 
 
4. INDEX의 삭제
    
DROP INDEX emp_num_idx;    
    
DROP INDEX emp_name_idx;
    
 
-------------------------------------------------------------------------------------