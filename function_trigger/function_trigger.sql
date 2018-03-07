�� function_trigger.sql
-------------------------------------------------------------------------------------
1. �Լ��� �ǽ�
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
   CONSTRAINT emp_empno_pk PRIMARY KEY(empno)  --�ߺ��� ���� �ü� ����, �ݵ�� ���� �Է�
);
 
-- Procedure editor���� �۾��մϴ�.
 
CREATE OR REPLACE FUNCTION f_tax(i_value IN NUMBER)
RETURN NUMBER                -- ���� Ÿ��
IS
BEGIN
    return (i_value * 0.05); -- ���� 5 % ���
END f_tax;
/

INSERT INTO emp(empno, ename, sal, deptno) 
VALUES(emp_seq.NextVal, '�귡����Ʈ', 3000000, 10); 

INSERT INTO emp(empno, ename, sal, deptno) 
VALUES(emp_seq.NextVal, '�����', 4000000, 20); 

INSERT INTO emp(empno, ename, sal, deptno) 
VALUES(emp_seq.NextVal, '������', 5000000, 30); 

INSERT INTO emp(empno, ename, sal, deptno) 
VALUES(emp_seq.NextVal, '�����', 6000000, 40); 

INSERT INTO emp(empno, ename, sal, deptno) 
VALUES(emp_seq.NextVal, '������', 4500000, 50); 

DELETE FROM emp;
 
SELECT ename as "����", deptno as "��ȣ", sal as "�޿�", f_tax(sal) as "���� 5% ���� �ݾ�"
FROM emp;
 
 
2. emp.deptno �÷��� ���� 10-�����, 20-�渮��, 30-������, 40-�����
   - dept()
 
CREATE OR REPLACE FUNCTION f_dept(i_deptno IN NUMBER)
    RETURN VARCHAR
    IS
        v_dept varchar(20) := null;
    BEGIN
        if i_deptno = 10 then
            v_dept := '�����';
        end if;
        if i_deptno = 20 then
            v_dept := '�渮��';
        end if;
        if i_deptno = 30 then
            v_dept := '������';
        end if;
        if i_deptno = 40 then
            v_dept := '�����';
        end if;
        
        return v_dept;
    END f_dept;
/
 
 
-- ELSIF�� ���
CREATE OR REPLACE FUNCTION f_dept(i_deptno IN NUMBER)
    RETURN VARCHAR
    IS
        v_dept varchar(20) := null;
    BEGIN
        if i_deptno = 10 then
            v_dept := '�����';
        elsif i_deptno = 20 then
            v_dept := '�渮��';
        elsif i_deptno = 30 then
            v_dept := '������';
        elsif i_deptno = 40 then
            v_dept :='�����';
        else
            v_dept :='�μ�������';            
        end if;
        
        return v_dept;
    END f_dept;
/
 
SELECT * FROM emp;
 
SELECT ename as "����", deptno as "��ȣ"
       , f_dept(deptno) as "�μ���" 
FROM emp;
 
 
 
[02] Trigger
 
   - UPDATE, INSERT, DELETE ������ ����� ������ �ΰ������� �ٸ� ������ 
     ���� �� �� �ִ� ����Դϴ�.
 
   - ROLLBACK�� �� �����ϴ�.
 
   - �ʹ� ������ Ʈ������ ����� DB�� �ӵ��� ���Ͻ�Ű�� ������ �ֽ��ϴ�.
 
 
1. Ʈ������ �������
 
   - Ʈ���� ����: Statement Level, Row Level
 
   - Ʈ���� Ÿ�̹�
     . BEFORE: ������ ����Ǳ� ���� �����ϴ� Ʈ����
     . AFTER : ������ ����ǰ� ���� �����ϴ� Ʈ����
 
   - Ʈ���� �̺�Ʈ: INSERT, UPDATE, DELETE
 
   - Ʈ���� ��ü: PL/SQL ��
 
   - Ʈ���� ����: WHEN ����
 
 
2. ���� ������ Ʈ����
-- ��ü transaction �۾��� ���� 1�� �߻��Ǵ� Ʈ���ŷ� default �Դϴ�.
-- emp ���̺� ���ؼ� insert, update, delete�� �߻��ϸ� �Ʒ���
-- Ʈ���Ű� �ڵ����� �۵��Ǿ� ������ '��, ��'�� ���� �Ʒ�ó��
-- �޽����� ����մϴ�.
 
�� Procedure editor���� �۾��մϴ�.
   emp ���̺� INSERT, UPDATE, DELETE�� �߻��� ������ �ڵ�����
   ����˴ϴ�. 
 
CREATE or REPLACE TRIGGER t_test1
BEFORE INSERT or UPDATE or DELETE ON emp
BEGIN
IF (TO_CHAR(sysdate, 'DY') IN ('��', '��')) or (TO_CHAR(sysdate, 'DY') IN ('SAT', 'SUN')) THEN
    DBMS_OUTPUT.PUT_LINE('�ָ����� �����͸� ������ �� �����ϴ�.!!');
ELSE
    DBMS_OUTPUT.PUT_LINE('������ ~ �ݿ��Ͽ��� �����͸� ������ �� �ֽ��ϴ�.!!');
END IF;
END;
/
 
�� ����Ŭ ������ ��¥�� ������̳� �Ͽ��Ϸ� ������ �׽�Ʈ�մϴ�.
 
INSERT INTO emp(empno, ename, deptno) 
VALUES(emp_seq.NextVal, '�귡����Ʈ', 10);
 
SELECT * FROM emp;
 
 
UPDATE emp SET sal = sal * 1.1;
 
SELECT * FROM emp;
 
 
DELETE FROM emp WHERE empno = 1;
 
SELECT * FROM emp;
  
  
-------------------------------------------------------------------------------------