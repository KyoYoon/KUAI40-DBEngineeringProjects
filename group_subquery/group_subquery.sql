�� group_subquery.sql
-------------------------------------------------------------------------------------
 
1. AVG(), MAX(), MIN(), SUM()
SELECT * FROM itpay;
 
SELECT AVG(bonbong) as ���, MAX(bonbong) as �ִ밪
       , MIN(bonbong) as �ּҰ�, SUM(bonbong) as �հ�
FROM itpay;
 
 
-- �׷�ȭ �Լ��� �Ϲ� �÷��� ���� ����� �� �����ϴ�.
-- � ����� ���� ��հ� �հ����� ������ ��ȣ��!!!
SELECT sawon, AVG(bonbong), SUM(bonbong)
FROM itpay;
 
 
2. ��¥ �󿡼��� MAX(), MIN()
 
SELECT * FROM itpay;
 
SELECT MAX(gdate), MIN(gdate) FROM itpay;
 
SELECT MAX(sawon), MIN(sawon) FROM itpay;
 
 
3. COUNT(), NULL �÷��� ī��Ʈ�� ������ ���� �ʽ��ϴ�.
 
SELECT * FROM itpay;
 
SELECT COUNT(payno) FROM itpay;
 
SELECT COUNT(bonus) FROM itpay;
 
SELECT COUNT(*) FROM itpay;
 
-- NVL �Լ��� �̿��Ͽ� NULL �÷��� ī��Ʈ �մϴ�.
-- null ���� 0���� �����մϴ�.
SELECT COUNT(NVL(bonus, 0)) FROM itpay;
 
 
4. GROUP BY
-- �μ��� ��� �޿��� ����ϼ���.
-- ����μ��� ��� �޿����� ������ �����ν� ��ġ�� ����.
SELECT AVG(bonbong)
FROM itpay
GROUP BY part;   
 
 
-- GROUP BY���� ��õ� �÷��� SELECT���� ����� �� �ֽ��ϴ�.
SELECT part, AVG(bonbong)
FROM itpay
GROUP BY part;   
 
SELECT * FROM itpay;
 
-- �μ���, ������ ��� �޿��� ����ϼ���.
SELECT part, address, TRUNC(AVG(bonbong), -1)
FROM itpay
GROUP BY part, address;   
 
 
-- �μ���, ������ ��� �޿��� ���Ͽ� �μ���, ��������
-- �������� ����ϼ���.
SELECT part, address, TRUNC(AVG(bonbong), -1)
FROM itpay
GROUP BY part, address
ORDER BY part, address; 
 
 
6. GROUP BY���� ������ �̿��ϱ����� HAVING���� �̿�
 
-- �μ��� ��� �޿��� 300������ �Ѵ� �μ��� ���
-- �׷��Լ� ���ǿ� WHERE ���� ����� �� �����ϴ�.��
SELECT part, TRUNC(AVG(bonbong), -1)
FROM itpay
GROUP BY part
HAVING AVG(bonbong) >= 3000000
ORDER BY part; 
 
 
7. �Լ��� ��ø
-- �μ��߿� ��� �޿��� ���� ���� �μ��� �ݾ��� ����ϼ���.
SELECT TRUNC(MAX(AVG(bonbong)), -2)
FROM itpay
GROUP BY part;
 
 
 
[02] SubQuery
 
1. WHERE���� ���������� ���
 
-- �������� ��� �޿�
SELECT AVG(bonbong)
FROM itpay
WHERE part='������';
 
 
-- �������� ��� �޿����� �޿��� ���� ���� ��� 
SELECT *
FROM itpay
WHERE bonbong >= (
                  SELECT AVG(bonbong)
                  FROM itpay
                  WHERE part='������'
);
 
 
-- �������� ��� �޿����� �޿��� ���� �������� �޿���
-- 10% �谨 ��� 
SELECT part, sawon, age, bonbong,
       bonbong * 0.1 as �谨�ݾ�, bonbong * 0.9 as �����޿�
FROM itpay
WHERE bonbong >= (
                  SELECT AVG(bonbong)
                  FROM itpay
                  WHERE part='������'
);
 
 
2. ������ ��ø
 
-- ���浿�� �μ� ���
   SELECT part
   FROM itpay
   WHERE sawon='���浿'
 
 
-- ���浿�� ���� �μ��� ��� �޿� ���
   SELECT TRUNC(AVG(bonbong))
   FROM itpay
   WHERE part = (SELECT part
                 FROM itpay
                 WHERE sawon='���浿');
 
 
-- ���浿�� ���� �μ��� �ٹ��ϸ鼭 �� �μ��� 
-- ��ձ޿� ���� �޿��� ���� ���� ���
   SELECT * 
   FROM itpay
   WHERE (
          bonbong > (
                     SELECT AVG(bonbong)
                     FROM itpay
                     WHERE part = (SELECT part
                                   FROM itpay
                                   WHERE sawon='���浿'
                                  )
                     )
         )
         AND
         (
          part = (
                  SELECT part
                  FROM itpay
                  WHERE sawon='���浿'
                 )
         )                        
 
 
 
3. Subquery + ROWNUM �÷��� �̿��� ���ڵ� ����
 
SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus, rownum
FROM itpay;
 
 
-- rownum�� �����ǰ� ���� ���ĵ����� �����μ��� ��ġ�� ������
SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus, rownum
FROM itpay
ORDER BY sawon;
 
 
-- ���� ������ �����ϰ� rownum�� �߰��մϴ�.
SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus, rownum as r
FROM (
       SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus
       FROM itpay
       ORDER BY sawon
);
     
     
-- rownum �÷� ���� ���� ���ڵ� ����, ERROR
SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus, rownum as r
FROM (
       SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus
       FROM itpay
       ORDER BY sawon
)
WHERE r >= 1 AND r <= 3; 
 
 
-- rownum �÷� ���� ���� ���ڵ� 1~3 ����
SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus, r
FROM(
     SELECT payno, part, sawon, age, address, month, 
            gdate, bonbong, tax, bonus, rownum as r
     FROM (
            SELECT payno, part, sawon, age, address, month, 
            gdate, bonbong, tax, bonus
            FROM itpay
            ORDER BY sawon
    )
)
WHERE r >= 1 AND r <= 3;     
     
     
          
-- rownum �÷� ���� ���� ���ڵ� 4~6 ����
SELECT payno, part, sawon, age, address, month, 
       gdate, bonbong, tax, bonus, r
FROM(
     SELECT payno, part, sawon, age, address, month, 
            gdate, bonbong, tax, bonus, rownum as r
     FROM (
            SELECT payno, part, sawon, age, address, month, 
            gdate, bonbong, tax, bonus
            FROM itpay
            ORDER BY sawon
     )
)
WHERE r >= 4 AND r <= 6;     
     
          
     
4. IN�� ���: Subquery�� ����� 2�� �̻��� ��� ���
   - �޿��� 300���� �Ѵ� ����� ���� ���̸� ������
     �ִ� ������ �޿� ������ ����ϼ���.
 
-- �޿��� 300������ �Ѵ� ������ ���̸� ����մϴ�.     
SELECT age 
FROM itpay
WHERE bonbong >= 3000000;
 
-- �ߺ��� ���� ����
SELECT DISTINCT age 
FROM itpay
WHERE bonbong >= 3000000;
 
-- �μ��� �ߺ��Ǿ� ���
SELECT part
FROM itpay;
 
-- �ߺ��� �μ��� ���� ���
SELECT DISTINCT part
FROM itpay;
 
SELECT payno, part, sawon, age, address
FROM itpay
WHERE age IN(27, 30);
 
SELECT payno, part, sawon, age, address
FROM itpay
WHERE address IN('��õ�� ��籸', '��⵵ ������');
 
 
-- �޿��� 300������ �Ѵ� ������ ���̿� ��ġ�ϴ� ������ ������ ��� ����մϴ�.
SELECT *
FROM itpay
WHERE age IN(
             SELECT DISTINCT age 
             FROM itpay
             WHERE bonbong >= 3000000
            );
   
 
-------------------------------------------------------------------------------------
 