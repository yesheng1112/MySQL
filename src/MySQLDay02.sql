-- 进阶3：排序查询
/*
引入：
  select * from employees;

语法：
  select 查询列表
  from 表
  [where 筛选条件]
  order by 排序列表 [asc|desc]

特点：
  1.asc代表的是升序，desc代表的是降序
  如果不写，默认是升序。
  2.order by 子句中可以支持单个字段，多个字段，表达式，函数，别名
  3.order by 字句一般是放在查询语句的最后面，limit字句除外
*/
-- 案例1：查询员工信息，要求工资从高到低排序
select  * from employees order by salary desc ;
-- 案例：查询员工信息，要求工资从低到高排序
select  * from employees order by salary asc ;

-- 案例2：查询部门编号>=90员工信息，按员工入职时间的先后进行排序[添加筛选条件]
select *
from employees
where employee_id>=90
order by hiredate asc ;

-- 案例3：按年薪的高低显示员工的信息和年薪[按表达式排序]
select *,salary*12*(1+ifnull(commission_pct,0)) 年薪
from employees
order by salary*12*(1+ifnull(commission_pct,0)) desc ;

-- 案例4：按年薪的高低显示员工的信息和年薪[按别名排序]
select *,salary*12*(1+ifnull(commission_pct,0)) 年薪
from employees
order by 年薪 desc ;

--案例5：按姓名的长度显示员工的姓名和工资[按函数排序]
select length (last_name) 字节长度,last_name,salary
from employees
order by length (last_name) desc ;

-- 案例6：查询员工信息，要求先按工资升序排序，再按员工编号降序排序[按多个字段排序]
select *
from employees
order by salary asc ,employee_id desc ;

--------------测试题---------------------
-- 1.查询员工的姓名和部门号和年薪，按年薪降序 按姓名升序
select last_name,department_id,salary*12*(1+ifnull(commission_pct,0)) 年薪
from employees
order by 年薪 desc ,last_name asc ;

-- 2.选择工资不在8000到17000的员工的姓名和工资，按工资降序
select last_name,salary
from employees
where salary not between 8000 and 17000
order by salary desc ;

-- 3.查询邮箱中包含e的员工信息，并先按邮箱的字节数降序，再按部门号升序
select * ,length (email)
from employees
where email like '%e%'
order by length (email) desc ,department_id asc ;

-- 进阶4：常见函数
/*
  概念：类似于java的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
  好处：1.隐藏了实现细节 2.提高代码的重用性
  调用：select 函数名(实参列表) [from 表];
  特点：
    1.叫什么(函数名)
    2.干什么(函数功能)
  分类：
    1.单行函数
    如 concat,length ifnull等
    2.分组函数
    功能：做统计使用，又称为统计函数，聚合函数，组函数
  常见函数：
    字符函数:
      length
      concat
      substr
      instr
      trim
      upper
      lower
      lpad
      rpad
      replace

    数学函数:
      round
      ceil
      floor
      truncate
      mod

    日期函数：
      now
      curdate
      curtime
      year
      month
      monthname
      day
      hour
      minute
      second
      str_to_date
      date_format

    其他函数：
      version
      database
      user

    控制函数：
      if
      case
*/

-- 一，字符函数
-- 1.length 获取参数值的字节个数
select length ('john');
select length ('张三丰hahaha');

-- 显示客户端使用的编码
show variables like '%char%';

-- 2.concat 拼接字符串
select concat(last_name,'_',first_name) from employees;

-- 3.upper , lower
select upper('john');
select lower('JOHN');

-- 示例：将姓变大写，名变小写，然后拼接
select concat(upper(last_name),lower(first_name)) 姓名 from employees;

-- 4.substr substring
-- 注意：索引从1开始
-- 截取从指定索引处后面所有字符
select substring('李莫愁爱上了陆展元',7) out_put;

-- 截取从指定索引处指定字符长度的字符
select substring('李莫愁爱上了陆展元',1,3) out_put;

-- 案例：姓名中首字符大写，其他字符小写然后用_拼接,显示出来
select concat(upper(substr(last_name,1,1)),'_',lower(substr(last_name,2))) out_put
from employees;

-- 5.instr 返回字串第一次出现的索引，如果找不到返回0
select instr('杨不殷六侠悔爱上了殷六侠','殷八侠') as out_put;

-- 6.trim
select length (trim('  张翠山   ')) as out_put;

select trim('a' from 'aaaaaaa张aaaa翠aaaa山aaaaaaa') as out_put;

-- 7.lpad 用指定的字符实现左填充指定长度
select lpad('殷素素',2,'*') as out_put;

-- 8.rpad 用指定的字符实现右填充指定长度
select rpad('殷素素',12,'ab') as out_put;

-- 9.replace 替换
select replace('周芷若周芷若周芷若张无忌爱上了周芷若','周芷若','赵敏') as out_put;

-- 二，数学函数
-- 1.round四舍五入
select round(-1.65);
-- 小数点后面保存两位并四舍五入
select round(1.567,2)

-- 2.ceil 向上取整,返回>=该参数的最小整数
select ceil(1.52);

-- 3.floor 向下取整,返回<=该参数的最大整数
select floor(1.2);

-- 4.truncate截断小数点后面保留1位，直接截断
select truncate(1.65,1);

-- 5.mod取余
/*
  mod(a,b) : a-a/b*b
  mod(-10,-3) :-10-(-10)/(-3)*(-3)=-1;
*/
select mod(10,3);
select 10%3;

-- 三，日期函数
-- 1.now返回当前系统日期+时间
select now();

-- 2.curdate 返回当前系统日期，不包含时间
select curdate();

-- 3.curtime 放回当前时间，不包含日期
select curtime();

-- 4.可以获取指定的部分，年(year)，月(month)，日(day)，小时(hour)，分钟(minute)，秒(second)
select year(now()) 年;
select year('1998-1-1') 年;

select year(hiredate) 年 from employees;

select month (now()) 月;
select monthname(now()) 月;

-- 5.str_to_date将日期格式的字符转换成指定格式的日期
-- 常见的转换格式
/*
  %Y  四位的年份
  %y  2位的年份
  %m  月份(01,02,...11,12)
  %c  月份(1,2,3...11,12)
  %d  日(01,02...)
  %H  小时(24小时制)
  %h  小时(12小时制)
  %i  分钟(00,01...59)
  %s  秒(00,01,59)
*/
select str_to_date('1998-3-2','%Y-%c-%d') as out_put;

-- 查询入职日期为1992-4-3的员工信息
select * from employees where hiredate = '1992-4-3';

select * from employees where hiredate = str_to_date('4-3 1992','%c-%d %Y');

-- 6.date_format:将日期转换成字符
select date_format(now(),'%Y年%m月%d日') as out_put;

-- 查询有奖金的员工名和入职日期(xx月/xx日 xx年)
select last_name,date_format(hiredate,'%m月/%d日 %y年') 入职日期
from employees;

-- 四，其他函数
-- 查询版本号
select version();
-- 查询当前使用的数据库
select database();
-- 查询当前登录的用户
select user();

-- 五，流程控制函数
-- 1.if函数：类似if else的效果
select if(10>5,'大','小');

select last_name,commission_pct,if(commission_pct is null ,'没奖金，呵呵','有奖金，嘻嘻') 备注
from employees;

-- 2.case函数的使用一:switch case 的效果
/*
  switch(变量或表达式){
      case 常量1: 语句1;break;
      ...
      default:语句n;break;
    }

  mysql中
    case 要判断的字段或表达式
    when 常量1 then 要显示的值1或语句1;
    when 常量2 then 要显示的值2或语句2;
    ...
    else 要显示的值n或语句n
    end
*/
 /*
  案例：查询员工的工资，要求
  部门号=30,显示的工资为1.1倍
  部门号=40,显示的工资为1.2倍
  部门号=50,显示的工资为1.3倍
  其他的部门,显示的工资为原工资
 */
select salary 原始工资,department_id,
case department_id
when 30 then salary * 1.1
when 40 then salary * 1.2
when 50 then salary * 1.3
else salary
end as 新工资
from employees;

-- 3.case函数的使用二：类似于 多重if
/*
  java中：
    if(条件1){
      语句1;
    }else if(条件2){
      语句2;
    }
    ...
    else{
      语句n;
    }

  mysql中:
    case
    when 条件1 then 要显示的值1或语句1
    when 条件2 then 要显示的值2或语句2
    ...
    else 要显示的值n或语句n
    end
*/
-- 案例：查询员工的工资的情况
/*
  如果工资>20000,显示A级别
  如果工资>15000,显示B级别
  如果工资>10000,显示C级别
  否则，显示D级别
*/
select salary,
case
when salary>20000 then 'A'
when salary>15000 then 'B'
when salary>10000 then 'C'
else 'D'
end as 工资级别
from employees;

-------------------测试----------------------------------
-- 1.显示系统时间(注：日期+时间)
select now();

-- 2.查询员工号，姓名，工资，以及工资提高百分之20后的结果(new salary)
select employee_id,last_name,salary*1.2 "new salary"
from employees;

-- 3.将员工的姓名按首字母排序，并写出姓名的长度(length)
select length(last_name) 长度,substring(last_name,1,1) 首字符,last_name
from employees
order by 首字符;

-- 4.做一个查询，产生下面的结果
-- <last_name>earns<salary>monthly but wants<salary*3>
-- Dream Salary
-- King earns 24000 monthly but wants 72000
select concat(last_name,'earns',salary,'monthly but wants',salary*3)
as "Dream Salary"
from employees
where salary=24000;

-- 5.使用case-when，按照下面的条件：
-- job            grade
-- AD_PRES          A
-- ST_MAN           B
-- IT_PROG          C
-- SA_REP           D
-- ST_CLERK         E
select last_name,job_id as job,
case job_id
when 'AD_PRES' then 'A'
when 'ST_MAN' then 'B'
when 'IT_PROG' then 'C'
when 'SA_REP' then 'D'
when 'ST_CLERK' then 'E'
end as grade
from employees
where job_id = 'AD_PRES';

-- 二，分组函数
/*
  功能：用作统计使用，又称为聚合函数或统计函数或组函数

  分类：
  sum 求和 , avg 平均值 ，max 最大值 ， min 最小值 ，count 计算个数

  特点：
    1.sum,avg 一般用于处理数值型
      max,min,count可以处理任何类型
    2.以上分组函数都忽略null值
    3.可以和distinct搭配实现去重的运算
    4.count函数的单独使用
      一般使用count(*)用作统计行数
    5.和分组函数一同查询的字段要求是group by后的字段
*/
-- 1.简单的使用
select sum(salary) from employees;
select avg(salary) from employees;
select min(salary) from employees;
select max(salary) from employees;
select count(salary) from employees;

select sum(salary) 和, avg(salary) 平均 , min(salary) 最低
, max(salary) 最高 , count(salary) 个数 from employees;

select sum(salary) 和, round(avg(salary),2) 平均 , min(salary) 最低
, max(salary) 最高 , count(salary) 个数 from employees;

-- 2.参数类型支持那些类型
select sum(last_name) ,avg(last_name) from employees;
select sum(hiredate) ,avg(hiredate) from employees;

select max(last_name),min(last_name),count(last_name) from employees;
select max(hiredate),min(hiredate),count(hiredate) from employees;

select count(commission_pct) from employees;

-- 3.是否忽略null
select sum(commission_pct) , avg(commission_pct),
sum(commission_pct)/35, sum(commission_pct)/107
from employees;

select count(commission_pct) from employees;

select max(commission_pct),min (commission_pct) from employees;

-- 4.和distinct搭配使用
select sum(distinct salary),sum(salary) from employees;

select count(distinct salary),count(salary) from employees;

-- 5.count函数的详细介绍
-- 效率：
-- MYISAM 存储引擎下，count(*)效率最高
-- INNODB 存储引擎下，count(*)和count(1)的效率差不多，比count(字段)要高一些
select count(salary) from employees;

select count(*) from employees;

select count(1) from employees;

-- 6.和分组函数一同查询的字段有限制
select employee_id,avg(salary) from employees;

--------------------------测试------------------------------------
-- 1.查询公司员工工资的最大值，最小值，平均值，总和
select max(salary) 最大 , min(salary) 最小 , round(avg(salary),2) 平均 , sum(salary) 总和 from employees;

-- 2.查询员工表中的最大入职时间和最小入职时间的相差天数
-- datediff函数计算两个日期相差的天数
select datediff(max(hiredate),min(hiredate)) DIFFRENCE from employees;

-- 3.查询部门编号为90的员工个数
select count(*) 个数 from employees where department_id = 90;

-- 进阶5：分组查询
/*
  语法：
    select 分组函数,列(要求出现在group by的后面)
    from 表
    [where 筛选条件]
    group by 分组的列表
    [order by 子句]
  注意：
    查询列表必须特殊，要求是分组函数和group by后出现的字段

  特点：
    1.分组查询中的筛选条件分为两类
                   数据源            位置                  关键字
    分组前筛选      原始表            group by子句的前面       where
    分组后筛选      分组后的结果集      group by子句的后面       having

    1).分组函数做条件肯定放在having字句中
    2).能用分组前筛选的，就优先考虑使用分组前筛选

    2.group by 子句支持单个字段分组，多个字段分组(多个字段之间用逗号隔开没有顺序要求)
    表达式或函数(用的较少)
    3.也可以添加排序(排序放在这个分组查询的最后)
*/
-- 引入：查询每个部门的平均工资

-- 简单的分组查询
-- 案例1：查询每个工种的最高工资
select max(salary),job_id
from employees
group by job_id;

-- 案例2：查询每个位置上部门个数
select count(*) ,location_id
from departments
group by location_id;

-- 添加分组前筛选条件
-- 案例1：查询邮箱中包含a字符的，每个部门的平均工资
select avg(salary),department_id
from employees
where email like '%a%'
group by department_id;

-- 案例2:查询有奖金的每个领导手下员工的最高工资
select max(salary),manager_id
from employees
where commission_pct is not null
group by manager_id;

-- 添加分组后筛选条件
-- 案例1：查询那个部门的员工个数>2
-- 1.查询每个部门的员工个数
select count(*),department_id
from employees
group by department_id;

-- 2.根据1的结果进行筛选，查询那个部门的员工个数>2
select count(*),department_id
from employees
group by department_id
having count(*)>2;

-- 案例2：查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
-- 1.查询每个工种有奖金的员工的最高工资
select max(salary),job_id
from employees
where commission_pct is not null
group by job_id;
-- 2.根据1的结果继续筛选，最高工资>12000
select max(salary),job_id
from employees
where commission_pct is not null
group by job_id
having max(salary)>12000;

--案例3：查询领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个，以及其最低工资
-- 1.查询领导的每个领导手下的固定最低工资
select min(salary),manager_id
from employees
group by manager_id;
-- 2.添加筛选条件：编号>102
select min(salary),manager_id
from employees
where manager_id > 102
group by manager_id;
-- 3.添加筛选条件：最低工资>5000
select min(salary),manager_id
from employees
where manager_id > 102
group by manager_id
having min(salary)>5000;

--按表达式或函数分组
--案例：按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些
--1.查询每个长度的员工个数
select count(*),length(last_name) len_name
from employees
group by length(last_name) ;

--2.添加筛选条件
select count(*) c,length(last_name) len_name
from employees
group by len_name
having c > 5;

-- 按多个字段分组,后面字段一样的分组
-- 案例：查询每个部门每个工种的员工的平均工资
select avg(salary),department_id,job_id
from employees
group by department_id,job_id;

--添加排序
-- 案例：查询每个部门每个工种的员工的平均工资，并且按平均工资的高低显示
select avg(salary) a,department_id,job_id
from employees
where department_id is not null
group by department_id,job_id
having a>10000
order by a desc ;

----------------------------------测试---------------------------------------
-- 1.查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
select max(salary) , min(salary) , avg(salary) , sum(salary),job_id
from employees
group by job_id
order by job_id;

-- 2.查询员工最高工资和最低工资的差距(DIFFERENCE)
select max(salary) - min(salary) DIFFERENCE
from employees;

-- 3.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
select min(salary),manager_id
from employees
where manager_id is not null
group by manager_id
having min(salary) >= 6000;

-- 4.查询所有部门的编号，员工数量和工资平均值，并按平均工资降序
select department_id,count(*),avg(salary) a
from employees
group by department_id
order by a desc ;

-- 5.选择具有各个job_id的员工人数
select count(*) 个数,job_id
from employees
group by job_id;

-- 进阶6：连接查询
/*
  含义：又称多表查询，当查询的字段来自于多个表时，就会用到连接查询
  笛卡尔乘积现象：表1 有m行，表2有n行，结果=m*n行
  发生原因：没有有效的连接条件
  如何避免：添加有效的连接条件
  分类：
    按年代分类：
      sql92标准：仅仅支持内连接
      sql99标准[推荐]：支持内连接+外连接(左外和右外)+交叉连接
    按功能分类：
      内连接：
        等值连接：
        非等值连接：
        自连接：
      外连接：
        左外连接：
        右外连接：
        全外连接：
      交叉连接：
*/
select * from beauty;

select * from boys;

select name,boyName from boys,beauty
where beauty.boyfriend_id = boys.id;

-- 一，sql92标准
-- 1.等值连接
/*
  1.多表等值连接的结果为多表的交集部分
  2.n表连接，至少要n-1个连接条件
  3.多表的顺序没有要求
  4.一般需要为表起别名
  5.可以搭配前面介绍的所有字句使用，比如排序，分组，筛选
*/
-- 案例1：查询女神名和对应的男神名
select name,boyName
from boys,beauty
where beauty.boyfriend_id = boys.id;

-- 案例2:查询员工名和对应的部门名
select last_name,department_name
from employees,departments
where employees.department_id = departments.department_id;

-- 2.为表起别名
/*
  1.提高语句的简洁度
  2.区分多个重名的字段
  注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定
*/
-- 查询员工名，工种号，工种名
select last_name,e.job_id,job_title
from employees e ,jobs j
where e.job_id = j.job_id;

-- 3.两个表顺序是否可以调换
-- 查询员工名，工种号，工种名
select last_name,e.job_id,job_title
from jobs j,employees e
where e.job_id = j.job_id;

-- 4.可以加筛选
-- 案例1：查询有奖金的员工名，部门名
select last_name,department_name,commission_pct
from employees e,departments d
where e.department_id=d.department_id
and e.commission_pct is not null ;

--案例2：查询城市名中第二个字符为o的部门名和城市名
select department_name,city
from departments d ,locations l
where d.location_id = l.location_id
and city like '_o%';

-- 5.可以加分组
-- 案例1：查询每个城市的部门个数
select count(*) 个数,city
from locations l ,departments d
where d.location_id = l.location_id
group by city;

-- 案例2：查询出有奖金的每个部门名和部门的领导编号和该部门的最低工资
select department_name,d.manager_id,commission_pct,min(salary)
from departments d ,employees e
where d.department_id = e.department_id
and e.commission_pct is not null
group by department_name,d.manager_id;

-- 6.可以加排序
-- 案例：查询每个工种的工种名和员工的个数,并且按员工个数降序
select job_title , count(*)
from employees e ,jobs j
where e.job_id = j.job_id
group by job_title
order by count(*) desc ;

-- 7.可以实现三表连接
-- 案例：查询员工名，部门名和所在的城市
select last_name,department_name,city
from employees e ,departments d ,locations l
where e.department_id = d.department_id
and l.location_id = d.location_id
and city like 's%'
order by department_name desc ;

-- 2.非等值连接
-- 案例1：查询员工的工资和工资级别
select salary,grade_level
from employees e ,job_grades g
where salary between g.lowest_sal and g.highest_sal;

-- 3.自连接
-- 案例：查询员工名和上级的名称
select e.employee_id,e.last_name,m.employee_id,m.last_name
from employees e ,employees m
where e.manager_id = m.employee_id;

------------------------测试-----------------------------------------
-- 1.显示员工表的最大工资，工资平均值
select max(salary),avg(salary) from employees;

-- 2.查询员工的employee_id,job_id,last_name,按department_id降序，salary升序
select employee_id,job_id,last_name from employees order by department_id desc ,salary asc ;

-- 3.查询员工表的job_id中包含a 和e 的，并且a在e的前面
select job_id from employees where job_id like '%a%e%';

