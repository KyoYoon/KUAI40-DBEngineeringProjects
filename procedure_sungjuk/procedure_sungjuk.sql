▷ procedure_sungjuk.sql
-------------------------------------------------------------------------------------
 
1. 기본 테이블 구조 만들기
 
-- 성적
DROP TABLE sungjuk PURGE;
 
CREATE TABLE sungjuk
(
  num  number(3)    not null,   -- 일련번호
  name varchar2(20) not null,   -- 성명
  kuk number(3)    not null,   -- 국어
  eng number(3)    not null,   -- 영어
  tot number(3)    null,       -- 총점
  pye number(3)    null,       -- 평균
  rpt varchar(10)  null,      -- 레포트 제출 여부(제출, 미제출)
  opt number(3)    null,       -- 레포트 제출 점수
  PRIMARY KEY(num)
);
 
 
INSERT INTO sungjuk(num, name, kuk, eng) VALUES(1, '기획자', 90, 80);
INSERT INTO sungjuk(num, name, kuk, eng) VALUES(2, '설계자', 100, 80);
INSERT INTO sungjuk(num, name, kuk, eng) VALUES(3, '개발자', 90, 100);
COMMIT;
 
 
-- 쿼리 실행 정보 테이블
DROP TABLE logTable PURGE;
 
CREATE TABLE logTable
(
    logtableno NUMBER(7),        -- 일련 번호
    user_id   VARCHAR2(20),     -- 쿼리 실행 아이디, 접속자 아이디
    log_date   DATE,             -- 쿼리 실행 날짜
    query      VARCHAR2(1000),   -- SQL 쿼리문
    PRIMARY KEY (logtableno)
);
  
  
2. 쿼리 실행 정보를 저장하는 프로시저. DBMS 접근 기록을 보관
- sysdate: 날짜
- user: 접속한 계정
 
SELECT user, sysdate FROM dual;
 
USER                           SYSDATE
------------------------------ --------
SOLDESK                        17/12/01
 
 
CREATE OR REPLACE PROCEDURE log_write
(
     i_query IN logTable.query%TYPE -- 입력 파라미터
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
 
 
3. 성적을 입력하는 프로시저
 
CREATE OR REPLACE PROCEDURE insert_sungjuk
(
    -- 입력값 목록
  i_num IN sungjuk.num%TYPE,
  i_name  IN  sungjuk.name%TYPE,
  i_kuk IN sungjuk.kuk%TYPE DEFAULT 0,
  i_eng IN sungjuk.eng%TYPE DEFAULT 0,
  i_rpt IN sungjuk.rpt%TYPE DEFAULT '미제출'
)
IS
    -- 프로시저내에서 사용되는 지역 변수 목록
  v_tot sungjuk.tot%TYPE;
  v_pye   sungjuk.pye%TYPE;
  v_opt sungjuk.opt%TYPE;
BEGIN
  log_write('INSERT INTO SUNGJUK(num, name, kuk, eng, tot, pye, rpt, opt) VALUES(' || i_num ||',' || i_name ||'...');
 
  v_tot := i_kuk + i_eng; -- 총점
  v_pye := v_tot / 2;    -- 평균
 
  IF i_rpt='제출' THEN    -- report 제출 여부에 따라 점수 결정
    v_opt := 10;
  ELSE
    v_opt := 0;
  END IF;
 
  -- 성적 추가
  INSERT INTO sungjuk(num, name, kuk, eng, tot, pye, rpt, opt) 
  VALUES(i_num, i_name, i_kuk, i_eng, v_tot, v_pye, i_rpt, v_opt);
 
  -- 트랜잭션 적용
  COMMIT;
END insert_sungjuk;
/
 
 
 
DECLARE
BEGIN
    insert_sungjuk(4, '개발자4', 90, 80, '제출');
    insert_sungjuk(5, '개발자5', 90, 80, '미제출');
END;
/
 
 
SELECT * FROM logTable ORDER BY log_date DESC;
 
SELECT * FROM sungjuk ORDER BY num ASC;
  
  
4. 성적을 출력하는 프로시저
 
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
  INTO v_name, v_kuk, v_eng, v_tot, v_pye, v_rpt, v_opt -- 변수에 저장
  FROM  sungjuk   
  WHERE num = i_num;
 
  DBMS_OUTPUT.PUT_LINE('조회된 데이터');
  DBMS_OUTPUT.PUT_LINE('번호:' || i_num);
  DBMS_OUTPUT.PUT_LINE('국어:' || v_kuk);  
  DBMS_OUTPUT.PUT_LINE('영어:' || v_eng);
  DBMS_OUTPUT.PUT_LINE('총점:' || v_tot);
  DBMS_OUTPUT.PUT_LINE('평균:' || v_pye);
  DBMS_OUTPUT.PUT_LINE('레포트제출:' || v_rpt);
  DBMS_OUTPUT.PUT_LINE('추가점수:' || v_opt);
END p_select_sungjuk;
/
 
 
BEGIN
    p_select_sungjuk(2);
END;
/
  
 
5. 성적을 update하는 프로시저
   - 특정 학생의 번호와 점수를 입력받아 Update를 합니다.
 
CREATE OR REPLACE PROCEDURE update_sungjuk
(
    -- 입력 파라미터
  i_num IN sungjuk.num%TYPE,
  i_name  IN  sungjuk.name%TYPE,
  i_kuk IN sungjuk.kuk%TYPE DEFAULT 0,
  i_eng IN sungjuk.eng%TYPE DEFAULT 0,
  i_rpt IN sungjuk.rpt%TYPE DEFAULT '미제출'  
)
IS
    -- 내부 변수
  v_tot sungjuk.tot%TYPE;
  v_pye   sungjuk.pye%TYPE;
  v_opt sungjuk.opt%TYPE;
BEGIN
  v_tot := i_kuk + i_eng;
  v_pye := v_tot / 2;
 
  IF i_rpt='제출' THEN
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
 
 
-- exec update_sungjuk(1, '디자이너', 100, 100, '미제출');
BEGIN
    update_sungjuk(2, '디자이너', 100, 100, '미제출');
END;
/
 
SELECT * FROM logTable ORDER BY log_date DESC;
 
SELECT * FROM sungjuk ORDER BY num DESC;
 
 
6. 성적을 삭제하는 프로시저
 
CREATE OR REPLACE PROCEDURE del_num
(
    i_num IN sungjuk.num%TYPE -- 학번 입력 받음
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
 
-- 1번 학생을 지운 접속자를 출력합니다.
SELECT * FROM logTable;
   
  
-------------------------------------------------------------------------------------