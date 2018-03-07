�� view.sql
-------------------------------------------------------------------------------------
1. �⺻���� View�� ����
 
1) ���̺� ����
DROP TABLE test PURGE;
 
CREATE TABLE test(
    testno NUMBER(5)   NOT NULL, -- �Ϸù�ȣ
    name   VARCHAR(30) NOT NULL, -- ����
    mat    NUMBER(3)   NOT NULL, -- ����
    eng    NUMBER(3)   NOT NULL, -- ����
    tot    NUMBER(3)       NULL, -- ����
    avg    NUMBER(4, 1)    NULL, -- ���
    PRIMARY KEY (testno) 
);
 
DELETE FROM test;
 
 
 
2) ���� ������ �߰�
 
INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),    
    '�Ǿ �귯����', 80, 100
);
 
INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),    
    '�޸���Ʈ��', 80, 100
);
 
INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),    
    '��������', 85, 80
);
 
INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),    
    '�ݸ��۽�', 65, 60
);
 
INSERT INTO test(testno, name, mat, eng)
VALUES((SELECT NVL(MAX(testno), 0)+1 as cnt FROM test),    
    '���ڶ� ��ī������', 75, 70
);
 
 
UPDATE test SET tot = mat+eng;
 
UPDATE test SET avg = tot/2;
 
SELECT * FROM test;
 
3) VIEW�� ����
-- ����� ���
DROP VIEW vtest_90;
 
CREATE VIEW vtest_90
AS 
SELECT testno, name, mat, eng, tot, avg
FROM test
WHERE avg >= 90;
 
SELECT * FROM tab;
 
SELECT testno, name, mat, eng, tot, avg FROM vtest_90;
 
 
2. �Ϻ� �÷��� View�� ������� ����
 
DROP VIEW vtest_80;
 
CREATE VIEW vtest_80
AS 
SELECT testno, name, tot, avg
FROM test
WHERE avg >= 80;
 
 
SELECT testno, name, tot, avg FROM vtest_80; 
 
-- ERROR, View�� ���� �÷� ���� ����.
SELECT testno, name, mat, eng, tot, avg FROM vtest_80; 
 
 
3. ()���� �÷��� �����Ǵ� View�� �÷��� �����Դϴ�.
- ���� �÷����� ���߾���.
CREATE OR REPLACE VIEW vtest_70(
    hakbun, student_name, total, average
)
AS 
SELECT testno, name, tot, avg
FROM test
WHERE avg >= 70;
 
SELECT * FROM vtest_70;
 
  
4. �Լ��� �̿��� View�� ����
CREATE OR REPLACE VIEW vtest_func(
    max_total, min_total, avg_total
)
AS 
SELECT MAX(tot), MIN(tot), AVG(tot) 
FROM test;
   
 
SELECT * FROM vtest_func;
 
 
5. WITH CHECK OPTION 
   - WHERE���� ����� �÷��� ���� ���� �� �� �����ϴ�.
 
1) �ǽ��� ���̺�
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
 
2) WITH CHECK OPTION ������� ���� ���
CREATE VIEW vemp20
AS 
SELECT *
FROM employee
WHERE department_id=20;
 
SELECT * FROM vemp20;
 
-- vemp20�� 20�� �μ��� �۾� ������� �ϳ�
-- WHERE���� ��Ÿ�� �μ��� 30������ ���������� ���� ������
-- �߻��մϴ�.
-- View�� �̿��� UPDATE�� ������ �ƴմϴ�.
UPDATE vemp20 SET department_id=30;
 
-- �μ��� ��� 30������ ����Ǿ� ����� �����ϴ�.
SELECT * FROM vemp20;
 
SELECT * FROM employee;
 
ROLLBACK;
 
 
 
3) WITH CHECK OPTION�� ����� ���
CREATE VIEW vemp_c20
AS 
SELECT *
FROM employee
WHERE department_id=20
WITH CHECK OPTION CONSTRAINT vemp_c20_ck;
   
SELECT * FROM vemp_c20;
 
-- UPDATE�� �����Ǿ� ������ �ȵ˴ϴ�. UPDATE�� �����ϰ��� �� ����
-- ������ ���̺��� ������� �մϴ�.
-- SQL ����: ORA-01402: view WITH CHECK OPTION where-clause violation
-- 01402. 00000 -  "view WITH CHECK OPTION where-clause violation"
UPDATE vemp_c20 SET department_id=30;
 
UPDATE vemp_c20 SET salary = 2000000 WHERE name = 'ccc';
 
SELECT * FROM vemp_c20;
 
SELECT * FROM employee;
 
ROLLBACK;
 
 
6. WITH READ ONLY �ɼ�
  - View���� UPDATE, INSERT, DELETE ����� ������ŵ�ϴ�.
 
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
    '�ٸ� ���ͽ�', 150
);
 
-- SQL ����: ORA-42399: cannot perform a DML operation on a read-only view
-- 42399.0000 - "cannot perform a DML operation on a read-only view"
UPDATE test_read SET total = 200;
 
 
�� VIEW�� INSERT, UPDATE, DELETE���� ����� �������� �ʽ��ϴ�.
 
 
7. FROM ���� ��ϵ� Subquery�� INLINE VIEW��� �ؼ�
   SQL ���ο� ���Ե� �ӽ� VIEW��� �θ��ϴ�.
   - Top-n Analysis���� ���� ���
   
 
1) ���ڵ� ����
 
SELECT testno, name, mat, eng, tot, avg
FROM test
ORDER BY testno DESC;
 
2) rownum ����
SELECT testno, name, mat, eng, tot, avg, rownum r
FROM(
    SELECT testno, name, mat, eng, tot, avg -- Inline View
    FROM test
    ORDER BY testno DESC
);
   
3) record ����
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
 
 
4) �˻�
SELECT testno, name, mat, eng, tot, avg, r
FROM(
    SELECT testno, name, mat, eng, tot, avg, rownum as r
    FROM(
        SELECT testno, name, mat, eng, tot, avg -- Inline View
        FROM test
        WHERE name LIKE '%�޸�%'
        ORDER BY testno DESC
    )
)
WHERE r > =1 AND r <= 3;
 
5) Subquery�� View ����
 
CREATE OR REPLACE VIEW test_list
AS
SELECT testno, name, mat, eng, tot, avg -- Inline View
FROM test
ORDER BY testno DESC;
 
6) Subquery�� View�� ���
 
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
 
-- �˻�
SELECT testno, name, mat, eng, tot, avg, r
FROM (
    SELECT testno, name, mat, eng, tot, avg, rownum r
    FROM test_list
    WHERE name LIKE '%�޸�%'
)
WHERE r > = 1 AND r <= 3;
 
 
-------------------------------------------------------------------------------------