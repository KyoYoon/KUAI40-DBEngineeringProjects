[01] PL/SQL�� ����
 
1. SQL�� ����
   - ����ڰ� �����ϱ� ���� �ܾ�� ����
   - ���� ��� �� �ִ�.
   - ������ ������ �����ϰ� �ۼ��� �� �ִ�.
   - ANSI�� ���� ������ ǥ��ȭ �Ǿ� �ִ�.
 
 
2. SQL�� ����
   - �ݺ�ó���� �� �� ����.
   - ��ó���� �� �� ����.
   - Error ó���� �� �� ����.
   - SQL ���� ĸ��ȭ �� �� ����.
   - ���� ������ �� �� ����.
   - ������ �� ���� �м��۾� �� ���������� �ӵ��� �����ϴ�.
   - Application Server���� DBMS������ �ݺ��ؼ� SQL�� ���۵����� ���ʿ��� 
     Network Traffic�� �����Ѵ�.
 
 
3. PL(Procedural Language) SQL
   - �ݺ�ó���� �� �� �ִ�.
   - ��ó���� �� �� �ִ�..
   - Error ó���� �� �� �ִ�.
   - SQL ���� ĸ��ȭ �� �� �ִ�.
   - ���� ������ �� �� �ִ�.
   - ������ �� ���� �м��� ����� ���ุ �ϱ� ������ �ӵ��� ������.
   - Application���� �߻��ϴ� Ʈ������ �ּ�ȭ �� �� ������ �������� Ʈ�������
     �����ϴ� �� ������ �ݴϴ�.
 
 
4. PL/SQL�� ����
 
   DECLARE
   - �����: ���� ���� ����
   :
   :
   :  
   BEGIN
   - ���๮ ���: SQL, �񱳹�, ���, Ŀ�� �Ӽ� ���
   :
   :
   :  
   EXCEPTION
   - ���๮�� ó���ϴ��� �߻��ϴ� ����ó�� ��� 
   :
   :
   :  
   END;
   /
    
 
 
[02] PL/SQL�� ����
   
1. Anonymous Procedure
   - PL/SQL ������ �ۼ��Ͽ� �ʿ��� �� ���� �ӽ÷� ����ϸ� ������ ������ ���� �ʽ��ϴ�.
 
 
2. Stored Procedure
   - ���� ���ν����� INSERT, DELETE, UPDATE, SELECT ������ ������
     ������ ����Ǿ� ������ ������ ���������� ���� �� �� �ֽ��ϴ�.
 
 
3. Stored Function
   - Stored Procedure�� ó���� �ϰ� �������� Stored Function�� ó������� �����մϴ�.
 
 
4. Package
   - �ð��� �带 ���� �����Ǵ� Stored Procedure, Stored Function�� �׷�����
     ���� ó�������� ó�� ȿ���� ���� �� �� �ֽ��ϴ�.
 
 
5. Trigger
   - �����ͺ��̽� ����, ����, �������� ������ ó���۾��� �������� ������ �� �ִ� ����Դϴ�.
 
 
 
[03] ��ũ��Ʈ ����
   - �ĺ���(����)�� 30���ڸ� �ʰ��� �� �����ϴ�.
   - �ĺ��ڴ� ���̺�, �÷���� ���� �� �� �����ϴ�.
   - �ĺ��ڴ� �ݵ�� ���ڰ����� �����ؾ� �մϴ�.
   - ���ڿ� ��¥�� " ' " �ο��ȣ�� �̿��մϴ�.
   - �ּ��� "--", �������� �ּ��� "/* */�� �̿��մϴ�.
 
 
�� Toad SQL Editor���� "Turn Output On"�����ϰ� �����մϴ�.
     - ����� Toad�� �۵��� �ȵ˴ϴ�.



�� procedure.sql
-------------------------------------------------------------------------------------

-- ���ν��� ���� �� ������ �����ؾ� ��. �������� ������ ����� ǥ�õ��� ����. 

SET SERVEROUTPUT ON;  
 
1. �񱳹�
 
DECLARE
    v_condition number := 1;
BEGIN
    IF v_condition = 1 THEN
        DBMS_OUTPUT.PUT_LINE('�������� ���� 1�Դϴ�.');
    END IF;
END;
/
 
 
 
DECLARE
    v_condition number :=2;
BEGIN
    IF v_condition > 1 THEN
        DBMS_OUTPUT.PUT_LINE('�������� ���� 1���� Ů�ϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�������� ���� 1���� �۽��ϴ�.');
    END IF;
END;
/
 
 
 
DECLARE
    v_condition number :=2;
BEGIN
    IF v_condition > 1 THEN
        DBMS_OUTPUT.PUT_LINE('�������� ���� 1���� Ů�ϴ�.');
    ELSIF v_condition = 1 THEN
        DBMS_OUTPUT.PUT_LINE('�������� ���� 1�Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�������� ���� 1���� �۽��ϴ�.');
    END IF;
END;
/
 
 
 
2. �ݺ���
 
DECLARE
    cnt number := 0;
BEGIN
    LOOP
        cnt := cnt + 1;
        DBMS_OUTPUT.PUT_LINE(cnt);
        EXIT WHEN cnt = 10;
    END LOOP;
END;
/
 
 
 
BEGIN
    FOR i IN 1..10 LOOP         -- i ������ ���� 1���� 10���� ���� 
        IF (MOD(i, 2) = 1) THEN -- Ȧ���� ���
            DBMS_OUTPUT.PUT_LINE(i);
        END IF;
    END LOOP;
END;
/
 
 
 
DECLARE
    v_cnt number := 0;
    v_str varchar2(10) := null;
BEGIN
    WHILE v_cnt <= 10 LOOP     -- v_cnt 10���� �۰ų� ���� ���� ����
        v_cnt := v_cnt+1;
        DBMS_OUTPUT.PUT_LINE(v_cnt);
    END LOOP;
END;
/
 
 
-------------------------------------------------------------------------------------