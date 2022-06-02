9.integrity.sql
-- DB 자체적으로 강제적인 제약 사항 설정

/*
1. table 생성시 제약조건을 설정하는 기법 
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
    ....
);

2. Data Dictionary란?
	- 제약 조건등의 정보 확인
	- MySQL Server의 개체에 관한 모든 정보 보유하는 table
		- 일반 사용자가 검색은 가능하나 insert/update/delete 불가
	- information_schema

3. 제약 조건 종류
	emp와 dept의 관계
		- dept 의 deptno가 원조 / emp 의 deptno는 참조
		- dept : 부모 table / emp : 자식 table(dept를 참조하는 구조)
		- dept의 deptno는 중복 불허(not null) - 기본키(pk, primary key)
		- emp의 deptno - 참조키(fk, foreign key, 외래키)
	
	
	2-1. PK[primary key] - 기본키, 중복불가, null불가, 데이터들 구분을 위한 핵심 데이터
		: not null + unique
	2-2. not null - 반드시 데이터 존재
	2-3. unique - 중복 불가, null 허용
	2-4. check - table 생성시 규정한 범위의 데이터만 저장 가능 
	2-5. default - insert시에 특별한 데이터 미저장시에도 자동 저장되는 기본 값
				- 자바 관점에는 멤버 변수 선언 후 객체 생성 직후 멤버 변수 기본값으로 초기화
	* 2-6. FK[foreign key] 
		- 외래키[참조키], 다른 table의 pk를 참조하는 데이터 
		- table간의 주종 관계가 형성
		- pk 보유 table이 부모, 참조하는 table이 자식
	
4. 제약조건 적용 방식
	4-1. table 생성시 적용
		- create table의 마지막 부분에 설정
			방법1 - 제약조건명 없이 설정
			방법2 - constraints 제약조건명 명식
			
		- 참고 : mysql의 pk에 설정한 사용자 정의 제약조건명은 data 사전 table에서 검색 불가
			oracle db는 명확하게 사용자 정의 제약조건명 검색 

	4-2. alter 명령어로 제약조건 추가
	- 이미 존재하는 table의 제약조건 수정(추가, 삭제)명령어
		alter table 테이블명 modify 컬럼명 타입 제약조건;
		
	4-3. 제약조건 삭제(drop)
		- table삭제 
		alter table 테이블명 alter 컬럼명 drop 제약조건;
		
*/
-- 1. table 삭제
drop table if exists emp01;


-- 2. 사용자 정의 제약 조건명 명시하기
-- 개발자는 sql 문법 ok된 상태로 table + 제약조건 생성
-- db 관점에서 기록
create table emp01(
	empno int not null,
	ename varchar(10)
);

desc emp01;

-- mysql에 사전 table 검색
select TABLE_SCHEMA, TABLE_NAME 
from information_schema.TABLES
where TABLE_SCHEMA = 'information_schema';

-- 3. emp table의 제약조건 조회
-- table 생성시 컬럼 선언시에 not null ???

select * from information_schema.TABLE_CONSTRAINTS tc 
where TABLE_NAME = 'emp01';

-- empno : not null / ename : null
insert into emp01 (empno, ename) values (1, '재석');
select * from emp01;

insert into emp01 (empno) values (2);  -- ok
select * from emp01;

-- insert into emp01 (ename) values ('연아');  -- error
select * from emp01;



-- *** not null ***
-- 4. alter 로 ename 컬럼을 not null로 변경
desc emp01;

-- emp01의 ename엔 null이 없어야 정상 실행
delete from emp01 where ename is null;
select * from emp01;

alter table emp01 modify ename varchar(10) not null;

desc emp01;


-- 5. drop 후 dictionary table 검색
drop table if exists emp01;

-- emp01에 대한 정보가 소멸된 상태 확인을 위한 명령어
-- table 삭제시 제약조건도 자동 삭제
select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp01';


-- 6. 제약 조건 설정후 insert 
create table emp01(
	empno int not null,
	ename varchar(10)
);

insert into emp01 values(1, 'tester');
select * from emp01;
insert into emp01 (empno, ename) values(2, 'tester');
insert into emp01 (empno) values(3);
select * from emp01;

-- 오류, empno는 절대 null 값 저장 불가




-- *** unique ***
-- 7. unique : 고유한 값만 저장 가능, null 허용
drop table if exists emp02;

create table emp02(
	empno int unique,
	ename varchar(10)
);

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';

insert into emp02 values(1, 'tester');
select * from emp02;

insert into emp02 (ename) values('master');  -- ok 즉 null 허용
select * from emp02;


insert into emp02 (empno) values(2);  -- ok 즉 null 허용
select * from emp02;

-- insert into emp02 (empno) values(2);  -- SQL Error [1062] [23000]: Duplicate entry '2' for key 'emp02.empno'
select * from emp02;

-- 8. alter 명령어로 ename에 unique 적용
desc emp02;
select * from emp02;

-- ename이 null인 사람 삭제
delete from emp02 where ename is null;
desc emp02;
select * from emp02;

-- ename 컬럼에 unique 설정 추가
alter table emp02 add unique (ename);
desc emp02;

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp02';


-- *** Primary key ***

-- 9. pk설정 : 데이터 구분을 위한 기준 컬럼, 중복과 null 불허
DROP TABLE IF EXISTS emp03;

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

create table emp03(
	empno int,
	ename varchar(10) not null,
	primary key(empno)
);

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';

desc emp03;

insert into emp03 values (1, 'tester');
-- insert into emp03 values (1, 'master'); SQL Error [1062] [23000]: Duplicate entry '1' for key 'emp03.PRIMARY'

select * from emp03;


-- 10. 제약 조건명 명시 하면서 pk 설정
-- 제약 조건명 : pk_empno_emp03
drop table if exists emp03;

CREATE TABLE emp03(
	empno int,
	ename varchar(10) NOT null,
	constraint pk_empno_emp03 primary key (empno)
);

-- 사용자 정의 제약조건명 확인도 가능
-- pk와 not null은 확인 불가 
select * from information_schema.TABLE_CONSTRAINTS tc where table_name='emp03';

desc emp03;

insert into emp03 values (1, 'tester');
-- insert into emp03 values (1, 'master'); error
select * from emp03;


-- 11. alter & pk 명령어 적용
drop table if exists emp03;

CREATE TABLE emp03(
	empno int,
	ename varchar(10) NOT null
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';

alter table emp03 add constraint pk_empno_emp03 primary key(empno);

select * from information_schema.TABLE_CONSTRAINTS tc 
where table_name='emp03';


insert into emp03 values (1, 'tester');
-- insert into emp03 values (1, 'master'); error
select * from emp03;


-- 12. 제약 조건 삭제
alter table emp03 drop primary key;
desc emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';

alter table emp03 add constraint pk_empno_emp03 primary key(empno);

desc emp03;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp03';


-- *** foreign key ***

-- 13. 외래키[참조키]
-- emp table 기반으로 emp04 복제 단 제약조건은 적용되지 않음
-- alter 명령어로 table의 제약조건 추가 

drop table if exists emp04;
create table emp04 as select * from emp;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp';
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';


-- dept table의 deptno를 emp04의 deptno에 참조 관계 형성
select * from information_schema.TABLE_CONSTRAINTS where table_name='dept';
desc dept;

-- 생성시 fk 설정
drop table if exists emp04;

create table emp04(
	empno int,
	ename varchar(10) not null,
	deptno int,
	primary key (empno),
	foreign key (deptno) references dept(deptno)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

insert into emp04 values (1, '연아', 10);
insert into emp04 values (2, '구씨', 10);
-- insert into emp04 values (3, '구씨', 70);  error dept의 deptno에는 70번 없음
select * from emp04;

-- 14. alter & fk drop : dict table에서 이름 확인후 삭제 
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- 이름으로 제약조건 삭제
alter table emp04 drop foreign key emp04_ibfk_1;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- alter & fk add
drop table if exists emp04;

create table emp04(
	empno int,
	ename varchar(10) not null,
	deptno int
);
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

alter table emp04 add foreign key (deptno) references dept(deptno);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- w3schools 사이트 기술문서 참조
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

alter table emp04 drop foreign key emp04_ibfk_1;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- alter & fk & 제약조건명 명시
ALTER TABLE emp04
ADD CONSTRAINT fk_deptno_emp04
FOREIGN KEY (deptno) REFERENCES dept(deptno);
	
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';

-- 사용자 정의 제약 조건명으로 fk 설정 삭제
alter table emp04 drop foreign key fk_deptno_emp04;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp04';


-- *** check ***	
-- 15. check : if 조건식과 같이 저장 직전의 데이터의 유효 유무 검증하는 제약조건 

drop table if exists emp05;

-- 0초과 데이터만 저장 가능한 check
create table emp05(
	empno int primary key,
	ename varchar(10) not null,
	age int,
	check (age > 0)
);

desc emp05;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

insert into emp05 values(1, 'master', 10);
insert into emp05 values(2, 'master', -10); -- error
select * from emp05;


-- age값이 1~100까지만 DB에 저장
drop table if exists emp05;

create table emp05(
	empno int primary key,
	ename varchar(10) not null,
	age int,
	check (age between 1 and 100)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';
desc emp05;

insert into emp05 values(1, 'master', 10);
-- insert into emp05 values(2, 'master', 200); -- error
select * from emp05;


-- 16. alter & check
drop table if exists emp05;

create table emp05(
	empno int,
	ename varchar(10) not null,
	age int
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

alter table emp05 add check (age > 0);

desc emp05;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

insert into emp05 values(1, 'master', 10);
-- insert into emp05 values(2, 'master', -10); -- error

select * from emp05;


-- 17. drop a check : 제약조건명 검색 후에 이름으로 삭제
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';

alter table emp05 drop check emp05_chk_1; 

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp05';



-- 18. ? gender라는 컬럼에는 데이터가 M 또는(or) F만 저장되어야 함
drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1),
	check ( gender in ('F', 'M') )
);


select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
 
insert into emp06 values(1, 'master', 'F');
-- insert into emp01 values(2, 'master', 'T'); error
select * from emp06;




-- 19. alter & check

drop table if exists emp06;

-- char(3) -  무조건 3byte 메모리 점유(고정 문자열 크기 타입)
-- varchar(10) - 가변적인 문자열 메모리 즉 최대 10byte 의미 (가변적 문자열 크기 타입)
create table emp06(
	empno int,
	ename varchar(10) not null,
	gender char(1)
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

alter table emp06 add check ( gender in ('F', 'M') );

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';

insert into emp06 values(1, 'master', 'F');
-- insert into emp01 values(2, 'master', 'T'); 
select * from emp06;


-- *** default ***
-- 20. 컬럼에 기본값 설정
-- insert시에 데이터를 저장하지 않아도 자동으로 기본값으로 초기화(저장)
drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int default 1
);

desc emp06;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
 
insert into emp06 values(1, 'master', 10);
select * from emp06;

-- age 컬럼에 데이터 저장 생략임에도 1이라는 값 자동 저장
insert into emp06 (empno, ename) values(2, 'master');  
select * from emp06;


-- 21. alter & default

drop table if exists emp06;

create table emp06(
	empno int,
	ename varchar(10) not null,
	age int
);

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
ALTER TABLE emp06 ALTER age SET DEFAULT 1;

insert into emp06 values(1, 'master', 10);
select * from emp06;

insert into emp06 (empno, ename) values(2, 'use02');
select * from emp06;

select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
desc emp06;


-- 22. default drop 
-- defalut 제약조건 삭제
-- age 컬럼은 존재만 하는 상황
alter table emp06 alter age drop default;
select * from information_schema.TABLE_CONSTRAINTS where table_name='emp06';
desc emp06;

-- default로 적용되었다가 defalut값 drop 한 컬럼은 값 미 반영시 에러 
insert into emp06 (empno, ename) values(3, 'use03');  -- SQL Error [1364] [HY000]: Field 'age' doesn't have a default value
insert into emp06 (empno, ename, age) values(4, 'use04', 10);  -- 정상 
insert into emp06 (ename, age) values('use05', 50);  -- 정상

select * from emp06;
