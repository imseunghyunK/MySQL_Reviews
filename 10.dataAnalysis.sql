-- mysql SCOTT/TIGER
/*
1. table의 각 컬럼들 분석
CREATE TABLE titanic_raw
(	passengerid  INT, 			- 승객 id pk  
	survived     INT,			- 생존 여부(0:사망, 1:생존)
	pclass       INT,			- 객실등급 (1, 2, 3)
	name         VARCHAR(100),	- 이름
	gender       VARCHAR(50),	- 성별 (male:남성, female:여성)
	age          DOUBLE,		- 나이
	sibsp        INT,			- 동반한 형제 및 배우자 수
	parch        INT,			- 동반한 부모 및 자녀 수
	ticket       VARCHAR(80),	- 티켓번호
	fare         DOUBLE,		- 요금
	cabin        VARCHAR(50) ,	- 객실 번호
	embarked     VARCHAR(20),	- 탑승 항구(C:프랑스 항구, Q:아일랜드 항구, S:영국 항구)
	PRIMARY KEY (passengerid)
);

2. table의 데이터를 정제
	- survived : 0(사망), 1(생존)
	- embarked : 탑승 항구(C:프랑스 항구, Q:아일랜드 항구, S:영국 항구)
	
3. row 데이터를 정제해서 table을 생성
	방법1 : 기존 table 삭제 + sql파일 오픈해서 모두 변경등의 수작업
			- 비추
	방법2 : 기존 table 삭제 + raw table의 데이터들을 기반으로 새로운 정제된 table 만들기
			- 권장
	...
*/

use playdata;

-- titanic 원데이터 검색
select * from titanic_raw;
 

-- case when then 문장 학습을 위한 table 
drop table if exists emp01;

create table emp01 as select sal, comm, 
	case job
		when 'ANALYST' then sal*1.05
		when 'SALESMAN' then sal*1.1
		when 'MANAGER' then sal*1.15
		when 'CLERK' then sal*1.2
		else sal
	end as '연봉인상'
from emp;

-- sal, comm, 연봉인상 컬럼을 보유한 새로운 table 생성 
select * from emp01;


-- raw 정제해서 새로운 table 생성

-- 1차 연습 : 생존 컬럼만으로 사망, 생존 데이터로 변환 가능한 여부만 확인
-- titanic_raw 의 survived 컬럼값으 0이면 사망, 1이면 생존으로 검색
select survived, 
	case survived
		when 0 then '사망'
		else '생존'
	end as 정제결과 
from titanic_raw;


-- 2차 연습 : 생존 데이터 정제 성공후 titanic table 생성
-- 일반 컬럼과 case문으로 새로운 table 생성 여부 확인 : 가능
create table titanic as select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived 
from titanic_raw;

select * from titanic;


-- 3차 연습 : 항구 정보를 명확하게 정제해서 적용
-- embarked : 탑승 항구(C:프랑스 항구, Q:아일랜드 항구, S:영국 항구) 적용 titanic table 생성
-- 컬럼 : passengerid, survived, embarked
drop table if exists titanic;

-- 3차 -1 연습 : 항구 정보 정제해서 단순 검색
select passengerid, 
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 
from titanic_raw;

-- 3차 -2 연습 : survived컬럼과 embarked 컬럼 만으로 단순 검색 
select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived,
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 	
from titanic_raw;

-- 3차 -3 마무리 : survived컬럼과 embarked 컬럼 적용해서 정제된 데이터로 table 생성 
create table titanic as select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived,
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 	
from titanic_raw;

select * from titanic;

-- raw table기반으로 case 사용해서 새로운 컬럼 생성시에는 데이터값 기준으로 컬럼 타입이 정해짐
desc titanic_raw; -- survived  int
desc titanic; -- survived varchar(2) 문자열 타입으로 자동 적용

-- byte 조회
select length(survived) from titanic;


-- 분석
drop table if exists titanic;
create table titanic as select passengerid, 
	case survived
		when 0 then '사망'
		else '생존'
	end as survived,
	pclass, name, gender, age, sibsp, parch, ticket, fare, cabin, 
	case embarked
		when 'C' then '프랑스 항구'
		when 'Q' then '아일랜드 항구'
		else '영국 항구'
	end as embarked 	
from titanic_raw;

desc titanic;

-- 성별 생존자 수와 사망자 수 검색 : 여자, 남자 구분, 여자중에서 생존, 사망 구분, 남자중에서 생존, 사망 구분 
-- 성별 (group by), 수(count())

-- 논리적인 오류 검색 문장
select gender, survived, count(*) from titanic; -- male  |사망      |    1309|

select count(*) from titanic; -- 1309

select * from titanic;

-- 모범 답안
-- 성별 인원수 검색
select gender, count(*) 
from titanic
group by gender;


/* 논리적인 검색 오류 
gender|survived|count(*)|
------+--------+--------+
male  |사망      |     843|
female|생존      |     466|
 */
select gender, survived, count(*) 
from titanic
group by gender;


-- 성별, 생존 여부별 구분해서 검색 
select gender, survived, count(*)
from titanic
group by gender, survived;

-- 성별, 생존 여부별 구분해서 검색 + 성별 정렬
select gender, survived, count(*)
from titanic
group by gender, survived
order by gender asc;

select gender, survived, count(*)
from titanic
group by gender, survived
order by gender desc;

-- order by 절에 gender 별 정렬 후 survived 정렬 적용
select gender, survived, count(*)
from titanic
group by gender, survived
order by gender, survived desc;

-- 검색된 컬럼 순서에 맞게 번호로 정렬 가능
select gender, survived, count(*)
from titanic
group by gender, survived
order by 1, 2 desc;

-- age 순으로 정렬
select age from titanic;

-- 오름차순 정렬 단 null값 먼저 검색
select age from titanic order by age asc;   

-- 내림차순 정렬 null 값 마지막으로 검색
select age from titanic order by age desc;   

select age, count(*) from titanic group by age;

-- 검색된 컬럼 age를 기준으로 오름차순 정렬
-- 검색된 결과의 컬럼 순번의 순서값으로 정렬 가능
select age, count(*) from titanic group by age order by 1 asc;

select age, count(*) from titanic group by age order by 1 desc;

select * from titanic;
              
-- ? 연령대별 생존자 수와 사망자 수 조회
-- 10대 이하 :  age between 0 and 9     1.10대이하
-- 각 연령대별 : case when   then


-- 최고령자 검색
select max(age) from titanic;  -- 80.0
select age, count(*) from titanic group by age order by 1 desc; -- 80.0 1명/ 76 1명  .. 70대는 10여명 정도

-- 70이상은 데이터가 적으니 10대~~ 60대까지 구분 후 나머지 데이터를 70대 이상으로 처리 하는 경우
-- age값이 null 인 경우 70대 이상으로 처리되어 의미없는 데이터 검색
-- 유의미한 관점 : 
select case when age between  0 and  9 then '1.10대이하' 
            when age between 10 and 19 then '2.10대'
            when age between 20 and 29 then '3.20대'
            when age between 30 and 39 then '4.30대'
            when age between 40 and 49 then '5.40대'
            when age between 50 and 59 then '6.50대'
            when age between 60 and 69 then '7.60대'
            else '8.70대 이상'
       end ages,
       survived,
       count(*) cnt
 from titanic
 group by 1, 2
 order by 1, 2;

-- null 데이터에 대한 부분은 알수 없음으로 처리 권장 
select case when age between  0 and  9 then '1.10대이하' 
            when age between 10 and 19 then '2.10대'
            when age between 20 and 29 then '3.20대'
            when age between 30 and 39 then '4.30대'
            when age between 40 and 49 then '5.40대'
            when age between 50 and 59 then '6.50대'
            when age between 60 and 69 then '7.60대'
            when age is null           then '9.알수없음'
            else '8.70대 이상'
       end ages, survived, count(*) cnt
 from titanic
 group by 1, 2
 order by 1, 2 asc;



select case when age between  0 and  9 then '1.10대이하' 
            when age between 10 and 19 then '2.10대'
            when age between 20 and 29 then '3.20대'
            when age between 30 and 39 then '4.30대'
            when age between 40 and 49 then '5.40대'
            when age between 50 and 59 then '6.50대'
            when age between 60 and 69 then '7.60대'
            when age is null           then '9.알수없음'
            else '8.70대 이상'
       end ages, pclass, survived, count(*) cnt
 from titanic
 group by 1, 2
 order by 1, 2 asc;

-- 연령대별, 객실 등급별 생존자, 사망자 수 조회
-- 1등급 : 높은 등급
select case when age between  0 and  9 then '1.10대이하' 
            when age between 10 and 19 then '2.10대'
            when age between 20 and 29 then '3.20대'
            when age between 30 and 39 then '4.30대'
            when age between 40 and 49 then '5.40대'
            when age between 50 and 59 then '6.50대'
            when age between 60 and 69 then '7.60대'
            when age is null           then '9.알수없음'
            else '8.70대 이상'
       end ages, pclass, survived, count(*) cnt
 from titanic
 group by 1, 2, 3
 order by 1, 2, 3 asc;


-- ? 객실 등급별 어떤 등급의 사람들이 가장 많이 사망했는지 알아내기 위한 본인만의 sql문장 만들어 보기 
-- ? 객실 등급별(pclass, group by) 어떤 등급의 사람들이 가장 많이 사망(survived='사망')했는지 알아내기 위한 본인만의 sql문장 만들어 보기 
-- sql 문장

select age, count(*) as 인원수 from titanic 
group by age 
order by 인원수 desc limit 2;

select pclass, survived, count(*)
from titanic
where survived = '사망'
group by pclass
order by 3 desc;

-- 유상민 작품
SELECT pclass as 객실등급, survived as 생존여부, COUNT(*) as '사망자 수'
from titanic WHERE survived = '사망'
group by pclass, survived
ORDER by survived asc LIMIT 1;


-- 신재훈 작품
-- 기존 방식으로 검색 후에 그렇다면??? 혹시 3등급 pclass에 가장 많은 사람이 탑승?
-- 비율 등이 필요, 총인원수 및 사망률 검색
select
	case pclass
		when 1 then ' 1등석 '
		when 2 then ' 2등석 '
		else 		' 3등석 '
	end '객실등급',
	count(pclass) '총 인원수', 
	count(case when survived = '사망' then 1 end)as '사망자 수',
	(count(case when survived = '사망' then 1 end)/count(pclass))*100 as '사망율 (%)'
from titanic
group by 1
order by 1;