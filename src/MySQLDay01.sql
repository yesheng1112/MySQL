-- 一:DQL语言的学习
-- 进阶1.基础查询
/*
  语法:
  select 查询列表
  from 表名;
  类似于：System.out.println(打印东西);

  特点：
    1.查询列表可以是:表中的字段，常量值，表达式，函数
    2.查询的结果是一个虚拟的表格
*/
-- 1.查询表中的单个字段
select last_name from employees;

-- 2.查询表中的多个字段
select last_name , salary , email from employees;

-- 3.查询表中的所有的字段
-- 方式一：
select employee_id,first_name,last_name,email,phone_number,job_id,salary,commission_pct,manager_id,department_id,hiredate from employees;
-- 方式二：
select * from employees;

-- 4.查询常量值
select 100;
select 'john';

-- 5.查询表达式
select 100*98;

-- 6.查询函数
select version();

-- 7.起别名
/*
 1.便于理解
 2.如果要查询的字段有重名的情况，使用别名可以区分开来
*/
-- 方式一:使用as
select 100%98 as 结果;
select last_name as 姓 ,first_name as 名 from employees;

--方式二:使用空格
select last_name 姓 , first_name 名 from employees;

-- 案例：查询salary，显示结果为out put
select salary as "out put" from employees;

-- 8.去重
-- 案例：查询员工表中涉及到的所有的部门编号
select distinct department_id from employees;

-- 9.+号的作用
/*
  java中的+号：
    1.运算符,两个操作数都为数值型
    2.连接符，只要有一个操作数位字符串

  mysql中的+号：
    仅仅只有一个功能：运算符

    select 100+90; 两个操作数都为数值型，则做加法运算
    select '123'+90; 只要其中一方为字符型，试图将字符型转换成数值型
                      如果转化成功，则继续做加法运算
    select 'john'+90; 如果转化失败，则将字符型数值转换成0
    select null+10; 只要其中一方为null，则结果肯定为null
*/
-- 案例：查询员工名和姓连接成一个字段，并显示为 姓名
select concat('a','b','c') as 结果;
select concat(last_name,first_name) as 姓名 from employees;

-- 进阶2：条件查询
/*
  语法：
    select
          查询列表
    from
          表名
    where
          筛选条件;

  分类：
    1.按条件表达式筛选
    条件运算符：> < = != <> >= <=
    2.按逻辑表达式筛选
    逻辑运算符：
      作用：用于连接条件表单式
              &&  ||  !
              and or not
      &&和and:两个条件都为true，结果为true，反之为false
      ||和or:只要有一个条件为true，结果为true，反之为false
      !或not:如果连接的条件本身为false，结果为true，反之为false
    3.模糊查询
        like
        between and
        in
        is null
*/
-- 一，按条件表达式筛选
-- 案例1:查询工资>12000的员工信息
select
  *
from
  employees
where
  salary > 12000;

-- 案例2: 查询部门编号不等于90号的员工名和部门编号
select
  last_name ,
  department_id
from
  employees
where
  department_id <> 90;

-- 二，按逻辑表达式筛选
-- 案例1：查询工资在10000到2000之间的员工名，工资以及奖金
select
  last_name,
  salary,
  commission_pct
from
  employees
where
  salary>=10000 and salary<=20000;

-- 案例2：查询部门编号不是在90到110之间，或者工资高于15000的员工信息
select
  *
from
  employees
where
  not (department_id>=90 and department_id<=110) or salary>15000;

-- 三，模糊查询
/*
  like
    特点：
      1.一般和通配符搭配使用
      通配符：
        % 任意多个字符，包含0个字符
        _ 任意单个字符
  between and
  in
  is null | is not null
*/
-- 1.like
-- 案例1：查询员工名中包含字符a的员工信息
select
  *
from
  employees
where
  last_name like '%a%';

-- 案例2：查询员工名中第三个字符为n,第五个字符为l的员工名和工资
select
  last_name,
  salary
from
  employees
where
  last_name like '__n_l%';

-- 案例3：查询员工名中第二个字符为_的员工名

-- 方式1:利用转译字符"\"
select
  last_name
from
  employees
where
  last_name like '_\_%';

-- 方式2:利用关键字escape指定转译的位置
select
  last_name
from
  employees
where
  last_name like '_$_%' escape '$';

-- 2.between and
/*
  1.使用between and 可以提高语句的简洁度
  2.包含临界值
  3.两个临界值不要调换顺序
*/
-- 案例1：查询员工编号在100到120之间的员工信息
select
  *
from
  employees
where
  employee_id >= 100 and employee_id <=120;
--------------------------------------------
select
  *
from
  employees
where
  employee_id between 100 and 120;

--3.in
/*
  含义：判断某字段的值是否属于in列表中的某一项
  特点：
    1.使用in提高语句简洁度
    2.in列表的值类型必须一致或兼容
    3.不支持通配符
*/
-- 案例：查询员工的工种编号是 IT_PROG , AD_VP , AD_PRES中的一个员工名和工种编号
select
  last_name,
  job_id
from
  employees
where job_id ='IT_PROG'or job_id='AD_VP'or job_id='AD_PRES';
----------------------------------------------
select
  last_name,
  job_id
from
  employees
where job_id in ('IT_PROG','AD_VP','AD_PRES');

-- 4. is null
/*
  =或<>不能用于判断null值
  is null 或 is not null 可以判断null值
*/
-- 案例1：查询没有奖金的员工名和奖金率
select
  last_name,
  commission_pct
from
  employees
where
  commission_pct is null ;
-- 案例2：查询有奖金的员工名和奖金率
select
  last_name,
  commission_pct
from
  employees
where
  commission_pct is not null ;

-- 安全等于 <=>
-- 案例1：查询没有奖金的员工名和奖金率
select
  last_name,
  commission_pct
from
  employees
where
  commission_pct <=> null ;

--案例2：查询工资为12000的员工信息
select
  last_name,
  commission_pct,
  salary
from
  employees
where
  salary <=> 12000;

-- is null pk <=>
-- is null:仅仅可以判断null值，可读性较高，建议使用
-- <=>:既可以判断null值，又可以判断普通的数值，可读性较低

--测试：查询员工工号为176的员工的姓名和部门号和年薪
select
  last_name,
  department_id,
  salary*12*(1+ifnull(commission_pct,0)) as 年薪
from
  employees
where
  employee_id=176;

-- 测试题
-- 1.查询没有奖金，且工资小于18000的salary，last_name
select
  salary,
  last_name
from
  employees
where
  commission_pct is null
and
  salary<18000;

-- 2.查询employees表中，job_id 不为 ‘IT’ 或者 工资为12000的员工信息
select
  *
from
  employees
where
  job_id <> 'IT'
or
  salary = 12000;

-- 3.查看departments表的结构，查询效果如下
desc departments;

-- 4.查询部门departments表中涉及到了那些位置编号
select
  distinct location_id
from
 departments;

-- 5.经典面试题：
-- 试问：select * from employees; 和 select * from employees where commission_pct like '%%' and last_name like '%%';
-- 结果是否一样？并说明原因
-- 不一样。如果判断的字段有null值

