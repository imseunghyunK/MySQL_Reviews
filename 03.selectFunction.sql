-- 3.selectFunction.sql
/* db 구축
 * 1. 설치 + table 생성 및 데이터 저장
 * 2. aws - mysql : dbeaver
 * 2. 개인 시스템(local) - oracle 과 mysql : dbeaver, sqlplus(oracle), workbench(mysql)
 * 
 * 	mysql 하나를 workbench 와 dbeaver
 * 		- workbench database 생성 -> table 생성 -> insert -> select
 * 		- dbeaver로 mysql 접속 connection에 F5(새로고침) 필수
 * 			- workbench에서 작업했던 내용이 동기화
 */

/*
   내장 함수 종류
      1. 단일행 함수 - 입력한 행수(row) 만큼 결과 반환
      2. 집계(다중행, 그룹) 함수 - 입력한 행수와 달리 결과값 하나만 반환 
*/

-- 단일행 함수 : 입력 데이터 수만큼 출력 데이터
/* Mysql Db 자체적인 지원 함수 다수 존재
1. 숫자 함수 MySQL Numeric Functions
2. 문자 함수
3. 날짜 함수 

**/
   
-- mysql은 oracle과 달리 from절이 생략 가능
-- 2+3의 결과인 5 데이터 값 보유한 table은 없음, 현 로직은 연산 결과만 sql로 확인
select 2+3;


-- *** [숫자함수] ***
-- 1. 절대값 구하는 함수 : abs()
select 3.5, -3.5, +3.5;

select 3.5, abs(-3.5), abs(+3.5);



-- 2. 반올림 구하는 함수 : round(데이터 [, 반올림자릿수])
-- 반올림자릿수 : 소수점을 기준으로 양수는 소수점 이하 자리수 의미
         -- 음수인 경우 정수자릿수 의미
		-- -1 : 정수 첫 번째 자릿수에서 반올림
		-- 1 : 소수점 이하의 첫 자리 유효
select round(5.6), 5.6;
select round(56.66), 5.6;	 -- 소수점 이하 첫자리가 기준  57|5.6| 
select round(56.66, -1), 5.6; --  60|5.6|
select round(56.66, 1), 5.6; --  56.7|5.6|



-- 3. 지정한 자리수 이하 버리는 함수 : truncate()
-- 반올림 미적용
-- truncate(데이터, 소수자릿수)
-- 자릿수 : +(소수점 이하), -(정수 의미)
-- 참고 : 존재하는 table의 데이터만 삭제시 방법 : delete[복원]/truncate[복원불가]
select truncate(56.63, 1), 5.6; --  56.6|5.6|
select truncate(56.66, 1), 5.6; --  56.6|5.6|

select round(56.63, 1), 5.6; --  56.6|5.6|
select round(56.66, 1), 5.6; --  56.7|5.6|

  
-- 4. 나누고 난 나머지 값 연산 함수 : mod()
-- 모듈러스 연산자, % 표기로 연산, 오라클에선 mod() 함수명 사용
select mod(5,2);

-- 5. ? emp table에서 사번(empno)이 홀수인 사원의 이름(ename), 
-- 5. ? emp table에서 사번(empno)이 홀수(mod(값,2)=1)인 사원의 이름(ename), 
-- 사번(empno) 검색 
select empno from emp;

select mod(empno, 2) from emp;

select empno
from emp e
where mod(empno, 2) = 1;

select empno
from emp e
where mod(empno, 2) != 0;



-- 6. 제곱수 구하는 함수 : power()
select power(3,2); -- 9


-- *** [문자함수] ***
/* tip : 영어 대소문자 의미하는 단어들
대문자 : upper
소문자 : lower
철자 : case 
*/
-- 1. 대문자로 변화시키는 함수
-- upper() : 대문자[uppercase]
-- lower() : 소문자[lowercase]
-- emp 사원의 이름들 다 소문자로 변경해서 검색
select ename from emp;
select lower(ename) from emp; -- 원본 table의 데이터는 여전히 대문자, 단 검색 시 소문자로 변환해서 제공


-- 2. manager로 job 칼럼과 뜻이 일치되는 사원의 사원명 검색하기 
-- mysql은 데이터값의 대소문자 구분없이 검색 가능
-- 해결책 1 : binary()  대소문자 구분을 위한 함수
-- 해결책 2 : alter 명령어로 처리

select ename, job from emp;
-- 검색
select ename from emp where job='manager';

-- binary() 사용하셔서 job 컬럼의 대소문자 구분해서 검색
select ename from emp where job= binary('manager'); -- 검색x

-- 3. 문자열 길이 검색 : length()
select ename, length(ename) from emp;

select length('a'), length('가');

-- 4. 문자열 일부 추출 함수 : substr()
-- 서브스트링 : 하나의 문자열에서 일부 언어 발췌하는 로직의 표현
-- substr(데이터, 시작위치, 추출할 개수)
-- 시작위치 : 1부터 시작

select substr('abcdef', 2, 2); --bc 

-- 5. 년도 구분없이 2월에 입사한 사원(mm = 02)이름, 입사일 검색
-- date 타입에도 substr() 함수 사용 가능
-- 문자열 index 시작 - 1 
select hiredate from emp; -- 1980-12-17 yyyy-mm-dd
select ename, hiredate from emp where substr(hiredate, 6,2) = '02';

-- 년도만 검색
select substr(hiredate, 1,4) from emp; 

-- 월만 검색
select substr(hiredate, 6,2) from emp; 

-- 일만 검색
select substr(hiredate, 9,2) from emp; 



-- 7. 문자열 앞뒤의 잉여 여백 제거 함수 : trim()
/*length(trim(' abc ')) 실행 순서
   ' abc ' 문자열에 디비에 생성
   trim() 호출해서 잉여 여백제거
   trim() 결과값으로 length() 실행 */

select '  ab  ', length('  ab  '), length(trim('  ab  '));



-- *** [날짜 함수] ***
-- 1. ?어제, 오늘, 내일 날짜 검색 
-- 현재 시스템 날짜에 대한 정보 제공 함수
-- sysdate() & now(): 날짜 시분 초
	-- now() : 하나의 sql문장에서 다수 호출 시에 첫 번째 호출한 결과 값 공유\
	-- sysdate() : 호출할 때 마다 새롭게 호출
-- curdate() : 날짜, 연산 가능
select sysdate(); -- 2022-05-26 14:21:27|
select now(); -- 2022-05-26 14:21:28|
select curdate();  -- 2022-05-26|

-- sleep(초) : 적용한 초 단위로 잠시 대기
select now(), sleep(2), now(); -- 2022-05-26 14:23:12|       0|2022-05-26 14:23:12|
select sysdate(), sleep(2), sysdate(); -- 2022-05-26 14:23:31|       0|2022-05-26 14:23:33|

-- 일 단위 빼기 실행
select curdate()-1 as 어제, curdate() as 오늘;  -- 20220525|2022-05-26|

-- 초 단위 빼기 실행
select now(), now()-1; -- 2022-05-26 14:27:51|20220526142750|


-- *********************
-- 2.?emp table에서 근무일수 계산하기, 사번과 근무일수 검색
desc emp;
select curdate()-hiredate from emp; 

select curdate()-1980-12-17 from emp; -- 20218517 .. 틀림
select curdate()-'20220525' from emp; --  1 확인을 위한 sql 문장 직접 구성
select curdate()-'20220524' from emp; --  2 한번 더 확인을 위한 sql 문장 구성.. 맞음

select curdate()-'2022-05-25' from emp; --  20218504 포멧에 따른 확인 - 이상
select curdate()-'2022/05/25' from emp; --  20218504 포멧에 따른 확인 - 이상

-- 특정 사원 데이터로 sql 문장 도출하기 위한 test 데이터 선별을 위한 단순 검색
select ename, hiredate from emp; -- SMITH |1980-12-17|

-- 상단 정상 검색을 위한 확인 - 년도가 변경이 될 경우에 비정상적인 검색이 수행
-- ??? ******
select curdate()-'19801217' from emp where ename = 'SMITH'; -- 419309
select curdate()-hiredate from emp where ename = 'SMITH'; -- 419309

select '20220526'- '20220501' from emp where ename = 'SMITH'; -- 419309


-- 교육시작 경과일수
-- 순수 문자열을 날짜 형식으로 변환해서 검색
/* 
	yy/mm/dd 포멧으로 연산시에는 반드시 to_date() 라는 날짜 포멧으로
	변경하는 함수 필수 
	단순 숫자 형식으로 문자 데이터 연산시 정상 연산 
*/

-- str_to_date() : 문자열을 날짜로 변경
-- 날짜 계산시 고려 및 확인 필수
select str_to_date("2022 1 3", "%Y %m %d"); --  2022-01-03	
select str_to_date("20220103", "%Y %m %d"); --  2022-01-03

select '20220526'- '20220523' from emp where ename = 'SMITH'; -- 3.0
select '20220526'- '20210523' from emp where ename = 'SMITH'; -- 10003.0
select str_to_date('20220526', "%Y %m %d" ) - str_to_date('20210523', "%Y %m %d") from emp where ename = 'SMITH'; -- 10003

-- datediff() 일자를 계산시에 사용되는 함수
select datediff('20220526', now()); -- 0
select datediff('20220526', '20220523'); -- 3
select datediff('20220526', '20210523'); -- 368
select datediff('20220526', '20210526'); -- 365

-- 모범 답안
SELECT abs(DATEDIFF(CURDATE(), hiredate))+1 from emp;


-- 3. 특정 일수 및 개월수 더하는 함수 : ADDDATE()
-- 10일 이후 검색 
select now(); -- 2022-05-26 15:06:46
select adddate(now(), interval 10 day) -- 2022-06-05 15:06:54

-- 15분 이후
select adddate(now(), interval 15 minute) -- 2022-05-26 15:22:35


-- 4. emp table에서 입사일 이후 3개월 지난 일자 검색
select ename, hiredate as 입사일, adddate(hiredate, interval 3 month) as 입사후3개월 from emp e; 

-- 5. 두 날짜 사이의 개월수 검색 : months_between()
-- 오늘(sysdate) 기준으로 2021-09-19
select timestampdiff(month, '2021-09-19', sysdate())+1 as 개월수;

-- 특정 기준일로 오늘은 며칠차?(기준일 포함할 경우 +1)
-- timestamp : 1970년 1월 1일 0시 0분 0초부터 경과된 초 단위 수
-- 타임스탬프 또는 시간 표기는 특정한 시각을 나타내거나 기록하는 문자열이다. 
-- 둘 이상의 시각을 비교하거나 기간을 계산할 때 편리하게 사용하기 위해 고안되었으며, 일관성 있는 형식으로 표현된다. 
-- 실제 정보를 타임스탬프 형식에 따라 기록하는 행위를 타임스탬핑
select timestampdiff(day, '2022-05-01', now()) + 1 as 경과일수; -- 26
select timestampdiff(day, '2022-05-01', now()) as 경과일수; -- 25 기준일 미포함
select timestampdiff(day, '2021-05-26', now()) + 1 as 경과일수; -- 366

-- 오늘을 기준으로 100일은?(오늘이 1일로 계산할 경우 기준일 포함)
-- date_add() : 특정 날짜에서 연도나 월 일 또는 시간 등을 더하거나 빼기 가능한 함수
select date_add(now(), interval 99 day) as 100일후; 
select date_add(now(), interval -1 day) as 1일전; 

-- emp 직원들의 입사일 기준으로 5개월 후의 일자는?
select hiredate as 입사일, date_add(hiredate, interval 5 month) as 입사5개월후 from emp e; 

-- 근무 연차(입사하자마자 1년 차로 계산될 경우)
select timestampdiff(year, '2020-05-01', '2022-04-30') + 1;

select timestampdiff(year, hiredate, now()) + 1 as 근무연차 from emp;

-- 1년 365일중 오늘은 몇일차?
select dayofyear(now()); -- 146
select dayofyear('2022-01-01'); -- 1
select dayofyear('20220102'); -- 2
select dayofyear('2022-04-22'); -- 112

-- 7. 주어진 날짜를 기준으로 해당 달의 가장 마지막 날짜 : last_day()
select last_day(now());



-- 8. 2020년 2월의 마지막 날짜는?
select last_day('2020-02-02');




-- *** [형변환 함수] ***
-- Data type
-- DATETIME : 'YYYY-MM-DD HH:MM:SS'
-- DATE : 'YYYY-MM-DD'
-- TIME : 'HH:MM:SS'
-- CHAR : String, varchar
-- SIGNED : Integer(64bit), 부호 사용 가능
-- UNSIGNED : Integer(64bit), 부호 사용 불가
-- BINARY : binary String

-- cast() - 특정 type으로 형변환


-- 숫자를 문자로 변환
select cast(1 as char(10));

-- 문자를 숫자로 변환
select cast('1' as signed);


-- [2] STR_TO_DATE() : 날짜로 변경 시키는 함수

SELECT STR_TO_DATE("August 10 2022", "%M %d %Y"); -- 2022-08-10
SELECT STR_TO_DATE("jan 22 2022", "%M %d %Y"); -- 2022-01-22
SELECT STR_TO_DATE("oct 14 2022", "%M %d %Y"); -- 2022-10-14


-- 2. 문자열로 date타입 검색 가능[데이터값 표현이 유연함]
-- 1980년 12월 17일 입사한 직원명 검색
select ename from emp where hiredate='1980/12/17';
select ename from emp where hiredate='80/12/17';
select ename from emp where hiredate='1980-12-17';


-- *** 조건식 ***
/*
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
 */

-- 1. deptno 에 따른 출력 데이터
-- 10번 부서는 A로 검색/20번 부서는 B로 검색/그외 무로 검색
select deptno from emp;

-- 검색시 case ~ end 문장이 컬럼명으로 적용
select deptno,
	case
		when deptno = 10 then 'A'
		when deptno = 20 then 'B'
		else deptno 
	end
from emp;

-- 별칭 적용
select deptno,
	case
		when deptno = 10 then 'A'
		when deptno = 20 then 'B'
		else deptno 
	end as level
from emp;

-- 2. emp table의 연봉(sal) 인상계산
-- job이 ANALYST 5%인상(sal*1.05), SALESMAN 은 10%(sal*1.1) 인상, 
-- MANAGER는 15%(sal*1.15), CLERK 20%(sal*1.2) 인상
select ename, job, sal,
	case job
		when job = 'ANALYST' then sal*1.05
		when job = 'SALESMAN' then sal*1.1
		when job = 'MANAGER' then sal*1.15
		when job = 'CLERK' then sal*1.2
		else sal
	end as '인상된 연봉'
from emp;

-- 반지름 이하 삭제 ver.
select ename, job, sal,
	case job
		when job = 'ANALYST' then round(sal*1.05)
		when job = 'SALESMAN' then round(sal*1.1)
		when job = 'MANAGER' then round(sal*1.15)
		when job = 'CLERK' then round(sal*1.2)
		else round(sal)
	end as '인상된 연봉'
from emp;



