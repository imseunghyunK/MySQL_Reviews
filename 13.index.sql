-- 13.index.sql
/*
1. db의 빠른 검색을 위한 색인 기능의 index 학습
	- primary key는 기본적으로 자동 index로 설정됨 
	
	- DB 자체적으로 빠른 검색 기능 부여
		이 빠른 검색 기능 - index
	- 어설프게 사용자 정의 index 설정시 오히려 검색 속도 다운
	- 데이터 셋의 15% 이상의 데이터들이 잦은 변경이 이뤄질 경우 index 설정 비추

2. 주의사항
	- index가 반영된 컬럼 데이터가 수시로 변경되는 데이터라면 index 적용은 오히려 부작용
	
3. 문법
	CREATE INDEX index_name
	ON table_name (column1, column2, ...);
*/

use playdata;

-- 1. index용 검색 속도 확일을 위한 table 생성 
drop table if exists emp01;

-- 존재하는 talbe로 부터 복제시에는 제약조건은 미적용
create table emp01 as select * from emp;
desc emp01;

-- empno로 검색시에 빠른 검색이 가능하게 색인 기능 적용
create index idx_emp01_empno on emp01(empno);
desc emp01;

-- drop index
alter table emp01 drop index idx_emp01_empno;