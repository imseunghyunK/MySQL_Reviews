/* 학습내용
 * - 기본적으로 table 생성, 삭제, 구조 변경에 대한 학습
 * - 차후에 제약조건 학습 예정
 */

/* TCL
 * - 트랜잭선 처리 명령어
 * 	- insert/update/delete (DML) 문장에 한해서만 영향을 줌
 *  - table create/drop/alter(DDL) 명령어와 무관
 * - commit
 * - rollback
 * 
 */

-- 7.DDL.sql
-- table 생성(create)과 삭제(drop), table 구조 수정(alter)

-- DDL(Data Definition Language)
/*
 DB에 데이터를 CRUD 작업 가능하게 해주는 기본 구성
   
[1] table 생성 명령어
    create table table명(
		칼럼명1 칼럼타입[(사이즈)] [제약조건] ,
		칼럼명2....
    ); 

[2] table 삭제 명령어
	drop table table명;
	- 삭제 시도시 table 미존재시 에러 발생

[3] table 구조 수정 명령어
	alter table  table명
*/

use playdata;

-- mysql상에서의 table 목록 검색

-- 1. table삭제 
-- 존재해야만 실행 에러가 없는 drop 문장
drop TABLE test;

-- 존재 여부 확인 후에 존재할 경우에만 삭제하는 drop 문장
drop table if exists test;

-- 2. table 생성  
-- name(varchar(12), age(int) 칼럼 보유한 people table 생성
-- name은 최대 12byte 크기의 문자열 데이터 저장

-- db : name 타입
-- java : String name
-- python : name
-- javascript : name

drop table if exists people;

create table people(
	name varchar(12),
	age int
);

desc people;

-- 3. 서브 쿼리 활용해서 emp01 table 생성(이미 존재하는 table기반으로 생성)
-- 구조와 데이터는 복제 가능하나 제약조건은 적용 불가
-- dept table 과 무관한 emp01 table
-- emp table의 모든 데이터로 emp01 생성
drop table if exists emp01;

-- table 구조와 데이터 복재해서 독립적인 새로운 table 생
create table emp01 as select * from emp;

select * from emp01;
drop table if exists emp01;

-- 거짓 조건식 적용시에는 구조만 복제
create table emp01 as select * from emp where 1=0;
select * from emp01;


-- 4. 서브쿼리 활용해서 특정 칼럼(empno)만으로 emp02 table 생성
drop table if exists emp02;

create table emp02 as select empno from emp;

select * from emp02;

-- 5. deptno=10 조건문 반영해서 empno, ename, deptno로  emp03 table 생성
drop table if exists emp03;

create table emp03 as select empno, ename, deptno from emp where deptno=10;

select * from emp03;

desc emp03;

-- 6. 데이터 insert없이 table 구조로만 새로운 emp04 table생성시 
-- 사용되는 조건식 : where=거짓
drop table if exists emp04;

create table emp04 as select * from emp where 1=0;
select * from emp04;

-- 이미 존재하는 table의 구조를 변경하는 sql문장

-- 7. emp01 table에 job이라는 특정 칼럼 추가(job varchar2(10))
-- 이미 데이터를 보유한 table에 새로운 job칼럼 추가 가능 
-- add  : 컬럼 추가 연산자
drop table if exists emp01;

create table emp01 as select empno, ename from emp;
desc emp01;
select * from emp01;

-- 최대 10byte 문자열 저장 가능한 job 컬럼 생성 및 추가
alter table emp01 add job varchar(10);

desc emp01;
select * from emp01;

-- 8. 이미 존재하는 칼럼 사이즈 변경 시도해 보기
-- 데이터 미 존재 칼럼의 사이즈 수정(크게/작게 다 수정 가능)
-- modify : 컬럼 변경
-- 복제된 emp01 table의 job의 크기는 20byte / 데이터 5~9byte

drop table if exists emp01;
desc emp01;
create table emp01 as select empno, ename, job from emp;
select * from emp01;

select length(job) from emp01;
select job from emp01;

-- job 크기를 10으로 변경
desc emp01;
alter table emp01 modify job varchar(10);
desc emp01; -- 10으로 정상 변경

select * from emp01; -- 모든 데이터 정상 검색

-- 9. 이미 데이터가 존재할 경우 칼럼 사이즈가 큰 사이즈의 컬럼으로 변경 가능 
-- 혹 사이즈 감소시 주의사항 : 이미 존재하는 데이터보다 적은 사이즈로 변경 절대 불가 
-- 발생 가능한 문제 : 데이터 보다 적은 사이즈로 수정 시도시 데이터 손실 가능성 있음

-- alter table emp01 modify job varchar(3); 실패
desc emp01;

-- 10. job 칼럼 삭제 
-- 데이터 존재시에도 자동 삭제 
-- drop 
-- add시 필요 정보(컬럼명 타입(사이즈)) / modify 필요 정보(컬럼명 타입(사이즈)) / drop 필요 정보(컬럼명)

alter table emp01 drop column job;
desc emp01;

-- 11. table의 순수 데이터만 완벽하게 삭제하는 명령어 
-- 주의사항 : tool 사용시 tool 기능 auto commit 즉 삭제시 영구 삭제하는지 반드시 확인
-- commit 불필요
-- DELETE  or TRUNCATE 
-- delete 
select * from emp01;
-- emp01의 SMITH 삭제
delete from emp01 where ename='SMITH';
select * from emp01;
rollback; -- 복원(임시 메모리에 저장되었던 작업을 무효화), 삭제 작업 무효화
select * from emp01; -- SMITH 검색

delete from emp01 where ename='SMITH';
select * from emp01;
commit; -- 수정된 작업들 영구 저장
select * from emp01;
rollback; -- commit 이후에 작업된 내용에 한해서만 복언
select * from emp01;

-- truncate
select * from emp01;
delete from emp01;
select * from emp01;
rollback; -- delete 문장 무효화, 데이터 복구
select * from emp01;

truncate table emp01; -- emp01 table의 모든 내용 삭제, 영구 저장 되어버림(commit 불필요)
select * from emp01; -- 데이터 없음
rollback; -- insert/update/delete 문장에만 적용
select * from emp01; -- 데이터 없음
