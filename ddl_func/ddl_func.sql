-------------------------------------------------------------------------------------
1. ���̺� ����
 
DROP TABLE itpay PURGE;
 
CREATE TABLE itpay(
    payno   NUMBER(7)   NOT NULL,  -- 1 ~ 9999999
    part    VARCHAR(20) NOT NULL,  -- �μ���
    sawon   VARCHAR(10) NOT NULL,  -- �����
    age     NUMBER(3)   NOT NULL,  -- ����, 1 ~ 999
    address VARCHAR(50) NOT NULL,  -- �ּ�
    month   CHAR(6)     NOT NULL,  -- �޿���, 200805
    gdate   DATE        NOT NULL,  -- ������
    bonbong NUMBER(8)   DEFAULT 0, -- ����  
    tax     NUMBER(7, 2)   DEFAULT 0, -- ����, ��ü �ڸ�, +-99999.99
    bonus   NUMBER(7)       NULL,  -- ���ʽ�
    family  NUMBER(7)       NULL,  -- ���� ����
    PRIMARY KEY(payno)
);
 
 
2. ���� ������ �߰�
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(1, '��������', '���浿', 27, '��⵵ ������',
       '200801', sysdate, 1530000, 12345.67, 0);
       
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(2, '��������', '���浿', 30, '��õ�� ��籸',
       '200801', sysdate-5, 1940000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(3, '������', '�ٱ浿', 34, '��⵵ ������',
       '200801', sysdate-3, 2890000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(4, '������', '��浿', 36, '��⵵ ��õ��',
       '200802', sysdate-1, 4070000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(5, 'DB������', '���浿', 38, '��⵵ ��õ��',
       '200802', sysdate-0, 2960000, 0, 0);
 
SELECT * FROM itpay;
 
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(6, '��ȹ������', '�ٱ浿', 40, '����� ������',
       '200802', sysdate-0, 3840000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(7, '������', '��浿', 42, '��õ�� ��籸',
       '200803', sysdate-0, 4230000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(8, 'DB������', '��浿', 42, '��⵵ ��õ��',
       '200803', sysdate-1, 4010000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(9, 'DB������', '�̱浿', 42, '����� ������',
       '200803', sysdate-1, 3500000, 0, 0);
 
SELECT * FROM itpay;
 
 
-- null �÷��� �߰�
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax)
VALUES(10, '������', '�ű浿', 33, '����� ���Ǳ�',
       '200804', sysdate, 3500000, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax)
VALUES(11, '������', '�ֱ浿', 31, '����� ���Ǳ�',
       '200804', sysdate, 4500000, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax)
VALUES(12, '������', '���浿', 29, '����� ���Ǳ�',
       '200804', sysdate, 3200000, 0);
 
 
SELECT * FROM itpay;
 
 
2. �÷� �߰�
 
ALTER TABLE itpay
ADD (test VARCHAR2(9));
 
DESCRIBE itpay;
 
 
3. �÷� �Ӽ� ����
 
ALTER TABLE itpay
MODIFY (test VARCHAR2(30));
 
 
4. �÷��� ����
ALTER TABLE itpay
RENAME COLUMN test to test2;
 
 
5. �÷� ����
ALTER TABLE itpay
DROP COLUMN test2;
 
 
6. ���̺� ����
 
DROP TABLE itpay;
 
-- DROP TABLE itpay PURGE; -- ���̺� ���� ����
 
 
7. ���̺� ����
FLASHBACK TABLE itpay TO BEFORE DROP; -- Standard Edition�� �� ������ ���డ�� 
 
SELECT * FROM itpay;
 
 
8. ������ ����
- ������ ���̺� ���� ����, ���� �Ұ���
 
PURGE RECYCLEBIN;
  
  
  
[02] Single-Row Function(������ �Լ�)
     - ���ڵ� ������ �Լ��� ���� �˴ϴ�.
    
1. UPPER, LOWER
 
-- �ҹ��ڷ� ����
SELECT payno, LOWER(part), sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
-- �빮�ڷ� ����
SELECT payno, UPPER(part), sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
2. CONCAT
SELECT payno, CONCAT(part, '-' || sawon) as name, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
3. SUBSTR, index�� 1���� ����
-- 3��° �������ĺ��� ���
SELECT payno, SUBSTR(address, 5),
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
-- 1~3��° ���� ���
SELECT payno, SUBSTR(address, 1, 3),
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
-- 2��° ���ں��� 4���� ���
SELECT payno, SUBSTR(address, 2, 4),
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
4. LENGTH
 
SELECT payno, address, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
SELECT payno, address, LENGTH(address) as len,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
5. INSTR, index�� 1���� ����
SELECT payno, address, INSTR(address, 'õ') as idx,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
6. LPAD, RPAD ����
SELECT bonbong, LPAD(bonbong, 10, 0)
FROM itpay
ORDER BY sawon ASC;
 
 
SELECT bonbong, RPAD(bonbong, 10, 0)
FROM itpay
ORDER BY sawon ASC;
 
 
SELECT bonbong,LPAD(bonbong, 10, '*')
FROM itpay
ORDER BY sawon ASC;
 
SELECT * FROM itpay; 
 
7. REPLACE
- REPLACE(�÷���, ������ ���ڿ�, ���� ����� ���ڿ�)
SELECT payno, address, REPLACE(address, '��籸','������') as ADDR,
       month, gdate, bonbong, tax, bonus
FROM itpay
WHERE address LIKE '%��õ%'
ORDER BY sawon ASC;
 
 
8. ROUND
-- �Ҽ� ��° �ڸ����� �ݿø�
SELECT ROUND(55.634, 2), ROUND(55.635, 2)
FROM dual;
 
-- ���� ���� �ݿø�
-- -1: 1�� �ڸ�, -2: 10�� �ڸ����� �ݿø�
-- �ݿø� �ȵ�
SELECT ROUND(23541, -1), ROUND(23541.25, -2)
FROM dual;
 
-- �ݿø���.
SELECT ROUND(23551, -1), ROUND(23551.25, -2)
FROM dual;
 
 
9. TO_CHAR(): ��¥�� ��� �� ��
-- ���� ��¥ ���
SELECT sysdate FROM dual;
 
-- 2008-05-19�Ͽ� �޿��� �޴� ��� ���
SELECT gdate, SUBSTR(gdate, 1, 10)
FROM itpay;
 
SELECT gdate, TO_CHAR(gdate, 'yyyy-mm-dd')
FROM itpay;
 
 
-- ���� ����
SELECT gdate, TO_CHAR(gdate, 'yyyy-mm-dd hh:mi:ss') as newgdate
FROM itpay;
 
 
-- TO_CHAR() �Լ��� ���� ���ڿ� ����ȯ
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
WHERE TO_CHAR(gdate, 'yyyy-mm-dd') = '2018-02-28';
 
 
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
WHERE TO_CHAR(gdate, 'yyyy-mm-dd hh24') = '2018-02-28 10'; -- ���� �ð� �������� ��ȸ (���� 11�ð� �� �Ǿ����Ƿ� 10���� �����ϸ� ��)
  
  
10. �� ��¥ ������ �� ���
    - sysdate+1: ���� ��¥�� 1���� ����
 
SELECT MONTHS_BETWEEN(sysdate+1, sysdate) 
FROM dual;
 
SELECT MONTHS_BETWEEN(sysdate+31, sysdate) 
FROM dual;
 
 
11. �� ���ϱ�
SELECT ADD_MONTHS(sysdate, 1) FROM dual;
 
 
12. ���ƿ��� �������� ��¥ ���
SELECT NEXT_DAY(sysdate, '������') FROM dual;
 
 
13. �̹����� �������� ���
SELECT LAST_DAY(sysdate) FROM dual;
 
 
14. TO_CHAR
SELECT TO_CHAR(sysdate, 'yyyy-mm-dd hh:mi:ss') 
FROM dual;
 
SELECT TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss') 
FROM dual;
 
-- ������ ���ڿ� 0���� ä��
SELECT TO_CHAR(1500, '0999999') FROM dual;
 
-- ��� ���ĺ��� ���� ũ�� '# ���
SELECT TO_CHAR(150000, '9,999') FROM dual;
 
-- õ���� ������ ���
SELECT TO_CHAR(150000, '999,999') FROM dual;
 
-- ��ȣ ���
SELECT TO_CHAR(150000, 'S999,999') FROM dual;
 
SELECT TO_CHAR(-150000, 'S999,999') FROM dual;
 
SELECT TO_CHAR(1500.55, '9,999.99') FROM dual;
 
SELECT TO_CHAR(1500.55, '9,999.9') FROM dual;
 
-- �Ҽ��� �ڵ� �ݿø�.
SELECT TO_CHAR(1500.5, '9,999.999') FROM dual;
 
 
15 NVL �Լ�
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, bonus,
       family
FROM itpay;
 
-- null�� �ƴϸ� �÷� ���� �״�� ����ϳ� 
-- null�̸� ���� 0���� ����
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, 
       NVL(bonus, 0) + 500000 as bonus,
       NVL(family, 0)
FROM itpay;
 
 
16. TRUNC() �Լ��� �̿��� �Ҽ��� ���� ����
 
-- ������ ���
SELECT TRUNC(tax, 0)
FROM itpay;
 
-- �Ҽ� ù° �ڸ��� ���, �ݿø� �ȵ�
SELECT TRUNC(tax, 1)
FROM itpay;
 
-- 10���ڸ����� ���, 1���ڸ� ���� ����, �ݿø� �ȵ�
SELECT TRUNC(tax, -1)
FROM itpay;
 
-- 12,340
SELECT TO_CHAR(TRUNC(tax, -1), '9,999,999')
FROM itpay;

SELECT * FROM itpay; 
 
17. CASE ��
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax,
       CASE part WHEN '������' THEN 0.5*bonbong
                 WHEN 'DB������' THEN 0.4*bonbong
                 WHEN '��������' THEN 0.3*bonbong
       ELSE 0.1*bonbong END bonus
FROM itpay;
 
 
-------------------------------------------------------------------------------------