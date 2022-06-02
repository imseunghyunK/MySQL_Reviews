-- 4.selectGroupFunction.sql
-- 그룹함수란? 다수의 행 데이터를 한번에 처리
-- 장점 : 함수 연산시 null 데이터를 함수 내부적으로 사전에 고려해서 null값 보유한 field는 함수 로직 연산시 제외,
-- 		 sql 문장 작업 용이

/*
1. count() : 개수 확인 함수
2. sum() : 합계 함수
3. avg() : 평균
4. max(), min() : 최대값, 최소값 
*/
 
/* 기본 문법
1. select절
2. from 절
3. where절 

 * 그룹함수시 사용되는 문법
1. select절 : 검색하고자 하는 속성
2. from절	: 검색 table
3. group by 절 : 특정 조건별 그룹화하고자 하는 속성
4. having 절 : 그룹함수 사용시 조건절
5. order by절 : 검색된 데이터를 정렬
*/

-- 1. count() : 개수 확인 함수
-- emp table의 직원이 몇명?
-- 14개의 row를 취합해서 14개라는 숫자값 하나 단일로 검색 따라서 그룹함수
select count(*) from emp;

-- 14명의 row값으로 14개의 결과값 즉 row별 1:1로 검색 단일행 함수
select ename, length(ename) from emp;

-- comm 받는 직원 수만 검색
select job, comm from emp;

-- null 데이터를 보유한 row는 에러가 아니라 그룹함수에서 필터링
select count(comm) from emp; -- 4

-- 오라클은 문법 불허, mysql 논리적인 오류
select ename, count(comm) from emp; -- 4
select ename from emp;

-- 2. sum() : 합계 함수
-- 모든 사원의 월급여(sal)의 합
select sal from emp;
select sum(sal) from emp;

-- 모든 직원이 받는 comm 합
select sum(comm) from emp;

--  MANAGER인 직원들의  월급여의 합 
select sum(sal) from emp where job = 'MANAGER';

-- job 종류 counting[절대 중복 불가 = distinct]
-- 데이터 job 확인
select job from emp;
select distinct job from emp;
select count(distinct job) from emp;


-- 3. avg() : 평균
-- emp table의 모든 직원들의 급여(sal) 평균 검색
select avg(sal) from emp; 


-- 커미션 받는 사원수(count()), 총 커미션 합(sum()), 커미션 평균(avg()) 구하기
select count(comm), sum(comm), avg(comm) from emp e; 

-- 4. max(), min() : 최대값, 최소값
-- 숫자, date 타입에 사용 가능
-- 최대 급여, 최소 급여 검색
select ename, sal, hiredate from emp;

select max(sal), min(sal) from emp;  

-- ?최근 입사한 사원의 입사일과, 가장 오래된 사원의 입사일 검색
-- 오라클의 date 즉 날짜를 의미하는 타입도 연산 가능
-- max(), min() 함수 사용해 보기
select max(hiredate) as 신입, min(hiredate) as 고참 from emp;  

-- *** 
/* group by절
- 특정 컬럼값을 기준으로 그룹화
	가령, 10번 부서끼리, 20번 부서끼리..
*/
-- 부서별 커미션 받는 사원수 
-- select deptno, count(comm) from emp; 오류
-- 함수를 미 적용하는 컬럼까지 검색시에는 반드시 groub by절에 명시 필수
select deptno, count(comm) from emp; -- 논리적이 오류, 오라클,mac인 경우 문법 오류

select deptno, comm from emp; -- 부서별 comm 확인

-- 모범 답안
select deptno, count(comm)
from emp e
group by deptno;


-- deptno 오름차순(asc) 정렬 추가
-- 존재하는 table에서 부서별 그룹핑 후에 부서별 
-- 커미션 개수 파악 후에 부서번호 정렬
-- 실행 순서 : from -> select deptno만 검색 -> group by -> select count() -> order by
-- 컬럼에 별칭 부여
select deptno, count(comm)
from emp e
group by deptno
order by deptno asc;

select deptno, count(comm)
from emp e
group by deptno
order by deptno desc;

-- 부서별(group by deptno) (월급여) 평균 구함(avg())(그룹함수 사용시 부서 번호별로 그룹화 작업후 평균 연산)
select deptno, avg(sal)
from emp e 
group by deptno ;

-- 소속 부서별 급여 총액과 평균 급여 검색[deptno 오름차순 정렬]
select deptno, sum(sal), avg(sal)
from emp e 
group by deptno 
order by deptno desc;

-- 소속 부서별 최대 급여와 최소 급여 검색[deptno 오름차순 정렬]
-- 컬럼명 별칭에 여백 포함한 문구를 사용하기 위해서는 쌍따옴표로만 처리
select deptno as 부서, max(sal) as "최대 급여", min(sal) as "최소 급여"
from emp e 
group by deptno
order by deptno desc;


-- *** having절 *** [ 조건을 주고 검색하기 ]
-- 그룹함수 사용시 조건문

-- 1. 부서별(group by) 사원의 수(count(*))와 커미션(count(comm)) 받는 사원의 수
-- 집계(그룹) 함수는 null은 자동 제거
select deptno, count(*), count(comm)
from emp e
group by deptno;

-- 조건 추가
-- 2. 부서별 그룹을 지은후(group by deptno), 
-- 부서별(deptno) 평균 급여(avg())가 2000 이상(>=)부서의 번호와 평균 급여 검색 
select deptno, count(*), count(comm), avg(sal) 
from emp e
group by deptno
having avg(sal) >= 2000;

select deptno, count(*), count(comm), avg(sal) 
from emp e
group by deptno;

-- deptno 내림차순
select deptno, count(*), count(comm), avg(sal) 
from emp e
group by deptno
having avg(sal) >= 2000
order by deptno desc;

-- group 함수 문장속 조건문은 having절로 적용
-- 실행 순서 : from -> group by -> having -> select -> order by

-- mysql 정상 실행
	-- from -> select -> group by -> select -> having -> order by
-- oracle 실행 결과 : SQL Eroor [904] [42000]: ORA-00904: "평균": invalid identifier
	--  SQL Eroor [904] [42000]: ORA-00904: "D": invalid identifier
	-- from -> group by -> having -> select -> order by
select deptno as d, avg(sal) as 평균
from emp e
group by deptno
having 평균 >= 2000
order by deptno desc;

-- 3. 부서별(group by) 급여중 최대값(max(sal))과 최소값(min(sal))을 구하되 
-- 최대 급여(max(sal))가 2900이상(having  >= )인 부서만 출력
select deptno, max(sal), min(sal)
from emp e 
group by deptno 
having max(sal) >= 2900; 

