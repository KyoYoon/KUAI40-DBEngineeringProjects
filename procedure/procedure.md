# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## PL/SQL의 이해, PL/SQL의 종류, PL/SQL의 구조, Script

1. SQL의 장점
   - 사용자가 이해하기 쉬운 명령어로 구성
   - 쉽게 배울 수 있다.
   - 복잡한 로직을 간단하게 작성할 수 있다.
   - ANSI에 의해 문법이 표준화 되어 있다.


2. SQL의 단점
   - 반복처리를 할 수 없다.
   - 비교처리를 할 수 없다.
   - Error 처리를 할 수 없다.
   - SQL 문을 캡슐화 할 수 없다.
   - 변수 선언을 할 수 없다.
   - 실행할 때 마다 분석작업 후 실행함으로 속도가 느립니다.
   - Application Server에서 DBMS서버로 반복해서 SQL이 전송됨으로 불필요한
     Network Traffic을 유발한다.


3. PL(Procedural Language) SQL
   - 반복처리를 할 수 있다.
   - 비교처리를 할 수 있다..
   - Error 처리를 할 수 있다.
   - SQL 문을 캡슐화 할 수 있다.
   - 변수 선언을 할 수 있다.
   - 실행할 때 마다 분석된 결과를 실행만 하기 때문에 속도가 빠르다.
   - Application간에 발생하는 트래픽을 최소화 할 수 있으며 안정적인 트랜잭션을
     실현하는 데 도움을 줍니다.


4. PL/SQL의 구조

   DECLARE
   - 선언부: 각종 변수 선언
   :
   :
   :
   BEGIN
   - 실행문 기술: SQL, 비교문, 제어문, 커서 속성 기술
   :
   :
   :
   EXCEPTION
   - 실행문을 처리하던중 발생하는 예외처리 기술
   :
   :
   :
   END;
   /



[02] PL/SQL의 종류

1. Anonymous Procedure
   - PL/SQL 구문을 작성하여 필요할 때 마다 임시로 사용하며 서버에 저장은 되지 않습니다.


2. Stored Procedure
   - 저장 프로시저로 INSERT, DELETE, UPDATE, SELECT 위주의 쿼리가
     서버에 저장되어 복잡한 쿼리를 구조적으로 구현 할 수 있습니다.


3. Stored Function
   - Stored Procedure는 처리만 하고 끝나지만 Stored Function은 처리결과를 리턴합니다.


4. Package
   - 시간이 흐를 수록 누적되는 Stored Procedure, Stored Function을 그룹으로
     묶어 처리함을써 처리 효율을 증가 할 수 있습니다.


5. Trigger
   - 데이터베이스 보안, 감시, 연속적인 데이터 처리작업을 동적으로 구현할 수 있는 기술입니다.



[03] 스크립트 문법
   - 식별자(변수)는 30문자를 초과할 수 없습니다.
   - 식별자는 테이블, 컬럼명과 동일 할 수 없습니다.
   - 식별자는 반드시 문자값으로 시작해야 합니다.
   - 문자와 날짜는 " ' " 인용부호를 이용합니다.
   - 주석은 "--", 여러라인 주석은 "/* */을 이용합니다.


★ Toad SQL Editor에서 "Turn Output On"선택하고 실행합니다.

-------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;


1. 비교문

DECLARE
    v_condition number := 1;
BEGIN
    IF v_condition = 1 THEN
        DBMS_OUTPUT.PUT_LINE('데이터의 값은 1입니다.');
    END IF;
END;
/



DECLARE
    v_condition number :=2;
BEGIN
    IF v_condition > 1 THEN
        DBMS_OUTPUT.PUT_LINE('데이터의 값은 1보다 큽니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('데이터의 값은 1보다 작습니다.');
    END IF;
END;
/



DECLARE
    v_condition number :=2;
BEGIN
    IF v_condition > 1 THEN
        DBMS_OUTPUT.PUT_LINE('데이터의 값은 1보다 큽니다.');
    ELSIF v_condition = 1 THEN
        DBMS_OUTPUT.PUT_LINE('데이터의 값은 1입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('데이터의 값은 1보다 작습니다.');
    END IF;
END;
/



2. 반복문

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
    FOR i IN 1..10 LOOP         -- i 변수의 값이 1부터 10까지 증가
        IF (MOD(i, 2) = 1) THEN -- 홀수만 출력
            DBMS_OUTPUT.PUT_LINE(i);
        END IF;
    END LOOP;
END;
/



DECLARE
    v_cnt number := 0;
    v_str varchar2(10) := null;
BEGIN
    WHILE v_cnt <= 10 LOOP     -- v_cnt 10보다 작거나 같을 동안 실행
        v_cnt := v_cnt+1;
        DBMS_OUTPUT.PUT_LINE(v_cnt);
    END LOOP;
END;
/


-------------------------------------------------------------------------------------
