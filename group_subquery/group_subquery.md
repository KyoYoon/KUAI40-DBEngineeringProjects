# KUAI40-DBEngineeringProjects
[KU-AI 4.0] 예지정비와 생산 모니터링을 위한 Smart Factory 개발자 과정 - DB Engineering (SQL 및 Table 설계 및 관계 기초)

## GROUP BY, HAVING, Group Functions(그룹화 함수), SubQuery (Reporting Aggregated Data Using the Group Functions)
* 다수의 레코드가 함수를 거쳐 하나의 결과 값을 발생합니다.
* SQL 구현 순서: SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY 순으로 기술
* 참고파일: group_subquery.sql

-------------------------------------------------------------------------------------

1. AVG(), MAX(), MIN(), SUM()
SELECT * FROM itpay;

SELECT AVG(bonbong) as 평균, MAX(bonbong) as 최대값
           , MIN(bonbong) as 최소값, SUM(bonbong) as 합계
FROM itpay;


-- 그룹화 함수는 일반 컬럼과 같이 사용할 수 없습니다.
-- 어떤 사원에 대한 평균과 합계인지 구분이 모호함!!!
SELECT sawon, AVG(bonbong), SUM(bonbong)
FROM itpay;


2. 날짜 상에서의 MAX(), MIN()

SELECT * FROM itpay;

SELECT MAX(gdate), MIN(gdate) FROM itpay;

SELECT MAX(sawon), MIN(sawon) FROM itpay;


3. COUNT(), NULL 컬럼은 카운트에 포함이 되지 않습니다.

SELECT * FROM itpay;

SELECT COUNT(payno) FROM itpay;

SELECT COUNT(bonus) FROM itpay;

SELECT COUNT(*) FROM itpay;

-- NVL 함수를 이용하여 NULL 컬럼을 카운트 합니다.
-- null 값을 0으로 변경합니다.
SELECT COUNT(NVL(bonus, 0)) FROM itpay;


4. GROUP BY
-- 부서별 평균 급여를 출력하세요.
-- 어느부서의 평균 급여인지 모름으로 정보로써 가치가 없음.
SELECT AVG(bonbong)
FROM itpay
GROUP BY part;


-- GROUP BY문에 명시된 컬럼은 SELECT문에 출력할 수 있습니다.
SELECT part, AVG(bonbong)
FROM itpay
GROUP BY part;

SELECT * FROM itpay;

-- 부서별, 지역별 평균 급여를 출력하세요.
SELECT part, address, TRUNC(AVG(bonbong), -1) as pay
FROM itpay
GROUP BY part, address;


-- 부서별, 지역별 평균 급여를 구하여 부서별, 지역별로
-- 오름차순 출력하세요.
SELECT part, address, TRUNC(AVG(bonbong), -1) as bonbong
FROM itpay
GROUP BY part, address
ORDER BY part, address;

-- 동일한 부서에서 급여가 내림차순되도록 출력.
SELECT part, address, TRUNC(AVG(bonbong), -1) as bonbong
FROM itpay
GROUP BY part, address
ORDER BY part ASC, bonbong DESC;


6. GROUP BY문에 조건을 이용하기위한 HAVING절의 이용

-- 부서별 평균 급여가 300만원이 넘는 부서만 출력
-- 그룹함수 조건에 WHERE 절을 사용할 수 없습니다.ㅣ
SELECT part, TRUNC(AVG(bonbong), -1)
FROM itpay
GROUP BY part
HAVING AVG(bonbong) >= 3000000
ORDER BY part;

-- ERROR
SELECT part, TRUNC(AVG(bonbong), -1) as avg_bonbong
FROM itpay
GROUP BY part
HAVING avg_bonbong >= 3000000
ORDER BY part;


7. 함수의 중첩
-- 부서중에 평균 급여가 가장 높은 부서의 금액을 천단위이상 출력하세요.
SELECT TRUNC(MAX(AVG(bonbong)), -2)
FROM itpay
GROUP BY part;



[02] SubQuery

1. WHERE문에 서브쿼리의 사용

-- 개발팀의 평균 급여
SELECT AVG(bonbong)
FROM itpay
WHERE part='개발팀';


-- 개발팀의 평균 급여보다 급여가 많은 직원 출력
SELECT *
FROM itpay
WHERE bonbong >= (
                  SELECT AVG(bonbong)
                  FROM itpay
                  WHERE part='개발팀'
);


-- 개발팀의 평균 급여보다 급여가 낮은 직원들의 급여를
-- 20% 추가 지급
SELECT part, sawon, age, bonbong,
       bonbong * 0.2 as 추가금액, bonbong * 1.2 as 최종급여
FROM itpay
WHERE bonbong < (
                  SELECT AVG(bonbong)
                  FROM itpay
                  WHERE part='개발팀'
);

PART               |  SAWON    |     AGE         | BONBONG  | 추가금액 |  최종급여
-----------  |  -------- | ---------  | ---------- | ------ | ----------
디자인팀           |  가길동        |     27  |  1530000  |   306000  |  1836000
디자인팀          |   나길동        |     30  |  1940000  |   388000  |  2328000
개발팀             |  다길동         |    34 |   2890000  |   578000  |  3468000
DB설계팀         |   마길동       |      38  |  2960000  |   592000  |  3552000
DB설계팀         |    이길동     |      42 |    3500000  |   700000  |  4200000
개발팀            |   신길동      |       33  |  3500000   |  700000 |   4200000
개발팀           |    마길동     |        29 |    3200000  |   640000  |  3840000


-- 개발팀의 평균 급여보다 급여가 많은 직원들의 급여를
-- 10% 삭감 출력
SELECT part, sawon, age, bonbong,
       bonbong * 0.1 as 삭감금액, bonbong * 0.9 as 최종급여
FROM itpay
WHERE bonbong >= (
                  SELECT AVG(bonbong)
                  FROM itpay
                  WHERE part='개발팀'
);

PART           |  SAWON       |      AGE    | BONBONG  |  삭감금액  |  최종급여
---------  |  ---------- | ------- | --------- | -------- | ----------
개발팀           |  라길동          |   36  |  4070000   |  407000 |   3663000
기획설계팀     |  바길동          |   40  |  3840000   |  384000  |  3456000
개발팀           | 사길동           |  42  |  4230000   |  423000  |  3807000
DB설계팀       |  김길동         |    42  |  4010000  |   401000  |  3609000
개발팀            |  최길동         |   31  |  4500000   |  450000   |  4050000


2. 조건의 중첩

-- 가길동의 부서 출력
   SELECT part
   FROM itpay
   WHERE sawon='가길동'


-- 가길동과 같은 부서의 평균 급여 출력
   SELECT TRUNC(AVG(bonbong))
   FROM itpay
   WHERE part = (SELECT part
                 FROM itpay
                 WHERE sawon='가길동');


-- 가길동과 같은 부서에 근무하면서 그 부서의
-- 평균급여 보다 급여가 많은 직원 출력
   SELECT *
   FROM itpay
   WHERE
         (
         part = (
                  SELECT part
                  FROM itpay
                  WHERE sawon='가길동'
                  )
         )
         AND
         (
         bonbong > (
                     SELECT AVG(bonbong)
                     FROM itpay
                     WHERE part = (
                                          SELECT part
                                          FROM itpay
                                          WHERE sawon='가길동'
                                          )
                     )
         )


3. Subquery + ROWNUM 컬럼을 이용한 레코드 추출

SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus, rownum
FROM itpay;


-- rownum이 생성되고 난후 정렬됨으로 정보로서의 가치가 떨어짐
SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus, rownum
FROM itpay
ORDER BY sawon;


-- 먼저 정렬을 수행하고 rownum을 추가합니다.
SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus, rownum as r
FROM (
       SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus
       FROM itpay
       ORDER BY sawon
);


-- rownum 컬럼 값에 따른 레코드 추출, ERROR
SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus, rownum as r
FROM (
       SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus
       FROM itpay
       ORDER BY sawon
)
WHERE r >= 1 AND r <= 3;

-- ERROR
SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus, rownum as r
FROM (
       SELECT payno, part, sawon, age, address, month,
       gdate, bonbong, tax, bonus
       FROM itpay
       ORDER BY sawon
)
WHERE r >= 4 AND r <= 6;


-- rownum 컬럼 값에 따른 레코드 1~3 추출
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


-- rownum 컬럼 값에 따른 레코드 4~6 추출
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


4. IN의 사용: Subquery의 결과가 2개 이상일 경우 사용
   - 급여가 300만원 넘는 사람과 같은 나이를 가지고
     있는 직원의 급여 내역을 출력하세요.

-- 급여가 300만원이 넘는 직원의 나이를 출력합니다.
SELECT age
FROM itpay
WHERE bonbong >= 3000000;

-- 중복된 값의 제거
SELECT DISTINCT age
FROM itpay
WHERE bonbong >= 3000000;

-- 부서가 중복되어 출력
SELECT part
FROM itpay;

-- 중복된 부서의 제거 출력
SELECT DISTINCT part
FROM itpay;

SELECT payno, part, sawon, age, address
FROM itpay
WHERE age IN(27, 30);

SELECT payno, part, sawon, age, address
FROM itpay
WHERE address IN('인천시 계양구', '경기도 성남시');


-- 급여가 300만원이 넘는 직원의 나이와 일치하는 직원의 정보를 모두 출력합니다.
SELECT *
FROM itpay
WHERE age IN(
             SELECT DISTINCT age
             FROM itpay
             WHERE bonbong >= 3000000
            );


-------------------------------------------------------------------------------------
