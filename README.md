# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## 1. DB Engineering의 의미와 목적
* 컴퓨터, 스마트폰, 태블릿을 통해 실행되는 모든 소프트웨어는 데이터베이스의 데이터를 기반으로 동작하고 DB Engineering (Database Engineering)은 이러한 데이터베이스를 설계하는 기법을 말한다.
* DB Engineering을 하기 위해서는 데이터베이스의 개념과 데이터베이스 중에서도 관계형 데이터베이스(Relational Database Management System / RDBMS)가 어떻게 쓰이는지 이해해야 하며, 데이터베이스의 데이터를 관리하기 위한 SQL이 무엇인지 알고 있어야 한다.

## 2. Database(데이터베이스) 와 SQL
* [데이터베이스](https://ko.wikipedia.org/wiki/%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4)는 데이터를 저장하기 위한 저장소를 말하며, [관계형 데이터베이스](https://ko.wikipedia.org/wiki/%EA%B4%80%EA%B3%84%ED%98%95_%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4)는 데이터를 행(Row)과 열(Column)로 이루어진 키와 값으로 정의한 테이블을 관리하는 저장소이며 테이블의 각 행은 고유 키(Primary Key)를 통해 접근 가능하며 이를 레코드(Record)라고 부른다. [SQL](https://ko.wikipedia.org/wiki/SQL)은 Structured Query Language 의 준말로 데이터베이스의 데이터를 테이블 단위로 접근 및 관리하기 위한 특수 목적의 프로그래밍 언어이다.

## 3. 사용되는 관계형 데이터베이스 종류
* [Oracle 11g XE (개발자 버전)](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)을 사용함

## 4. 세부 강의
* [DDL(Data Definition Language): 테이블 생성, 구조 수정, 삭제](/ddl_func/ddl_func.md)
* [GROUP BY, HAVING, Group Functions(그룹화 함수), SubQuery](/group_subquery/group_subquery.md)
* [Transaction, Sequence, Index](/transaction/transaction.md)
* [VIEW](/view/view.md)
* [CREATE ~ SELECT, INSERT ~ SELECT, 제약 조건의 조회, 추가, 삭제](/insert_c/insert_c.md)
* [PL/SQL의 이해, PL/SQL의 종류, PL/SQL의 구조, Script](/procedure/procedure.md)
* [Stored Procedure Create & Execution - IN/OUT 매개변수](/procedure_exam/procedure_exam.md)
* [Stored Procedure INSERT, SELECT, UPDATE, DELETE의 이용(sungjuk)](/procedure_sungjuk/procedure_sungjuk.md)
* [Stored Function, Trigger](/function_trigger/function_trigger.md)
* [Trigger 실습 - 매출액 관리](/trigger_exam/trigger_exam.md)
