-- 6.subQuery.sql
/*
syntax
	select 
	from (select절)
	where (select절)
*/

-- select문 내에 포함된 또 다른 select문 작성 방법
-- 참고 : join 또는 subquery로 동일한 결과값 검색

-- 문법 : 비교 연산자(대소비교, 동등비교) 오른쪽에 () 안에 select문 작성 
-- : create 및 insert 에도 사용 가능


-- 1. SMITH라는 직원 부서명 검색


-- inner join
SELECT d.DNAME 
FROM emp e INNER JOIN DEPT d
ON e.ENAME = 'SMITH' AND e.DEPTNO = d.DEPTNO;

select deptno from emp where ename='SMITH';
select dname from dept where deptno=20;

-- sub query
-- 실행 순서 - where 내의 select 문장 실행 후 main 쿼리 순으로 실행
select dname 
from dept 
where deptno= (
		select deptno from emp where ename='SMITH'
);



-- 2. SMITH와 동일한 직급(job)을 가진 사원들의 모든 정보 검색(SMITH 포함)
select *
from emp e 
where job =(
	select job from emp where ename= 'SMITH'
);


-- SMITH 제외
select *
from emp e 
where job =(
	select job from emp where ename= 'SMITH'
) and ename != 'SMITH';

-- 3. SMITH와 급여가 동일하거나 더 많은(>=) 사원명과 급여 검색
-- SMITH 가 포함된 검색 후에 SMITH 제외된 검색해 보기 
select ename, sal
from emp e 
where sal >= (select sal from emp where ename = 'SMITH');

-- SMITH 제외해서 검색하기
select ename, sal
from emp e 
where sal >= (select sal from emp where ename = 'SMITH')
and ename != 'SMITH';


-- 4. DALLAS에 근무하는 사원의 이름, 부서 번호 검색
select loc from dept;

select ename, deptno
from emp
where deptno = (select deptno
				from dept
				where loc = 'DALAS');

-- ename을 오름차순 정렬 추가
select ename, deptno
from emp
where deptno = (select deptno
				from dept
				where loc = 'DALAS')
order by ename asc;
			

-- 5. 평균 급여(avg(sal))보다 더 많이 받는(>) 사원만 검색
select avg(sal) from emp;

select ename, sal
from emp 
where sal > (select avg(sal) from emp);



-- 다중행 서브 쿼리(sub query의 결과값이 하나 이상)
-- 6.급여가 3000이상 사원이 소속된 부서(10번, 20번)에 속한  사원이름, 급여 검색
	-- 급여가 3000이상 사원의 부서 번호
	-- in
select sal, deptno from emp;
select deptno from emp where sal >= 3000;

select ename, sal from emp where deptno in (10,20);

select ename, sal 
from emp 
where deptno in (select deptno from emp where sal >= 3000);

-- 7. in 연산자를 이용하여 부서별(group by)로 가장 급여(max())를 많이 
-- 받는 사원의 정보(사번, 사원명, 급여, 부서번호) 검색
select deptno, max(sal)
from emp e
group by deptno;

select empno, ename, sal, deptno
from emp e
where (deptno, sal) in (select deptno, max(sal) 
						from emp e 
						group by deptno
						); 

-- 8. 직급(job)이 MANAGER인 사람이 속한 부서의 부서 번호와 부서명(dname)과 지역검색(loc)
select deptno, dname, loc
from dept
where deptno in (select deptno from emp e where job = 'MANAGER');