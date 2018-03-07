�� transaction.sql
-------------------------------------------------------------------------------------
1. �ߺ� ���̺� ����
   - SQL Explorer�� ���� �ɼ��߿� 'Auto commit'�� 
     üũ �����մϴ�.
 
DROP TABLE pay PURGE;
 
CREATE TABLE pay(
    name varchar(10) NOT NULL,
    pay  number(7)   NOT NULL,
    tax  number(6)   DEFAULT 0
);
 
SELECT * FROM tab; -- ��� ���̺��� �����ִ� ���
 
 
2. COMMIT(INSERT, UPDATE, DELETE ����)
 
INSERT INTO pay(name,pay,tax) VALUES('�մ���', 2000000, 100000);
 
-- ���� DBMS�� ����
COMMIT;
 
SELECT * FROM pay;
 
 
3. ROLLBACK
 
DELETE FROM pay WHERE name='�մ���';
 
SELECT * FROM pay;
 
-- ������ ���ڵ尡 ���� �˴ϴ�., ROLLBACK
ROLLBACK WORK;  
 
SELECT * FROM pay;
 
 
 
4. �����ܰ��� ����
 
DELETE FROM pay WHERE name='�մ���';
 
SELECT * FROM pay;
 
 
-- �Ʒι� �߰�
INSERT INTO pay(name,pay,tax) VALUES('�Ʒι�', 2200000, 120000);
 
SELECT * FROM pay;
 
 
-- �Ʒι��� �޿��� 10% �λ��մϴ�.
UPDATE pay SET pay=pay * 1.1 WHERE name='�Ʒι�';
 
SELECT * FROM pay;
 
 
-- �Ʒι��� ������ 11% �λ��մϴ�.
UPDATE pay SET tax=tax * 0.11 WHERE name='�Ʒι�';
 
SELECT * FROM pay;
 
 
-- ���� ���·� ���ư��ϴ�.
ROLLBACK WORK;
 
SELECT * FROM pay;
 
 
 
5. SAVEPOINT
   - Ư�� �������� ROLLBACK�� �� �ִ� ����� �����մϴ�.
 
-- ���� ������ ����
SAVEPOINT first;
 
INSERT INTO pay(name,pay,tax) VALUES('�Ʒι�', 3000000, 300000);
 
SELECT * FROM pay;
 
 
UPDATE pay SET pay=3500000, tax=350000;
 
SELECT * FROM pay;
 
SAVEPOINT second;
 
 
INSERT INTO pay(name,pay,tax) VALUES('����', 4000000, 400000);
 
SELECT * FROM pay;
 
-- SAVEPOINT second �������� �����մϴ�.
ROLLBACK TO SAVEPOINT second;
 
SELECT * FROM pay;
 
 
ROLLBACK TO SAVEPOINT first;
 
SELECT * FROM pay;
 
 
6. READ Consistency(�б� �ϰ���)
   - iSQL+ �� �귯������ ������ COMMIT �˴ϴ�.
   - SQL+�� â�� ������ ROLLBACK �˴ϴ�.
   - SQL+�� exit����� ������ COMMIT�˴ϴ�.
     ���� �α׾ƿ��ÿ��� �ݵ�� ��������� ROLLBACK, COMMIT��� 
     ����� ���� �մϴ�.
   - SQLExplorer�� 'commit on close'�� �����ϸ�
     ���α׷� ����� �ڵ����� 'commit'�˴ϴ�.  
 
 
   USER 1 --- �ӽ� ���� ---+   +--- COMMIT  ----- Data Area
                                     +--+ 
   USER 2 --- �ӽ� ���� ---+   +--- ROLLBACK
 
 
--user1(SQL Explorer)
SELECT * FROM pay;
 
INSERT INTO pay(name, pay, tax) VALUES('�Ʒι�', 1700000, 50000);
 
SELECT * FROM pay;
 
--user2(SQL Explorer, SQL Plus), ����� ������ �Ʒι̸� ���� �� �����ϴ�.
SELECT * FROM pay;
 
 
--user1(SQL Explorer)
COMMIT;
 
--user2(SQL Explorer, SQL Plus), COMMIT�� �Ǿ������� ����� �����͸� ���� �� �ֽ��ϴ�.
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
    INCREMENT BY 1      -- ���� ��
    START WITH   1      -- 1���� ����
    MAXVALUE     99999  -- �ִ밪
    CACHE 20            -- 20������ �ý��� ���̺� ����
    NOCYCLE;            -- �ִ� 99999�������� �ٽ� ��ȯ���� ���� 
    
    
DROP SEQUENCE emp_seq;
 
 
INSERT INTO emp(num,name, salary,department_id)
VALUES(emp_seq.NextVal,'aaa', 1000000, 20);
INSERT INTO emp(num,name, salary,department_id)
VALUES(emp_seq.NextVal,'bbb', 1100000, 20);
INSERT INTO emp(num,name, salary,department_id)
VALUES(emp_seq.NextVal,'ccc', 1200000, 20);
 
SELECT * FROM emp;
 
 
COMMIT;
 
 
-- ������ Sequence ��� ���
SELECT *
FROM user_sequences;
 
-- ���� sequence���� �� �� ������ ��������� ���� �����˴ϴ�.
SELECT emp_seq.nextval as seq FROM dual;
 
-- ���� sequence�� ���ϴ�.
SELECT emp_seq.currval FROM dual;
 
 
 
[03] INDEX ����
     - index ����� ���Ͽ� ����Ŭ�� �˻� �ӵ��� ����ų �� �ֽ��ϴ�.
       ������ ������ �̸� ����� �δ� �Ͱ� ���� �����Դϴ�.
     
     - WHERE���ǿ� ������ �÷��� ������� �մϴ�.
       PK�÷��� �ڵ����� �ε����� �����˴ϴ�.
       �ϳ��� index�� ���̺� �뷮�� 5%~20%������ ������ �� ��������
       ������ �ε��� ������ ���ؾ��մϴ�.
       index�� �������� Transaction�ð��� ������ϴ�.
 
     - ������ index�� SQL����ÿ� ����Ŭ�����κ��� �ڵ�����
       ���˴ϴ�.
 
       
1. index�� ����
       
CREATE INDEX emp_num_idx
ON emp(num);
 
 
2. index ����� ���
SELECT ic.index_name, ic.column_name,
       ic.column_position col_pos, ix.uniqueness
FROM user_indexes ix,user_ind_columns ic
WHERE ic.index_name = ix.index_name
AND ic.table_name = 'EMP';
 
 
3. �Լ���� �ε��� ����
CREATE INDEX emp_name_idx
ON emp(UPPER(name));
 
SELECT ic.index_name, ic.column_name,
       ic.column_position col_pos, ix.uniqueness
FROM user_indexes ix,user_ind_columns ic
WHERE ic.index_name = ix.index_name
AND ic.table_name = 'EMP';
 
 
4. INDEX�� ����
    
DROP INDEX emp_num_idx;    
    
DROP INDEX emp_name_idx;
    
 
-------------------------------------------------------------------------------------