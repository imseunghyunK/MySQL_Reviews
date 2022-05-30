/* 주의 사항
 * 1. 단일 line 주석 작성시 -- 와 내용 사이에 blank 필수
 * 
 * 2. DBeaver 접속 문제 발생시 해결책
 * 	userSSL false / allowPublicKeyRetrieval true 속성 추가 
 * 	https://earth-95.tistory.com/52
 * ----------------------------------
 * 문법 1 - 검색의 기본 문장
 * select절
 * from 절
 * 
 * 문법 2 - 정렬 검색
 * select 절
 * from 절
 * order by 절
 * 
 * 문법 3 - 조건 검색
 * select 절
 * from 절
 * where 절
 * 
 * 	
 */

-- mysql
-- id/pw - admin/playdata

-- database에 접속
use playdata;



-- 1. 해당 계정이 사용 가능한 모든 table 검색
show tables;

-- 2. emp table의 모든 내용(모든 사원(row), 속성(컬럼)) 검색
SELECT * FROM emp;

-- 3. emp의 구조 검색
desc emp;

-- 4. emp의 모든 사원의 사번(empno)만 검색
-- 검색된 결과의 컬럼에 별칭 부여 방법 : as 별칭
SELECT empno from emp;
SELECT empno as 사번 from emp;

-- 5. emp의 사번(empno), 이름(ename)만 검색
SELECT empno, ename from emp;

-- 6. emp의 사번(empno), 이름(ename)만 검색(별칭 적용)
SELECT empno as 사번, ename as 이름 from emp;

-- 7. 부서 번호(deptno) 검색
SELECT deptno from emp;

-- 8. 중복 제거된 부서 번호 검색
-- distinct : 중복 제거 명령어
SELECT DISTINCT deptno from emp;

-- 9. 8 + 오름차순 정렬(order by)해서 검색
-- 오름 차순 : asc  / 내림차순 : desc
-- deptno를 기준으로 내림차순 - order by deptno desc
-- deptno를 기준으로 오름차순 - order by deptno asc
SELECT DISTINCT deptno from emp order by deptno desc;
SELECT DISTINCT deptno from emp order by deptno asc;


-- 10. ? 사번(empno)과 이름(ename) 검색 단 사번은 내림차순(order by desc) 정렬
select empno, ename from emp order by empno desc;

-- 11. ? dept table의 deptno 값만 검색 단 오름차순(asc)으로 검색
select * from dept;
SELECT deptno from dept order by deptno asc;

-- 12. ? 입사일(hiredate) 검색, 
-- 입사일이 오래된 직원부터 검색되게 해 주세요
-- 고려사항 : date 타입도 정렬(order by) 가능 여부 확인
select hiredate from emp;

select hiredate from emp order by hiredate asc;

-- 13. ?모든 사원의 이름과 월 급여(sal)와 연봉 검색
SELECT ename, sal, sal from emp;
SELECT ename, sal, sal*12 from emp;
SELECT ename, comm, sal, sal*12 from emp;

-- null 값을 보유한 컬럼과 연산시 데이터 자체가 null이 되는 문제 발생
SELECT ename, comm, sal*12+comm from emp;

-- null 연산 재확인
SELECT sal, comm, sal+comm from emp;

-- 14. ?모든 사원의 이름과 월급여(sal)와 연봉(sal*12) 검색
-- 해결책 : comm이 null인 사원은 즉 0으로 치환 후에 연산
-- 모든 db는 지원하는 내장 함수 
-- null -> 숫자값으로 대체하는 함수 : IFNULL(null보유컬럼명, 대체값)
SELECT comm, IFNULL(comm, 0) from emp;

-- 모든 사원의 이름과 월급여(sal)와 연봉(sal*12)+comm 검색
select ename, sal, sal*12+ IFNULL(comm, 0) from emp;


-- *** 조건식 ***
-- 15. comm이 null인 사원들의 이름과 comm만 검색
-- where 절 : 조건식 의미
-- 중요 : comm is null
SELECT ename, comm from emp;

SELECT ename, comm 
FROM emp 
WHERE comm is null;

-- 16. comm이 null이 아닌 사원들의 이름과 comm만 검색
-- where 절 : 조건식 의미
-- 아니다 라는 부정 연산자 : not 
-- 중요 : comm is not null
SELECT ename, comm 
FROM emp 
WHERE comm is not null;

-- 17. ? 사원명이 스미스인 사원의 이름과 사번만 검색
-- 사원명(ename) 스미스(SMITH)인 사원의 이름(ename)과 사번(empno)만 검색
-- ename은 SMITH 여야만 함
-- 동등비교 연산자 : =
-- sql 상에서 문자열 데이터 표현 : '문자열 데이터'
SELECT ename from emp; -- SMITH

SELECT ename from emp where ename='SMITH';
SELECT ename, empno from emp where ename='SMITH';

-- 18. 부서번호가 10번 부서의 직원들 이름, 사번, 부서번호 검색
-- 부서번호가 10번(where deptno=10) 부서의 직원들 이름, 사번, 부서번호 검색
-- 단, 사번은 내림차순 검색
SELECT ename, empno, deptno from emp where deptno = 10 order by empno desc;

-- 19. ? 기본 syntax를 기반으로 
-- emp  table 사용하면서 문제 만들기
-- ? 부서 번호가 20번 부서의 직원들 이름, 사번, 부서번호, 월급, 연봉 검색
select ename, empno, sal, sal*12, deptno from emp where deptno = 20; 

-- ? 사원명, 사번, 부서번호, 연봉 검색 단 연봉은 내림차순 검색
SELECT ename, empno, deptno, sal*12 as 연봉 from emp order by 연봉 desc;

-- 20. 급여가 900이상인(sal >= 900) 사원들 이름, 사번, 월 급여 검색 
SELECT ename, empno, sal
from emp
where sal >= 900;

/* 데이터들은 대소문자가 매우 중요
 * ex) 회원 가입시 id값을 소문자로 작업 후 로그인 할 경우 소문자로만 100% 일치되어야만 로그인 성공
 * 
 * mysql은 대소문자 구분 없이 작업이 default
 * 해결점 1 : table 생성시 alter 명령어로 제약
 * 해결점 2 : sql문장 실행시 binary()함수를 적용
 * 
 */
-- 21. deptno 10, job 은 manager(대문자로) 이름, 사번, deptno, job 검색
select job from emp;

-- step01 : db에는 MANAGER 대문자로 저장되어 있으나 mysql 자체의 기본 기질 상 대소문자 구분 없이 검색 가능
-- 검색 성공
SELECT ename, empno, deptno, job
from emp
where deptno = 10 and job = 'manager';

-- step02 : 대소문자 구분 설정 검색시 binary() 함수 사용
-- 검색 불가 : 소문자 manager 데이터 없음
SELECT ename, empno, deptno, job
from emp
where deptno = 10 and job = BINARY('manager');

-- 검색 성공
SELECT ename, empno, deptno, job
from emp
where deptno = 10 and job = BINARY('MANAGER');

-- step03 : 대문자로 변경 또는 소문자로 변경하는 함수 사용해서 검색
-- 뜻만 맞으면 검색 되게 해야 할 경우 선호
-- 대문자 : upper() / 소문자 : lower()
-- ename은 이미 대소문자 구분해야만 하는 설정을 alter 명령어로 적용한 상태

-- 검색 성공
SELECT ename, empno, deptno, job
from emp
where deptno = 20 and ename = 'SMITH';

-- 검색 실패
SELECT ename, empno, deptno, job
from emp
where deptno = 20 and ename = 'smith';

-- upper() 로 해결해서 검색
-- smith -> SMITH 변환 후 비교 검색
SELECT ename, empno, deptno, job
from emp
where deptno = 20 and ename = upper('smith');

SELECT ename, empno, deptno, job
from emp
where deptno = 20 and ename = lower('smith');

-- ename 컬럼 값을 소문자로 변환 후 smith 라는 소문자로 비교해서 검색
-- 검색 성공
SELECT ename, empno, deptno, job
from emp
where deptno = 20 and lower(ename) = 'smith';

-- 'ename 컬럼은 대소문자 명확히 구분하겠음' mysql의 기본 기질을 변경하는 문장
-- alter table emp change ename ename varchar(20) binary;
select ename from emp;
select ename from emp where ename='SMITH'; -- 검색 성공
select ename from emp where ename='smith'; -- 검색 불가

-- 23. sal이 2000이하(sal <= 2000) 이거나(or) 3000이상(sal >= 3000) 
-- 사원명, 급여 검색
SELECT sal from emp;

select ename, sal
from emp
where sal <= 2000 or sal >= 3000;

-- 24.  comm이 300 or 500 or 1400인
-- in 연산식 사용해서 좀더 개선된 코드
SELECT comm from emp;

select ename, comm
from emp 
WHERE comm=300 or comm=500 or comm=1400;

select ename, comm
from emp 
where comm in (300,500,1400);


-- 25. ?  comm이 300 or 500 or 1400이 아닌 사원명 검색
-- not in ()
select ename, comm
from emp 
where comm not in (300,500,1400);

-- 26. 81/09/28 날 입사한 사원 이름.사번 검색
select hiredate from emp;
-- date 타입 비교시 'yyyy-mm-dd' 형식으로 비교
select ename, empno
from emp e 
where hiredate ='1981-09-28';

-- 검색 불가 : 날짜 데이터 검색시 ' '표기 필요
select ename, empno
from emp e 
where hiredate =1981-09-28;


-- 27. 날짜 타입의 범위를 기준으로 검색
-- 범위비교시 연산자 : between~and
-- 1987-04-19
select ename, empno
from emp e 
where hiredate between '1981-09-28' and '1987-04-19';


-- 28. 검색시 포함된 모든 데이터 검색하는 기술
-- like 연산자 사용
-- % : 철자 개수 무관하게 검색 / _ : 철자 개수 의미
select ename from emp;


-- 29. 두번째 음절의 단어가 M(_M)인 모든 사원명 검색 
select ename from emp where ename like'_M%';

-- 세번째 음절의 단어가 M인 모든 사원명 검색
select ename from emp where ename like'__M%';


-- 30. 단어가 M을 포함한 모든 사원명 검색 
-- M단어가 포함된 모든 사원명 검색
select ename from emp where ename like'%M%';


-- 리뷰 후에 2문제 직접 만들고 풀이도 작성하기
-- 31. 부서 번호가 30인 부서의 이름, 사번, 부서 번호, 입사일, 연봉 검색
-- 단 연봉 순으로 정렬
SELECT ename, empno, deptno, hiredate, sal*12 as 연봉
from emp e 
where deptno = 30 order by sal*12 asc; 

-- 32. 이름이 S로 끝나는 사람을 포함한 사람과 그렇지 않은 사람 구분해서 
-- 이름, 사번, 입사일, 월 급여순으로 정렬
SELECT ename, empno, hiredate, sal -- 포함한 사람
from emp e 
where ename like '%S' order by sal desc;

SELECT ename, empno, hiredate, sal -- 포함하지 않은 사람
from emp e 
where ename not like '%S' order by sal desc;