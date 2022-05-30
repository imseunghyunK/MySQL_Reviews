-- mysql 일반 user SCOTT/TIGER
-- 실습시에 dbeaver의 auto commit 기능 무효화 한 후에 수작업으로 tx 수행

-- 08.DML.sql
/* 
- DML : Data Mainpulation Language
            데이터 조작 언어
	   (select(DQL)/insert/update/delete 모두 다 DML)
	   - 이미 존재하는 table에 데이터 저장, 수정, 삭제, 검색 
	   - commit과 rollback(트랜젝션)이 적용되는 명령어
	   - insert/update/delete에만 적용

1. insert sql문법
	1-1. 모든 칼럼에 데이터 저장시 
		insert into table명 values(데이터값1, ...)

	1-2.  특정 칼럼에만 데이터 저장시,
		명확하게 칼럼명 기술해야 할 경우 
		insert into table명 (칼럼명1, ...) values(칼럼과매핑될데이터1...)


2. update 
	2-1. 모든 table(다수의 row)의 데이터 한번에 수정
		- where조건문 없는 문장
		- update table명 set 칼럼명=수정데이터;

	2-2. 특정 row값만 수정하는 방법
		- where조건문으로 처리하는 문장
		- update table명 set 칼럼명=수정데이터[, 컬럼명2=수정데이터2, ...] where 조건sql;

3. delete
*/

use playdata;

-- *** insert ****
-- 1. 칼럼명 기술없이 데이터 입력
-- table 자체가 생성시에 컬럼 순으로 데이터 값들도 설정해서 저장
drop table if exists emp01;
drop table if exists emp02;

-- 데이터 구조만 복제해서 새로 생성
create table emp01 as select empno, ename, deptno from emp where 1=0;
create table emp02 as select empno, ename, deptno from emp where 1=0;

select * from emp01;
select * from emp02;

-- emp01
insert into emp01 values (1, '흥민', 10);
select * from emp01;


-- 2. 칼럼명 기술후 데이터 입력 
-- 저장하고자 하는 데이터의 순서를 컬럼명 명시하면서 변경 가능
-- null을 허용하는 컬럼에 값 미저장시 특정 컬럼만 명시해서 값 저장 가능
insert into emp01 (empno, ename, deptno) values (2, '민정', 20);
insert into emp01 (ename, deptno, empno) values ('지민', '30', 3);

-- **** 주의사항 : empno에 0으로 자동 반영, 단 oracle db 등은 null로 처리
-- mysql의 경우 타입이 int인 경우 java처럼 default값인 0으로 자동 반영
insert into emp01 (deptno) values (30);

select * from emp01;

-- 0으로 검색하는 현 sql문장은 사번이 0인 사람은 없기 때문에 가치없는 문장
select * from emp01 where empno=0;

-- 3. 하나의 table에 한번에 데이터 insert하기 
-- , 구분자로 () 표현을 적용해서 저장
drop table if exists emp01;
drop table if exists emp02;

create table emp01 as select empno, ename, deptno from emp where 1=0;
create table emp02 as select empno, ename, deptno from emp where 1=0;

select * from emp01;
select * from emp02;

insert into emp01 values (1, '흥민', 10), (2, '민정', 20);
select * from emp01;



-- 4. 데이터만 삭제 - rollback으로 복구 불가능한 데이터 삭제 명령어
truncate table emp01;
truncate table emp02;

rollback;
select * from emp01;


insert into emp01 values (1, '흥민', 10), (2, '민정', 20);
commit;
select * from emp01; -- 검색 성공

rollback; -- commit 명령어로 저장된 로직까지 유효
select * from emp01; -- commit 이후에 검색 가능



-- *** update ***
-- 1. 테이블의 모든 행 변경
drop table emp01;
create table emp01 as select * from emp;
select deptno from emp01;

-- deptno값을 50으로 변경
update emp01 set deptno=50;

select deptno from emp01;
rollback;

-- 10번 부서 번호를 50으로 변경
update emp01 set deptno=50 where deptno=10;
select * from emp01;
commit;

-- 2. ? emp01 table의 모든 사원의 급여를 10%(sal*1.1) 인상하기
-- ? emp table로 부터 empno, sal, hiredate, ename 순으로 table 생성
desc emp01;
drop table if exists emp01;

create table emp01 as select empno, sal, hiredate, ename from emp;
desc emp01;
select * from emp01;

select sal from emp01;
update emp01 set sal=sal*1.1;
select sal from emp01;
commit;

-- 3. emp01의 모든 사원의 입사일을 오늘로 바꿔주세요
select * from emp01;

update emp01 set hiredate=now;

select hiredate from emp01;

commit;


-- 4. 급여가 3000이상(where sal >= 3000)인 사원의 급여만 10%인상
select sal from emp01;

update emp01 set sal=sal*1.1 where sal >= 3000;

select sal from emp01;
commit;

-- 5. ?emp01 table 사원의 급여가 1000이상인 사원들의 급여만 500원씩 삭감 
-- insert/update/delete 문장에 한해서만 commit과 rollback 영향을 받음
select sal from emp01;

update emp01 set sal=sal-500 where sal >= 1000;

select sal from emp01;
commit;


-- 6. emp01 table에 DALLAS(dept의 loc)에 위치한 부서의 소속 사원들의 급여를 1000인상
-- 서브쿼리 사용
drop table if exists emp01;
create table emp01 as select * from emp;
select * from emp01;

select * from dept;

select deptno from dept where loc='DALLAS';

select sal from emp01;
update emp01 
set sal = sal+100 
where deptno=(
		select deptno 
		from dept 
		where loc='DALLAS');

select sal from emp01;
commit;

-- 7. emp01 table의 SMITH 사원의 부서 번호를 30으로, 직급은 MANAGER 수정
-- 두개 이상의 칼럼값 동시 수정
select deptno, job from emp01 where ename='SMITH';

pdate emp01 set deptno = 30 where ename='SMITH';

select deptno, job from emp01 where ename='SMITH';

update emp01 set job='MANAGER' where ename='SMITH';
select deptno, job from emp01 where ename='SMITH';
commit;



-- *** delete ***
-- 8. 하나의 table의 모든 데이터 삭제
select * from emp01;
delete from emp01;
select * from emp01;
rollback;
select * from emp01;

-- 9. 특정 row 삭제(where 조건식 기준)
-- deptno가 30번 부서의 모든 사원들 삭제
delete from emp01 where deptno=30;
select * from emp01;

rollback;

-- 10. emp01 table에서 comm 존재 자체가 없는(null) 사원 모두 삭제
select sal, comm from emp01;
delete from emp01 where comm is null;
select sal, comm from emp01;

rollback;

-- 11. emp01 table에서 comm이 null이 아닌 사원 모두 삭제
select sal, comm from emp01;
delete from emp01 where comm is not null;
select sal, comm from emp01;

rollback;
-- 12. emp01 table에서 부서명이 RESEARCH 부서에 소속된 사원 삭제 
-- 서브쿼리 활용
select * from emp01;

select * from dept;
select deptno from dept where dname = 'RESEARCH';

delete from emp01 where deptno=(select deptno from dept where dname = 'RESEARCH');

select * from emp01;

rollback;

-- 13. table내용 삭제
select * from emp01;
delete from emp01;
select * from emp01;

rollback;
select * from emp01;

truncate table emp01; -- 영구 삭제 저장 복구 불가 
select * from emp01;