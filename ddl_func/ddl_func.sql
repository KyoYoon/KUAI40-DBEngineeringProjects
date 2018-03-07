-------------------------------------------------------------------------------------
1. 테이블 구조
 
DROP TABLE itpay PURGE;
 
CREATE TABLE itpay(
    payno   NUMBER(7)   NOT NULL,  -- 1 ~ 9999999
    part    VARCHAR(20) NOT NULL,  -- 부서명
    sawon   VARCHAR(10) NOT NULL,  -- 사원명
    age     NUMBER(3)   NOT NULL,  -- 나이, 1 ~ 999
    address VARCHAR(50) NOT NULL,  -- 주소
    month   CHAR(6)     NOT NULL,  -- 급여달, 200805
    gdate   DATE        NOT NULL,  -- 수령일
    bonbong NUMBER(8)   DEFAULT 0, -- 본봉  
    tax     NUMBER(7, 2)   DEFAULT 0, -- 세금, 전체 자리, +-99999.99
    bonus   NUMBER(7)       NULL,  -- 보너스
    family  NUMBER(7)       NULL,  -- 가족 수당
    PRIMARY KEY(payno)
);
 
 
2. 기초 데이터 추가
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(1, '디자인팀', '가길동', 27, '경기도 성남시',
       '200801', sysdate, 1530000, 12345.67, 0);
       
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(2, '디자인팀', '나길동', 30, '인천시 계양구',
       '200801', sysdate-5, 1940000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(3, '개발팀', '다길동', 34, '경기도 성남시',
       '200801', sysdate-3, 2890000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(4, '개발팀', '라길동', 36, '경기도 부천시',
       '200802', sysdate-1, 4070000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(5, 'DB설계팀', '마길동', 38, '경기도 부천시',
       '200802', sysdate-0, 2960000, 0, 0);
 
SELECT * FROM itpay;
 
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(6, '기획설계팀', '바길동', 40, '서울시 강서구',
       '200802', sysdate-0, 3840000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(7, '개발팀', '사길동', 42, '인천시 계양구',
       '200803', sysdate-0, 4230000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(8, 'DB설계팀', '김길동', 42, '경기도 부천시',
       '200803', sysdate-1, 4010000, 0, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax, bonus)
VALUES(9, 'DB설계팀', '이길동', 42, '서울시 강서구',
       '200803', sysdate-1, 3500000, 0, 0);
 
SELECT * FROM itpay;
 
 
-- null 컬럼값 추가
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax)
VALUES(10, '개발팀', '신길동', 33, '서울시 관악구',
       '200804', sysdate, 3500000, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax)
VALUES(11, '개발팀', '최길동', 31, '서울시 관악구',
       '200804', sysdate, 4500000, 0);
 
INSERT INTO itpay(payno, part, sawon, age, address,
                  month, gdate, bonbong, tax)
VALUES(12, '개발팀', '마길동', 29, '서울시 관악구',
       '200804', sysdate, 3200000, 0);
 
 
SELECT * FROM itpay;
 
 
2. 컬럼 추가
 
ALTER TABLE itpay
ADD (test VARCHAR2(9));
 
DESCRIBE itpay;
 
 
3. 컬럼 속성 수정
 
ALTER TABLE itpay
MODIFY (test VARCHAR2(30));
 
 
4. 컬럼명 수정
ALTER TABLE itpay
RENAME COLUMN test to test2;
 
 
5. 컬럼 삭제
ALTER TABLE itpay
DROP COLUMN test2;
 
 
6. 테이블 삭제
 
DROP TABLE itpay;
 
-- DROP TABLE itpay PURGE; -- 테이블 완전 삭제
 
 
7. 테이블 복구
FLASHBACK TABLE itpay TO BEFORE DROP; -- Standard Edition은 이 문장이 실행가능 
 
SELECT * FROM itpay;
 
 
8. 휴지통 비우기
- 삭제된 테이블 완전 삭제, 복구 불가능
 
PURGE RECYCLEBIN;
  
  
  
[02] Single-Row Function(단일행 함수)
     - 레코드 단위로 함수가 적용 됩니다.
    
1. UPPER, LOWER
 
-- 소문자로 변경
SELECT payno, LOWER(part), sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
-- 대문자로 변경
SELECT payno, UPPER(part), sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
2. CONCAT
SELECT payno, CONCAT(part, '-' || sawon) as name, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
3. SUBSTR, index는 1부터 시작
-- 3번째 문자이후부터 출력
SELECT payno, SUBSTR(address, 5),
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
-- 1~3번째 문자 출력
SELECT payno, SUBSTR(address, 1, 3),
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
-- 2번째 문자부터 4문자 출력
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
 
 
5. INSTR, index는 1부터 시작
SELECT payno, address, INSTR(address, '천') as idx,
       month, gdate, bonbong, tax, bonus
FROM itpay
ORDER BY sawon ASC;
 
 
6. LPAD, RPAD 참고
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
- REPLACE(컬럼명, 변경할 문자열, 최종 변경된 문자열)
SELECT payno, address, REPLACE(address, '계양구','남동구') as ADDR,
       month, gdate, bonbong, tax, bonus
FROM itpay
WHERE address LIKE '%인천%'
ORDER BY sawon ASC;
 
 
8. ROUND
-- 소수 둘째 자리까지 반올림
SELECT ROUND(55.634, 2), ROUND(55.635, 2)
FROM dual;
 
-- 정수 영역 반올림
-- -1: 1의 자리, -2: 10의 자리에서 반올림
-- 반올림 안됨
SELECT ROUND(23541, -1), ROUND(23541.25, -2)
FROM dual;
 
-- 반올림됨.
SELECT ROUND(23551, -1), ROUND(23551.25, -2)
FROM dual;
 
 
9. TO_CHAR(): 날짜의 출력 및 비교
-- 현재 날짜 출력
SELECT sysdate FROM dual;
 
-- 2008-05-19일에 급여를 받는 사람 출력
SELECT gdate, SUBSTR(gdate, 1, 10)
FROM itpay;
 
SELECT gdate, TO_CHAR(gdate, 'yyyy-mm-dd')
FROM itpay;
 
 
-- 형식 적용
SELECT gdate, TO_CHAR(gdate, 'yyyy-mm-dd hh:mi:ss') as newgdate
FROM itpay;
 
 
-- TO_CHAR() 함수를 통한 문자열 형변환
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
WHERE TO_CHAR(gdate, 'yyyy-mm-dd') = '2018-02-28';
 
 
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, bonus
FROM itpay
WHERE TO_CHAR(gdate, 'yyyy-mm-dd hh24') = '2018-02-28 10'; -- 현재 시간 기준으로 조회 (현재 11시가 안 되었으므로 10으로 실행하면 됨)
  
  
10. 두 날짜 사이의 차 출력
    - sysdate+1: 오늘 날짜에 1일을 더함
 
SELECT MONTHS_BETWEEN(sysdate+1, sysdate) 
FROM dual;
 
SELECT MONTHS_BETWEEN(sysdate+31, sysdate) 
FROM dual;
 
 
11. 월 더하기
SELECT ADD_MONTHS(sysdate, 1) FROM dual;
 
 
12. 돌아오는 월요일의 날짜 출력
SELECT NEXT_DAY(sysdate, '월요일') FROM dual;
 
 
13. 이번달의 마지막날 출력
SELECT LAST_DAY(sysdate) FROM dual;
 
 
14. TO_CHAR
SELECT TO_CHAR(sysdate, 'yyyy-mm-dd hh:mi:ss') 
FROM dual;
 
SELECT TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss') 
FROM dual;
 
-- 나머지 문자열 0으로 채움
SELECT TO_CHAR(1500, '0999999') FROM dual;
 
-- 출력 형식보다 값이 크면 '# 출력
SELECT TO_CHAR(150000, '9,999') FROM dual;
 
-- 천단위 구분자 출력
SELECT TO_CHAR(150000, '999,999') FROM dual;
 
-- 부호 출력
SELECT TO_CHAR(150000, 'S999,999') FROM dual;
 
SELECT TO_CHAR(-150000, 'S999,999') FROM dual;
 
SELECT TO_CHAR(1500.55, '9,999.99') FROM dual;
 
SELECT TO_CHAR(1500.55, '9,999.9') FROM dual;
 
-- 소수점 자동 반올림.
SELECT TO_CHAR(1500.5, '9,999.999') FROM dual;
 
 
15 NVL 함수
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, bonus,
       family
FROM itpay;
 
-- null이 아니면 컬럼 값을 그대로 사용하나 
-- null이면 값을 0으로 변경
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax, 
       NVL(bonus, 0) + 500000 as bonus,
       NVL(family, 0)
FROM itpay;
 
 
16. TRUNC() 함수를 이용한 소수점 이하 삭제
 
-- 정수만 출력
SELECT TRUNC(tax, 0)
FROM itpay;
 
-- 소수 첫째 자리만 출력, 반올림 안됨
SELECT TRUNC(tax, 1)
FROM itpay;
 
-- 10의자리부터 출력, 1의자리 이하 삭제, 반올림 안됨
SELECT TRUNC(tax, -1)
FROM itpay;
 
-- 12,340
SELECT TO_CHAR(TRUNC(tax, -1), '9,999,999')
FROM itpay;

SELECT * FROM itpay; 
 
17. CASE 문
SELECT payno, part, sawon, age, address,
       month, gdate, bonbong, tax,
       CASE part WHEN '개발팀' THEN 0.5*bonbong
                 WHEN 'DB설계팀' THEN 0.4*bonbong
                 WHEN '디자인팀' THEN 0.3*bonbong
       ELSE 0.1*bonbong END bonus
FROM itpay;
 
 
-------------------------------------------------------------------------------------