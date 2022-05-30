-- 5.join.sql
-- mysql용
/*
1. 조인이란?
	다수의 table간에  공통된 데이터를 기준으로 검색하는 명령어
	다수의 table이란?
		동일한 table을 논리적으로 다수의 table로 간주
			- self join
			- emp의 mgr 즉 상사의 사번으로 이름(ename) 검색
				: emp 하나의 table의 사원 table과 상사 table로 간주

		물리적으로 다른 table간의 조인
			- emp의 deptno라는 부서번호 dept의 부서번호를 기준으로 부서의 이름/위치 정보 검색
  
2. 사용 table 
	1. emp & dept 
	  : deptno 컬럼을 기준으로 연관되어 있음

	 2. emp & salgrade
	  : sal 컬럼을 기준으로 연관되어 있음

  
3. table에 별칭 사용 
	검색시 다중 table의 컬럼명이 다를 경우 table별칭 사용 불필요, 
	서로 다른 table간의 컬럼명이 중복된 경우,
	컬럼 구분을 위해 오라클 엔진에게 정확한 table 소속명을 알려줘야 함

	- table명 또는 table별칭
	- 주의사항 : 컬럼별칭 as[옵션], table별칭 as 사용 불가


4. 조인 종류 
	1. 동등 조인
		 = 동등비교 연산자 사용
		 : 사용 빈도 가장 높음
		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 

	2. not-equi 조인
		: 100% 일치하지 않고 특정 범위내의 데이터 조인시에 사용
		: between ~ and(비교 연산자)

	3. self 조인 
		: 동일 테이블 내에서 진행되는 조인
		: 동일 테이블 내에서 상이한 칼럼 참조
			emp의 empno[사번]과 mgr[사번] 관계

	4. outer 조인 
		: 조인시 조인 조건이 불충분해도 검색가능하게 하는 조인 
		: 두개 이상의 테이블이 조인될때 특정 데이터가 모든 테이블에 존재하지 않고 컬럼은 존재하나 
		  null값을 보유한 경우
		  검색되지 않는 문제를 해결하기 위해 사용되는 조인
		  
		  null 값이기 때문에 배제된 행을 결과에 포함 할 수 있으며 oracle인 경우엔 (+) 기호를 조인 조건에서 
		  정보가 부족한 컬럼쪽에 적용해서 검색 가능
*/		


use playdata;

-- 1. dept table의 구조 검색
show tables;

-- dept, emp, salgrade table의 모든 데이터 검색
select * from dept;
select * from emp;
select * from salgrade;


-- *** 1. 동등 조인 ***
-- = 동등 비교연산자 사용해서 검색 


-- 2. SMITH 의 이름(ename), 사번(empno), 근무지역(부서위치)(loc) 정보를 검색
-- emp/dept
-- 비교 기준 데이터를 검색조건에 적용해서 검색
-- table명이 너무 복잡한 경우 별칭 권장
select ename, empno, deptno from emp where ename = 'SMITH';
select loc, deptno from dept;
select loc, deptno from dept where deptno = 20;

select ename, empno, loc
from emp, dept
where ename='SMITH' and emp.deptno = dept.deptno;


-- 3. deptno가 동일한 모든 데이터(*) 검색
-- emp & dept 
-- 존재하는 각 table의 모든 컬럼 만큼 기준점 없이 검색
-- 즉 조인시에는 기준이 되는 조건비교가 필요

-- 실행은 가능하나 dept의 deptno와 emp의 deptno가 동시에 검색 즉 데이터의 정확도 아쉬움
-- 비추
select * from emp, dept;

-- 각 직원들이 소속된 부서번호로만 검색

-- deptno 컬럼이 어떤 table인지 설정 필요
-- where 없이 검색시에는 모든 직원에 모든 부서 정보를 결합해서 무의미한 결과 검색
select empno, ename, job, emp.deptno, dname, loc
from emp, dept;

-- 해결점 : 중복 컬럼에는 table 소속 명시, where 조건문 반영해서 동등조인
select empno, ename, job, emp.deptno, dname, loc
from emp, dept
where emp.deptno = dept.deptno;

-- table에 별칭 적용해서 조인
select empno, ename, job, e.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;

select empno, ename, job, d.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;

-- 4. 2+3 번 항목 결합해서 SMITH에 대한
--  모든 정보(ename, empno, sal, comm, deptno, loc) 검색하기
select ename, empno, sal, comm, e.deptno, loc
from emp e, dept d 
where e.deptno = d.deptno and ename = 'SMITH';

-- 5.  SMITH에 대한 이름(ename)과 부서번호(deptno), 
-- 부서명(dept의 dname) 검색하기
select ename, e.deptno, dname
from emp e, dept d 
where e.deptno = d.deptno and ename = 'SMITH';

-- 6. 조인을 사용해서 뉴욕('NEW YORK')에 근무하는 사원의 이름과 급여를 검색 
select loc from dept;

select ename, sal, loc
from emp, dept
where loc = 'NEW YORK' and emp.deptno = dept.deptno;

-- 7. 조인 사용해서 ACCOUNTING 부서(dname)에 소속된 사원의
-- 이름과 입사일 검색
select dname from dept d;

select ename, hiredate
from emp e, dept d
where dname = 'ACCOUNTING' and e.deptno = d.deptno;

-- 8. 직급(job)이 MANAGER인 사원의 이름, 부서명 검색
select ename, dname, job, e.deptno 
from emp e, dept d 
where job = 'MANAGER' and e.deptno = d.deptno;

-- *** 2. not-equi 조인 ***

-- salgrade table(급여 등급 관련 table)
select * from salgrade s;

-- 9. 사원의 급여가 몇 등급인지 검색
-- between ~ and : 포함 
select sal, grade
from emp e, salgrade s
where sal between losal and hisal;

-- 동등조인
-- 10. 사원(emp) 테이블의 부서 번호(deptno)로 
-- 부서 테이블을 참조하여 사원명, 부서번호,
-- 부서의 이름(dname) 검색
select ename, d.deptno, dname
from emp e , dept d
where e.deptno = d.deptno; 


-- *** 3. self 조인 ***
-- 11. SMITH 직원의 매니저 이름 검색
-- emp e : 사원 table로 간주 / emp m : 상사 table로 간주
select e.ename as 사원명, m.ename as 상사이름
from emp e, emp m 
where e.ename = 'SMITH' and e.mgr  = m.empno;

-- 12. 매니저 이름이 KING(m ename='KING')인 
-- 사원들의 이름(e ename)과 직무(e job) 검색
select e.ename, e.job
from emp e, emp m
where m.ename = 'KING' and e.mgr = m.empno;

-- 13. SMITH와 동일한 부서에서 근무하는 사원의 이름 검색
-- 단, SMITH 이름은 제외하면서 검색 : 부정연산자 사용 !=
-- SMITH 까지 검색
select you.ename 동료이름
from emp my, emp you
where my.ename = 'SMITH' and my.deptno = you.deptno;

-- SMITH  검색 제외
select you.ename 동료이름
from emp my, emp you
where my.ename = 'SMITH' 
	and my.deptno = you.deptno
	and you.ename != 'SMITH';

-- *** 4. outer join ***
select * from dept;
select empno, deptno from emp; -- 40번 부서에 근무하는 직원들도 없음
select distinct deptno from emp; -- 40번 부서에 근무하는 직원들도 없음

select ename, mgr from emp; -- KING의 mgr 은 null

-- 14. 모든 사원명(KING 포함), 매니저 명 검색, 단 매니저가 없는 사원도 검색되어야 함

-- step01 : 상사가 없는 KING의 이름 검색이 안되었음!!!

select e.ename 사원명, m.ename 상사명 
from emp e, emp m
where e.mgr = m.empno;


-- step02 : KING 검색 
-- left join을 이용하여 상사가 없는 KING 정보 검색
--  상사가 없는 KING 정보도 검색
/*
 * 
 */
-- step01 - 검색 성공
select e.ename 사원명, m.ename 상사명 
from emp e left join emp m
on e.mgr = m.empno;

-- step02 - 논리적인 오류
-- null이라는 상사는 미 존재 즉 null이라는 사번이 상사 table에는 없음
select e.ename 사원명, m.ename 상사명 
from emp e right join emp m
on e.mgr = m.empno;

-- step03 - 검색 성공
select e.ename 사원명, m.ename 상사명 
from emp m right join emp e
on e.mgr = m.empno;


-- 15. 모든 직원명(ename), 부서번호(deptno), 부서명(dname) 검색
-- 부서 테이블의 40번 부서와 조인할 사원 테이블의 부서 번호가 없지만,
-- outer join이용해서 40번 부서의 부서 이름도 검색하기 

-- 40번 부서 번호도 검색
select ename, d.deptno, dname
from emp e, dept d 
where e.deptno = d.deptno;


-- 40번 부서 번호도 검색
select ename, d.deptno, dname
from dept d left join emp e 
on e.deptno = d.deptno;

select ename, d.deptno, dname
from emp e right join dept d 
on e.deptno = d.deptno;

-- 모든 부서번호 검색이 되어야 하며 단, 급여가 3000이상인 사원의 정보도 검색시
-- 특정 부서에 소속된 직원이 없을 경우 부서 번호는 검색되지 않아도 됌.
-- 검색 컬럼 : deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm

-- 40번 부서도 검색은 되었으나 3000이상 전제조건의 아쉬움
select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, round(sal), comm 
from emp e right join dept d 
on e.deptno = d.deptno

-- 40번 부서 검색 불가
select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, round(sal), comm 
from emp e right join dept d 
on e.deptno = d.deptno
where round(sal) >= 3000;

-- 모든 부서 정보와 급여가 3000이상인 직원들 검색하기 
select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, sal , comm
from dept d left join emp e 
on d.deptno = e.deptno and e.sal>=3000; 

select e.*, d.deptno , d.dname, d.loc
from emp e
right join dept d
on d.deptno = e.deptno and e.sal >= 3000;

select d.deptno, dname, loc, empno, ename, job, mgr, hiredate, sal, comm
from dept d left join emp e 
on d.deptno = e.deptno and sal >= 3000;
