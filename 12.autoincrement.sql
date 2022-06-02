-- 12.autoincrement.sql

/*
1. 개요
	- 새 데이터 저장시 고유 번호가 자동 생성 및 적용하게 하는 기술
	
2. 대표적인 활용 영역
	- 게시물 글번호에 주로 사용
	- 가입된 회원수 카운팅

3. 문법
	- auto_increment 키워드 적용
		- 별도의 설정이 없을 경우 시작 순번은 1부터임
		
	- 생성
		- 컬럼명 타입 auto_increment
		
	- 시작 값을 100으로 하려 할 경우
		- alter table table명 auto_increment = 100;
	
*/

-- 1. 사번에 적용. 1씩 증가

DROP TABLE IF EXISTS emp01;

-- empno를 auto_increment로 자동 증가치 적용시 pk로 미등록시 에러 발생
create table emp01(
	empno int auto_increment,
	ename varchar(10) not null,
	primary key (empno)
);

desc emp01;

-- insert 
insert into emp01 (ename) values ('연아');
select * from emp01;
select * from emp01 limit 2;


-- 2. 수정 : 자동 증가분 시작값을 100으로 설정해 보기 
alter table emp01 auto_increment = 100;

insert into emp01 (ename) values ('연아');
select * from emp01; 