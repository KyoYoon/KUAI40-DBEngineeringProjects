�� procedure_sungjuk.sql
-------------------------------------------------------------------------------------
 
1. �⺻ ���̺� ���� �����
 
-- ����
DROP TABLE sungjuk PURGE;
 
CREATE TABLE sungjuk
(
  num  number(3)    not null,   -- �Ϸù�ȣ
  name varchar2(20) not null,   -- ����
  kuk number(3)    not null,   -- ����
  eng number(3)    not null,   -- ����
  tot number(3)    null,       -- ����
  pye number(3)    null,       -- ���
  rpt varchar(10)  null,      -- ����Ʈ ���� ����(����, ������)
  opt number(3)    null,       -- ����Ʈ ���� ����
  PRIMARY KEY(num)
);
 
 
INSERT INTO sungjuk(num, name, kuk, eng) VALUES(1, '��ȹ��', 90, 80);
INSERT INTO sungjuk(num, name, kuk, eng) VALUES(2, '������', 100, 80);
INSERT INTO sungjuk(num, name, kuk, eng) VALUES(3, '������', 90, 100);
COMMIT;
 
 
-- ���� ���� ���� ���̺�
DROP TABLE logTable PURGE;
 
CREATE TABLE logTable
(
    logtableno NUMBER(7),        -- �Ϸ� ��ȣ
    user_id   VARCHAR2(20),     -- ���� ���� ���̵�, ������ ���̵�
    log_date   DATE,             -- ���� ���� ��¥
    query      VARCHAR2(1000),   -- SQL ������
    PRIMARY KEY (logtableno)
);
  
  
2. ���� ���� ������ �����ϴ� ���ν���. DBMS ���� ����� ����
- sysdate: ��¥
- user: ������ ����
 
SELECT user, sysdate FROM dual;
 
USER                           SYSDATE
------------------------------ --------
SOLDESK                        17/12/01
 
 
CREATE OR REPLACE PROCEDURE log_write
(
     i_query IN logTable.query%TYPE -- �Է� �Ķ����
) 
IS
BEGIN
  INSERT INTO logTable(logtableno, user_id, log_date, query) 
  VALUES((SELECT NVL(MAX(logtableno), 0) + 1 FROM logTable),
  user, sysdate, i_query); 
 
  COMMIT;
END log_write;
/
 
 
-- exec log_write('DELETE FROM sungjuk WHERE num=1');
DECLARE
BEGIN
    log_write('DELETE FROM sungjuk WHERE num=1');
END;
/
 
 
SELECT * FROM logTable;
 
LOGTABLENO USER_ID              LOG_DATE QUERY                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
--------------- ---------              ------------ --------
         1          SOLDESK            17/12/01 DELETE FROM sungjuk WHERE num=1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
 
 
3. ������ �Է��ϴ� ���ν���
 
CREATE OR REPLACE PROCEDURE insert_sungjuk
(
    -- �Է°� ���
  i_num IN sungjuk.num%TYPE,
  i_name  IN  sungjuk.name%TYPE,
  i_kuk IN sungjuk.kuk%TYPE DEFAULT 0,
  i_eng IN sungjuk.eng%TYPE DEFAULT 0,
  i_rpt IN sungjuk.rpt%TYPE DEFAULT '������'
)
IS
    -- ���ν��������� ���Ǵ� ���� ���� ���
  v_tot sungjuk.tot%TYPE;
  v_pye   sungjuk.pye%TYPE;
  v_opt sungjuk.opt%TYPE;
BEGIN
  log_write('INSERT INTO SUNGJUK(num, name, kuk, eng, tot, pye, rpt, opt) VALUES(' || i_num ||',' || i_name ||'...');
 
  v_tot := i_kuk + i_eng; -- ����
  v_pye := v_tot / 2;    -- ���
 
  IF i_rpt='����' THEN    -- report ���� ���ο� ���� ���� ����
    v_opt := 10;
  ELSE
    v_opt := 0;
  END IF;
 
  -- ���� �߰�
  INSERT INTO sungjuk(num, name, kuk, eng, tot, pye, rpt, opt) 
  VALUES(i_num, i_name, i_kuk, i_eng, v_tot, v_pye, i_rpt, v_opt);
 
  -- Ʈ����� ����
  COMMIT;
END insert_sungjuk;
/
 
 
 
DECLARE
BEGIN
    insert_sungjuk(4, '������4', 90, 80, '����');
    insert_sungjuk(5, '������5', 90, 80, '������');
END;
/
 
 
SELECT * FROM logTable ORDER BY log_date DESC;
 
SELECT * FROM sungjuk ORDER BY num ASC;
  
  
4. ������ ����ϴ� ���ν���
 
CREATE OR REPLACE PROCEDURE p_select_sungjuk
(
  i_num IN sungjuk.num%TYPE
)
IS
  v_name sungjuk.name%TYPE;
  v_kuk sungjuk.kuk%TYPE;
  v_eng sungjuk.eng%TYPE;
  v_tot sungjuk.tot%TYPE;
  v_pye       sungjuk.pye%TYPE;
  v_rpt sungjuk.rpt%TYPE;
  v_opt sungjuk.opt%TYPE;
BEGIN
  log_write('SELECT name, kuk, eng, tot, pye, rpt, opt FROM  sungjuk WHERE num = ' || i_num);
 
  DBMS_OUTPUT.ENABLE;
 
  SELECT name, kuk, eng, tot, pye, rpt, opt
  INTO v_name, v_kuk, v_eng, v_tot, v_pye, v_rpt, v_opt -- ������ ����
  FROM  sungjuk   
  WHERE num = i_num;
 
  DBMS_OUTPUT.PUT_LINE('��ȸ�� ������');
  DBMS_OUTPUT.PUT_LINE('��ȣ:' || i_num);
  DBMS_OUTPUT.PUT_LINE('����:' || v_kuk);  
  DBMS_OUTPUT.PUT_LINE('����:' || v_eng);
  DBMS_OUTPUT.PUT_LINE('����:' || v_tot);
  DBMS_OUTPUT.PUT_LINE('���:' || v_pye);
  DBMS_OUTPUT.PUT_LINE('����Ʈ����:' || v_rpt);
  DBMS_OUTPUT.PUT_LINE('�߰�����:' || v_opt);
END p_select_sungjuk;
/
 
 
BEGIN
    p_select_sungjuk(2);
END;
/
  
 
5. ������ update�ϴ� ���ν���
   - Ư�� �л��� ��ȣ�� ������ �Է¹޾� Update�� �մϴ�.
 
CREATE OR REPLACE PROCEDURE update_sungjuk
(
    -- �Է� �Ķ����
  i_num IN sungjuk.num%TYPE,
  i_name  IN  sungjuk.name%TYPE,
  i_kuk IN sungjuk.kuk%TYPE DEFAULT 0,
  i_eng IN sungjuk.eng%TYPE DEFAULT 0,
  i_rpt IN sungjuk.rpt%TYPE DEFAULT '������'  
)
IS
    -- ���� ����
  v_tot sungjuk.tot%TYPE;
  v_pye   sungjuk.pye%TYPE;
  v_opt sungjuk.opt%TYPE;
BEGIN
  v_tot := i_kuk + i_eng;
  v_pye := v_tot / 2;
 
  IF i_rpt='����' THEN
    v_opt := 10;
  ELSE
    v_opt := 0;
  END IF;
 
  log_write('UPDATE sungjuk SET kuk = ' || i_kuk || ', eng = '|| i_eng || ', tot = ' || v_tot || ', pye = ' || v_pye || '.....WHERE num = ' || i_num);
 
  UPDATE sungjuk 
  SET name = i_name, kuk = i_kuk, eng = i_eng, tot = v_tot
     , pye = v_pye, rpt = i_rpt, opt = v_opt 
  WHERE num = i_num;
 
  COMMIT;
 
END update_sungjuk;
/
 
 
-- exec update_sungjuk(1, '�����̳�', 100, 100, '������');
BEGIN
    update_sungjuk(2, '�����̳�', 100, 100, '������');
END;
/
 
SELECT * FROM logTable ORDER BY log_date DESC;
 
SELECT * FROM sungjuk ORDER BY num DESC;
 
 
6. ������ �����ϴ� ���ν���
 
CREATE OR REPLACE PROCEDURE del_num
(
    i_num IN sungjuk.num%TYPE -- �й� �Է� ����
)
IS
BEGIN
    log_write('DELETE FROM sungjuk WHERE num =' || i_num);
 
    DELETE FROM sungjuk WHERE num = i_num;
 
    COMMIT;
END del_num;
/
 
 
 
-- exec del_num(1);
DECLARE
BEGIN
    del_num(1);
END;
/
    
 
 
SELECT * FROM sungjuk;
 
-- 1�� �л��� ���� �����ڸ� ����մϴ�.
SELECT * FROM logTable;
   
  
-------------------------------------------------------------------------------------