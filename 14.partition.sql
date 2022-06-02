-- 14.partition.sql
/*
 * 1. 기능
 * 	- 논리적으로 하나의 table 이나 물리적으로 여러 개의 table로 분리해서 관리하는 기술
 * 	- 데이터와 index를 조각화해서 물리적 메모리를 효율적으로 사용
 * 	- 동일한 대용량 데이터를 RDBMS에서 효율적으로 처기하기 위한 기술
 * 		- 하둡, 스파크, ELK.., 몽고db 등의 솔류션도 존재
 * 
 * 	- RDBMS는 정형 데이터 구조로 무결성 보장하면서 저장하기 위한 기술
 * 
 * 
 * 2. 장점	
 * 	- 하나의 table이 너무 클 경우 index의 크기가 물리적인 메모리 보다 훨씬 크거나 데이터 특성상 주기적인 삭제
 * 	  작업이 필요한 경우 필요
 * 	- 단일 insert와 빠른 검색
 * 
 * 3. 파티션 키로 해당 데이터 저장 및 관리
 * 
 * 4. range() 사용한 partition
 * 	- 파티션 키로 연속된 범위로 파티션을 정의하는 방식
 *  - 가장 일반적
 *  - maxvalue라는 키워드를 사용시 명시되지 않은 범위의 키 값이 담긴 레코드를 저장하는 파티션 정의가 가능
 * 		- 마지막 파티션 기준 데이터를 포함한 그 이상의 모든 데이터를 파티션으로 저장 및 관리 
 * 
 * 5. 참고
 * 	- table 생성 -> insert 후에는 dbeaver인 경우 Database Navigator 하위의 table명 sub menu인 Partitions 확인 필수
 * 
*/

-- test data의 기준 년도
drop table emp00;

/* 년도를 기준으로 하나의 table을 마치 물리적으로 다수의 table이 있는 것처럼 table 생성
 * 
 * 
 */
CREATE TABLE emp00 (
    empno                int  NOT NULL,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint,
    hiredate             date,
    sal                  numeric(7, 2),
    comm                 numeric(7, 2),
    deptno               int
) partition by range ( year(hiredate) )(  -- 파티션 정의, range() 가 파티션 키 설정
	partition p0 values less than (1980),
	partition p1 values less than (1983),
	partition p2 values less than (1986),
	partition p3 values less than maxvalue 
);

desc emp00;


insert into emp00 values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);
insert into emp00 values( 7839, 'KING2', 'PRESIDENT', null, STR_TO_DATE ('17-11-1983','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE2', 'MANAGER', 7839, STR_TO_DATE('1-5-1983','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK2', 'MANAGER', 7839, STR_TO_DATE('9-6-1983','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES2', 'MANAGER', 7839, STR_TO_DATE('2-4-1983','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD2', 'ANALYST', 7566, STR_TO_DATE('3-12-1983','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH2', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN2', 'SALESMAN', 7698, STR_TO_DATE('20-2-1983','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD2', 'SALESMAN', 7698, STR_TO_DATE('22-2-1983','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN2', 'SALESMAN', 7698, STR_TO_DATE('28-09-1983','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER2', 'SALESMAN', 7698, STR_TO_DATE('8-9-1983','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES2', 'CLERK', 7698, STR_TO_DATE('3-12-1983','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER2', 'CLERK', 7782, STR_TO_DATE('23-1-1984','%d-%m-%Y'), 1300, null, 10);
insert into emp00 values( 7839, 'KING2', 'PRESIDENT', null, STR_TO_DATE ('17-11-1985','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE2', 'MANAGER', 7839, STR_TO_DATE('1-5-1985','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK2', 'MANAGER', 7839, STR_TO_DATE('9-6-1985','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES2', 'MANAGER', 7839, STR_TO_DATE('2-4-1985','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD2', 'ANALYST', 7566, STR_TO_DATE('3-12-1985','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH2', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN2', 'SALESMAN', 7698, STR_TO_DATE('20-2-1985','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD2', 'SALESMAN', 7698, STR_TO_DATE('22-2-1985','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN2', 'SALESMAN', 7698, STR_TO_DATE('28-09-1985','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER2', 'SALESMAN', 7698, STR_TO_DATE('8-9-1985','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES2', 'CLERK', 7698, STR_TO_DATE('3-12-1985','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER2', 'CLERK', 7782, STR_TO_DATE('23-1-1986','%d-%m-%Y'), 1300, null, 10);

commit;

select * from emp00;
select * from emp00 where hiredate='1986-01-23';  -- 정상 검색
select * from emp00 where hiredate='23-1-1986';  -- 검색이 안 되었음
select hiredate from emp00;
select year(hiredate) from emp00;

desc emp00;


-- ? 월 기준으로 데이터 나눠서 저장하기 
drop table emp00;

select month ('1986-01-23');  -- 1 
select month('23-01-1986'); -- 검색이 안 되었음 

CREATE TABLE emp00 (
    empno                int  NOT NULL,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint,
    hiredate             date,
    sal                  numeric(7, 2),
    comm                 numeric(7, 2),
    deptno               int
) partition by list ( month(hiredate) )(  
	partition p1 values in (1),
	partition p2 values in (2),
	partition p3 values in (3),
	partition p4 values in (4),
	partition p5 values in (5),
	partition p6 values in (6),
	partition p7 values in (7),
	partition p8 values in (8),
	partition p9 values in (9),
	partition p10 values in (10),
	partition p11 values in (11),
	partition p12 values in (12)
);

insert into emp00 values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE ('17-11-1981','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-09-1981','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10);
insert into emp00 values( 7839, 'KING2', 'PRESIDENT', null, STR_TO_DATE ('17-11-1983','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE2', 'MANAGER', 7839, STR_TO_DATE('1-5-1983','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK2', 'MANAGER', 7839, STR_TO_DATE('9-6-1983','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES2', 'MANAGER', 7839, STR_TO_DATE('2-4-1983','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD2', 'ANALYST', 7566, STR_TO_DATE('3-12-1983','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH2', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN2', 'SALESMAN', 7698, STR_TO_DATE('20-2-1983','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD2', 'SALESMAN', 7698, STR_TO_DATE('22-2-1983','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN2', 'SALESMAN', 7698, STR_TO_DATE('28-09-1983','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER2', 'SALESMAN', 7698, STR_TO_DATE('8-9-1983','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES2', 'CLERK', 7698, STR_TO_DATE('3-12-1983','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER2', 'CLERK', 7782, STR_TO_DATE('23-1-1984','%d-%m-%Y'), 1300, null, 10);
insert into emp00 values( 7839, 'KING2', 'PRESIDENT', null, STR_TO_DATE ('17-11-1985','%d-%m-%Y'), 5000, null, 10);
insert into emp00 values( 7698, 'BLAKE2', 'MANAGER', 7839, STR_TO_DATE('1-5-1985','%d-%m-%Y'), 2850, null, 30);
insert into emp00 values( 7782, 'CLARK2', 'MANAGER', 7839, STR_TO_DATE('9-6-1985','%d-%m-%Y'), 2450, null, 10);
insert into emp00 values( 7566, 'JONES2', 'MANAGER', 7839, STR_TO_DATE('2-4-1985','%d-%m-%Y'), 2975, null, 20);
insert into emp00 values( 7902, 'FORD2', 'ANALYST', 7566, STR_TO_DATE('3-12-1985','%d-%m-%Y'), 3000, null, 20);
insert into emp00 values( 7369, 'SMITH2', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20);
insert into emp00 values( 7499, 'ALLEN2', 'SALESMAN', 7698, STR_TO_DATE('20-2-1985','%d-%m-%Y'), 1600, 300, 30);
insert into emp00 values( 7521, 'WARD2', 'SALESMAN', 7698, STR_TO_DATE('22-2-1985','%d-%m-%Y'), 1250, 500, 30);
insert into emp00 values( 7654, 'MARTIN2', 'SALESMAN', 7698, STR_TO_DATE('28-09-1985','%d-%m-%Y'), 1250, 1400, 30);
insert into emp00 values( 7844, 'TURNER2', 'SALESMAN', 7698, STR_TO_DATE('8-9-1985','%d-%m-%Y'), 1500, 0, 30);
insert into emp00 values( 7900, 'JAMES2', 'CLERK', 7698, STR_TO_DATE('3-12-1985','%d-%m-%Y'), 950, null, 30);
insert into emp00 values( 7934, 'MILLER2', 'CLERK', 7782, STR_TO_DATE('23-1-1986','%d-%m-%Y'), 1300, null, 10);

commit;

select hiredate from emp00;
select month (hiredate) from emp00;


-- 이태형 작품
CREATE TABLE emp00 (
    empno                int  NOT NULL,
    ename                varchar(20),
    job                  varchar(20),
    mgr                  smallint ,
    hiredate             date,
    sal                  numeric(7,2),
    comm                 numeric(7,2),
    deptno               int
 ) partition by range( month(hiredate) )(
	partition m0 values less than (2),
	partition m1 values less than (3),
	partition m2 values less than (4),
	partition m3 values less than (5),
	partition m4 values less than (6),
	partition m5 values less than (7),
	partition m6 values less than (8),
	partition m7 values less than (9),
	partition m8 values less than (10),
	partition m9 values less than (11),
	partition m10 values less than (12),   -- 11 까지는 의미 
	partition m11 values less than maxvalue  -- 11까지의 데이터는 m10으로 설정 후 그 이후의 모든 데이터 12는 maxvalue 필수
 );