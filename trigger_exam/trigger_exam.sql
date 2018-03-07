-------------------------------------------------------------------------------------  
 
1. Ʈ������ �������
 
   - Ʈ���� ����: Statement Level, Row Level
 
   - Ʈ���� Ÿ�̹�
     . BEFORE: ������ ����Ǳ� ���� �����ϴ� Ʈ����
     . AFTER : ������ ����ǰ� ���� �����ϴ� Ʈ����
 
   - Ʈ���� �̺�Ʈ: INSERT, UPDATE, DELETE
 
   - Ʈ���� ��ü: PL/SQL ��
 
   - Ʈ���� ����: WHEN ����
 
 
 
 
 
2. ���� ������ Ʈ����
-- ��ü transaction �۾��� ���� 1���߻��Ǵ� Ʈ���ŷ� default �Դϴ�.
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
 
 
 
 
 
 
[02] Trigger �ǽ� - ��¥�� ����� ����
 
1. ���̺� ����
 
-- ����� ���Ǿ�� ��ҹ��ڸ� �����ϴ�.(���̺�� ����)
-- ���� ���� ���̺�
DROP TABLE advance_sale PURGE;
 
CREATE TABLE advance_sale(
  NUM     NUMBER              NOT NULL,   -- �Ϸù�ȣ
  SDATE   VARCHAR2(30 BYTE)   NOT NULL,   -- ���� ��¥
  QTY     NUMBER              NOT NULL,   -- ����
  AMOUNT  NUMBER              NOT NULL    -- �ݾ�
);
 
SELECT * FROM advance_sale; 
DELETE FROM advance_sale;
COMMIT;
 
 
 
 
-- �� ����� ���̺�
DROP TABLE sales PURGE;
 
CREATE TABLE sales(
  SDATE      VARCHAR2(30 BYTE) NOT NULL, -- ��¥
  DAYAMOUNT  NUMBER            NOT NULL, -- �ϴ��� �� �ݾ�
  DAYQTY     NUMBER            NOT NULL  -- �ϴ��� �� ����
)
 
SELECT sdate, dayamount, dayqty FROM sales;
 
 
 
 
 
2. Ʈ����
 
   - AFTER INSERT OR UPDATE OR DELETE ON advance_sale 
     advance_sale ���̺� INSERT, UPDATE, DELETE�� �߻��ǰ� ����
     �ڵ����� ����Ǵ� Ʈ����
   - FOR EACH ROW: �� Ʈ����, �� �࿡ ���ؼ� Ʈ���Ű� �߻��ȴ�. 
   - :new - �߰��� ���ڵ带 �����ϰ� �ִ� ��ü 
   - :old - ������ ���ڵ带 �����ϰ� �ִ� ��ü  
 
 
 
CREATE OR REPLACE TRIGGER t_sales
AFTER INSERT OR UPDATE OR DELETE ON advance_sale 
FOR EACH ROW       -- ������ �࿡ ���ؼ� �۵�
DECLARE 
    v_cnt NUMBER;  -- ���� ���� ����
BEGIN  
    -- ������ ��ϵ� ���ڵ��� ��¥�� ���� �߰��Ǵ� �÷��� ��¥�� ���Ͽ�
    -- ��¥�� ���� ���ڵ��� ���� �����մϴ�.  
    SELECT count(*) INTO v_cnt 
    FROM sales 
    WHERE sdate = :new.sdate;
    
    
    IF INSERTING THEN -- advance_sale ���̺� ���ڵ� �߰��ϰ��
        IF v_cnt > 0 THEN 
            -- ������ ���� ��¥�� ��ϵ� ���ڵ尡 �ִٸ� �ݾ�, ���� ����
            -- �ݾ� = ���� �ݾ� + ���ο� �ݾ�
            -- ���� = ���� ���� + ���ο� ����  
            UPDATE sales 
            SET dayamount = dayamount + :new.amount
              , dayqty = dayqty + :new.qty
            WHERE sdate = :new.sdate; -- ��¥�� ���� ���ڵ�    
 
        ELSE -- ������ ��ϵ� ��¥�� ���ٸ� ���� ���ڵ� �߰�
            INSERT INTO sales(sdate, dayamount, dayqty)
            VALUES(:new.sdate, :new.amount, :new.qty);     
        END IF;
    ELSIF DELETING THEN  -- ���ڵ� ������ ���, �ݾ�, ���� ����
        -- :old: ������ ���ڵ带 ������ �ִ� ��ü
        -- ���� ��¥�� ���ؼ� �ݾ� �� ������ ���� �մϴ�.
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
 
 
 
 
 
3. ���ο� ��¥�� ������ �߻��� ��� INSERT Test
 
INSERT INTO advance_sale(num, sdate, qty, amount)
VALUES(1, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);
 
SELECT * FROM advance_sale;
 
    NUM SDATE                       QTY     AMOUNT
------- -------------------- ---------- ----------
      1 2009-07-21                    1       5000
 
 
 
-- �� ����� ���̺�
SELECT sdate, dayamount, dayqty FROM sales;
 
SDATE                           DAYAMOUNT     DAYQTY
------------------------------ ---------- ----------
2009-02-17                           5000          1
 
 
 
 
 
4. ���� ��¥�� ������ �߻��� ��� UPDATE Test
 
INSERT INTO advance_sale(num, sdate, qty, amount)
VALUES(2, TO_CHAR(sysdate, 'yyyy-mm-dd'), 1, 5000);
 
SELECT * FROM advance_sale;
 
    NUM SDATE                       QTY     AMOUNT
------- -------------------- ---------- ----------
      1 2009-02-17                    1       5000
      2 2009-02-17                    1       5000
 
 
 
-- �� ����� ���̺�
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
 
 
 
-- �� ����� ���̺�
SELECT sdate, TO_CHAR(dayamount, '9,999,999'), dayqty FROM sales;
 
SDATE                           DAYAMOUNT     DAYQTY
------------------------------ ---------- ----------
2009-02-17                         60,000         12
 
 
 
 
 
5. ��¥�� �ٸ����
 
- Oracle Server�� �ð� ������ �׽�Ʈ�� �ϴ��� �Ǵ� sysdate+1�� �մϴ�.
 
INSERT INTO advance_sale(num, sdate, qty, amount)
VALUES(4, TO_CHAR(sysdate + 1, 'yyyy-mm-dd'), 3, 15000);
 
SELECT * FROM advance_sale
 
    NUM SDATE                       QTY     AMOUNT
------- -------------------- ---------- ----------
      1 2009-02-17                    1       5000
      2 2009-02-17                    1       5000
      3 2009-02-17                   10      50000
      4 2009-02-18                    3      15000 
 
 
 
-- �� ����� ���̺�
SELECT sdate, TO_CHAR(dayamount, '9,999,999'), dayqty FROM sales;
 
SDATE                           DAYAMOUNT     DAYQTY
------------------------------ ---------- ----------
2009-02-17                         60,000         12
2009-02-18                         15,000          3
 
 
 
 
 
6. ������� ��ҵǴ� ���
   - Toad F5: ���� ���� ����
 
   -- �ǽ��� ���ؼ� ���� ����
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
 
    NUM SDATE                       QTY     AMOUNT
------- -------------------- ---------- ----------
      1 2009-07-21                    1       5000
      2 2009-07-21                    1       5000
      3 2009-07-21                    1       5000
 
 
 
-- �� ����� ���̺�
SELECT sdate, dayamount, dayqty FROM sales
 
SDATE                           DAYAMOUNT     DAYQTY
------------------------------ ---------- ----------
2009-02-17                          15000          3
 
 
 
 
--���� ���̺��� 1�� �������
 
SELECT * FROM advance_sale;
 
DELETE FROM advance_sale WHERE num=1;
 
SELECT * FROM advance_sale;
 
    NUM SDATE                       QTY     AMOUNT
------- -------------------- ---------- ----------
      2 2009-02-17                    1       5000
      3 2009-02-17                    1       5000
         
         
 
-- ����� ���̺�
SELECT sdate, dayamount, dayqty FROM sales;
 
SDATE                           DAYAMOUNT     DAYQTY
------------------------------ ---------- ----------
2009-02-17                          10000          2
 
 
 
 
    
7. ������� �����Ǵ� ���
 
�� �߸��� ������� �߰��մϴ�.
INSERT INTO advance_sale(num, sdate, qty, amount)
VALUES(10, TO_CHAR(sysdate, 'yyyy-mm-dd'), 100, 500000);
 
-- ���� ���� ���̺�
SELECT * FROM advance_sale;
 
-- ����� ���̺�
SELECT sdate, dayamount, dayqty FROM sales; 
 
 
 
�� �߸��� ����� ����
DELETE FROM advance_sale WHERE num=10;
 
-- ���� ���� ���̺�
SELECT * FROM advance_sale;
 
-- ����� ���̺�
SELECT sdate, dayamount, dayqty FROM sales;
 
 
 
�� �ٽ� ���ο� �����Ͱ� �� ������� �߰��մϴ�.
INSERT INTO advance_sale(num, sdate, qty, amount)
VALUES(10, TO_CHAR(sysdate, 'yyyy-mm-dd'), 20, 100000);
 
-- ���� ���� ���̺�
SELECT * FROM advance_sale;
 
 
-- ����� ���̺�
SELECT sdate, dayamount, dayqty FROM sales;
 
 
-------------------------------------------------------------------------------------  