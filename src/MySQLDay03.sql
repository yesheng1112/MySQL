-- 二，sql99语法
/*
语法：
  select 查询列表
  from 表1 别名 [连接类型]
  join 表2 别名
  on 连接条件
  [where 筛选条件]
  [group by 分组]
  [having 筛选条件]
  [order by 排序列表]

分类：
  内连接:inner
  外连接
    左外:left [outer]
    右外:right [outer]
    全外:full [outer]
  交叉连接:cross
*/

-- 一)内连接
/*
  语法：
    select 查询列表
    from 表1 别名
    inner join 表2 别名
    on 连接条件;
  分类：
    等值
    非等值
    自连接
  特点：
    1.添加排序，分组，筛选
    2.inner 可以省略
    3.筛选条件放在where 后面，连接条件放在on后面，提高分离性，便于阅读
    4.inner join连接和sql92语法中的等值连接效果是一样的，都是查询多表交集的部分
*/
-- 1.等值连接
-- 1).查询员工名，部门名
select last_name,department_name
from employees e
inner join departments d
on e.department_id = d.department_id;

-- 2).查询名字中包含e的员工名和工种名(筛选)
select  last_name, job_title
from employees e
inner join jobs j
on e.job_id = j.job_id
where last_name like '%e%';

-- 3).查询部门个数>3的城市名称和部门个数，(分组+筛选)
-- ①查询每个城市的部门个数
-- ②在①结果上筛选满足条件的
select city,count(*) 部门个数
from departments d
inner join locations l
on d.location_id = l.location_id
group by city
having count(*) > 3;

-- 4).查询那个部门员工个数>3的部门名和员工个数，并按个数降序(排序)
-- ①查询每个部门的员工个数
-- ②在①的结果上筛选员工个数>3的记录，并排序
select department_name,count(*) 员工个数
from employees e
inner join departments d
on e.department_id = d.department_id
group by department_name
having count(*) >3
order by count(*) desc ;


-- 5).查询员工名，部门名，工种名，并按部门名降序
select last_name,department_name,job_title
from employees e
inner join departments d
on e.department_id = d.department_id
inner join jobs j
on e.job_id = j.job_id
order by department_name desc ;

-- 二),非等值连接
-- 查询员工的工资级别
select salary,grade_level
from employees e
inner join job_grades g
on e.salary between g.lowest_sal and g.highest_sal;

-- 查询工资级别个数>20的个数，并且按工资级别降序排序
select grade_level,count(*) 个数
from employees e
inner join job_grades g
on e.salary between g.lowest_sal and g.highest_sal
group by grade_level
having count(*) >20
order by grade_level desc ;

-- 三).自连接
-- 查询姓名中含字符k的员工的名字，上级的名子
select e.last_name,m.last_name
from employees e
inner join employees m
on e.manager_id = m.employee_id
where e.last_name like '%k%';

-- 二.外连接
/*
  应用场景：用于查询一个表中有，另一个表没有的记录
  特点：
    1.外连接的查询结果为主表中的所有记录
      如果从表中有和它匹配的，则显示匹配的值
      如果从表中没有和它匹配的，则显示null
      外连接查询结果=内连接结果+主表中有而从表中没有的记录
    2.左外连接，left join左边的是主表
      右外连接，right join右边的是主表
    3.左外和右外交换两个表的顺序，可以实现同样的效果
    4.全外连接=内连接的结果+表1中有但表2中没有的+表2中有但表1没有的
*/
-- 引入：查询男朋友不在男神表的女神名
-- 左外连接
select b.name
from beauty b
left outer join boys bo
on b.boyfriend_id = bo.id
where bo.id is null ;

-- 右外连接
select b.name
from boys bo
right outer join beauty b
on b.boyfriend_id = bo.id
where bo.id is null ;

-- 案例1：查询那个部门没有员工
-- 左外
select d.*, e.employee_id
from departments d
left outer join employees e
on d.department_id = e.department_id
where employee_id is null ;

-- 右外
select d.*, e.employee_id
from employees e
right outer join departments d
on d.department_id = e.department_id
where employee_id is null ;

-- 全外(不支持)
select b.*,bo.*
from beauty b
full outer join boys bo
on b.boyfriend_id = bo.id;

--交叉连接
select b.*,bo.*
from beauty b
cross join boys bo;

/*
  sql92 和 sql99 pk
  功能：sql99支持的较多
  可读性：sql99实现连接条件和筛选条件的分离，可读性较高
*/
-----------------------测试---------------------------------------
-- 一。查询编号>3的女神的男朋友信息，如果有则列出详细，如果没有，用Null填充
select b.id,b.name,bo.*
from beauty b
left outer join boys bo
on b.boyfriend_id = bo.id
where b.id > 3;

-- 二，查询那个城市没有部门
select city
from departments d
right outer join locations l
on d.location_id = l.location_id
where d.department_id is null ;

-- 三，查询部门名为SAL或IT的员工信息
select e.*,d.department_name
from departments d
left outer join employees e
on d.department_id = e.department_id
where d.department_name in ('SAL','IT');

-- 进阶7：子查询
/*
  含义：
    出现在其他语句中的select语句，称为子查询或内查询
    外部的查询语句，称为主查询或外查询
  分类：
    按子查询出现的位置：
      select后面:
        仅仅支持标量子查询
      from后面：
        支持表子查询
      where或having后面：
        标量子查询
        列子查询
        行子查询
      exists后面(相关子查询)：
        表子查询

    按结果集的行列数不同：
      标量子查询(结果集只有一行一列)
      列子查询(结果集只用一列多行)
      行子查询(结果集有一行多列)
      表子查询(结果集一般为多行多列)
*/
-- 一，where或having后面
/*
 1.标量子查询(单行子查询)
 2.列子查询(多行子查询)
 3.行子查询(多列多行)
  特点：
  1.子查询放在小括号内
  2.子查询一般放在条件的右侧
  3.标量子查询，一般搭配着单行操作符使用
  > < >= <= = <>
  列子查询，一般搭配着多行操作符使用
  in any/some all
*/
-- 1.标量子查询
-- 案例1：谁的工资比Abel高？
-- ①查询Abel的工资
select salary
from employees
where last_name = 'Abel';
-- ②查询员工的信息，满足salary>①结果
select *
from employees
where salary >(
select salary
from employees
where last_name = 'Abel'
);

-- 案例2：返回job_id与141号员工相同，salary比143号员工多的员工 姓名，job_id 和工资
-- ①查询141号员工的job_id
select job_id
from employees
where employee_id = 141;
-- ②查询143号员工的salary
select salary
from employees
where employee_id = 143;
-- ③查询员工的姓名，job_id 和工资，要求job_id = ①并且salary>②
select last_name,job_id,salary
from employees
where job_id = (
  select job_id
  from employees
  where employee_id = 141
) and salary >(
  select salary
  from employees
  where employee_id = 143
);

-- 案例3：返回公司工资最少的员工的last_name,job_id和salary
-- ①查询公司的最低工资
select min(salary)
from employees;
-- ②查询last_name,job_id和salary,要求salary=①
select last_name,job_id,salary
from employees
where salary = (
  select min(salary)
  from employees
);

--案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资
-- ①查询50号部门的最低工资
select min(salary)
from employees
where department_id = 50
-- ②查询每个部门的最低工资
select min(salary),department_id
from employees
group by department_id
-- ③在②基础上筛选，满足min(salary)>①
select min(salary),department_id
from employees
group by department_id
having min(salary) >(
  select min(salary)
  from employees
  where department_id = 50
);

-- 非法使用标量子查询:子查询的结果不是一行一列
select min(salary),department_id
from employees
group by department_id
having min(salary) >(
  select salary
  from employees
  where department_id = 250
);

-- 2.列子查询(多行子查询)
-- 案例1：返回location_id是1400或1700的部门中的所有员工姓名
-- ①查询location_id是1400或1700的部门编号
select distinct department_id
from departments
where location_id in (1400,1700);
-- ②查询员工姓名，要求部门号是①列表中的某一个
select last_name
from employees
where department_id in (
  select distinct department_id
  from departments
  where location_id in (1400,1700)
);

-- 案例2：返回其它工种中比job_id为‘IT_PROG’部门任意工资低的员工的员工号，姓名，job_id以及salary
-- ①查询job_id为‘IT_PROG’部门的任意工资
select distinct salary
from employees
where job_id = 'IT_PROG'
-- ②查询员工号，姓名，job_id以及salary，salary<any(①)的任意一个
select last_name,employee_id,job_id,salary
from employees
where salary < any(
  select distinct salary
  from employees
  where job_id = 'IT_PROG'
) and job_id <> 'IT_PROG';
-- 或
select last_name,employee_id,job_id,salary
from employees
where salary < (
  select max(salary)
  from employees
  where job_id = 'IT_PROG'
) and job_id <> 'IT_PROG';

-- 案例2：返回其它工种中比job_id为‘IT_PROG’部门任意工资低的员工的员工号，姓名，job_id以及salary
select last_name,employee_id,job_id,salary
from employees
where salary < all (
  select distinct salary
  from employees
  where job_id = 'IT_PROG'
) and job_id <> 'IT_PROG';
-- 或
select last_name,employee_id,job_id,salary
from employees
where salary < (
  select min(salary)
  from employees
  where job_id = 'IT_PROG'
) and job_id <> 'IT_PROG';

-- 3.行子查询(结果集一行多列或多行多列)
-- 案例：查询员工编号最小并且工资最高的员工信息
select *
from employees
where (employee_id,salary)=(
  select min(employee_id),max(salary)
  from employees
);
-- ①查询最小的员工编号
select min(employee_id)
from employees
-- ②查询最高工资
select max(salary)
from employees
-- ③查询员工信息
select *
from employees
where employee_id =(
  select min(employee_id)
  from employees
)and salary =(
  select max(salary)
  from employees
);

-- 二。select后面
/*
  仅仅支持标量查询
*/
-- 案例1：查询每个部门的员工个数
select d.*,(
  select count(*)
  from employees e
  where e.department_id = d.department_id
) 个数
from departments d;

-- 案例2：查询员工工号=102的部门名
select(
  select department_name
  from departments d
  inner join employees e
  on d.department_id = e.department_id
  where e.employee_id = 102
) 部门名;

-- 三.from后面
/*
 将子查询结果充当一张表，要求必须起别名
*/
-- 案例：查询每个部门的平均工资的工资等级
-- ①查询每个部门的平均工资
select avg(salary) ,department_id
from employees
group by department_id
-- ②连接①的结果集和job_grades表，筛选条件平均工资between lowest_sal and highest_sal
select ag_dep.*,g.grade_level
from (
  select avg(salary) ag ,department_id
  from employees
  group by department_id
) ag_dep
inner join job_grades g
on ag_dep.ag between lowest_sal and highest_sal;

--四.exists后面(相关子查询)
/*
  语法：
    exists(完整的查询语句)
    结果：
    1或0
*/
select exists (
  select employee_id
  from employees
  where salary = 30000
);
-- 案例1:查询有员工的部门名
-- in
select department_name
from departments d
where d.department_id in (
 select department_id
 from employees
);

--exists
select department_name
from departments d
where exists (
  select *
  from employees e
  where d.department_id = e.department_id
);

-- 案例2：查询没有的女朋友的男神信息
-- in
select bo.*
from boys bo
where bo.id not in (
  select boyfriend_id
  from beauty
);

--exists
select bo.*
from boys bo
where not exists(
 select boyfriend_id
 from beauty b
 where bo.id = b.boyfriend_id
);

-----------------------------测试---------------------------------------
-- 1.查询和zlotkey相同部门的员工姓名和工资
-- ①查询zlotkey的部门
select department_id
from employees
where last_name = 'zlotkey'
-- ②查询部门号=①的姓名和工资
select last_name,salary
from employees
where department_id = (
  select department_id
  from employees
  where last_name = 'zlotkey'
);

-- 2.查询工资比公司平均工资高的员工的员工号，姓名和工资
-- ①查询平均工资
select avg(salary)
from employees
-- ②查询工资>①的结果的员工的员工号，姓名和工资
select last_name,employee_id,salary
from employees
where salary > (
  select avg(salary)
  from employees
);

-- 3.查询各部门中工资比本部门平均工资高的员工的员工号，姓名和工资
-- ①查询各部门的平均工资
select avg(salary),department_id
from employees
group by department_id;
-- ②连接①结果集和employees表，进行筛选
select employee_id,last_name,salary,e.department_id
from employees e
inner join (
  select avg(salary) ag,department_id
  from employees
  group by department_id
) ag_dep
on e.department_id = ag_dep.department_id
where salary > ag_dep.ag;

-- 4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
-- ①查询姓名中包含字母u的员工的部门
select distinct department_id
from employees
where last_name like '%u%';
-- ②查询部门号=①中的任意一个的员工号和姓名
select last_name,employee_id
from employees
where department_id in (
  select distinct department_id
  from employees
  where last_name like '%u%'
);

-- 5.查询在部门的location_id为1700的部门工作的员工的员工号
-- ①查询location_id为1700的部门
select distinct department_id
from departments
where location_id = 1700
-- ②查询部门号=①中的任意一个的员工号
select employee_id
from employees
where department_id = any(
  select distinct department_id
  from departments
  where location_id = 1700
);

-- 6.查询管理者是King的员工姓名和工资
-- ①查询姓名为King的员工编号
select employee_id
from employees
where last_name = 'K_ing'
-- ②查询哪个员工的manager_id = ①
select last_name,salary
from employees
where manager_id in (
  select employee_id
  from employees
  where last_name = 'K_ing'
);

-- 7.查询工资最高的员工的姓名，要求first_name和last_name显示为一列，列名为姓.名
-- ①查询最高工资
select max(salary)
from employees
-- ②查询工资=①的姓.名
select concat(first_name,last_name) "姓.名"
from employees
where salary = (
  select max(salary)
  from employees
);

-- 进阶8：分页查询
/*
  应用场景：当要显示的数据，一页显示不全，需要分页提交sql请求
  语法：
    select 查询列表
    from 表
    [join type join 表2
    on 连接条件
    where 筛选条件
    group by 分组字段
    having 分组后筛选
    order by 排序字段]
    limit [offset] , size

    offset 要显示条目的起始索引(起始索引从0开始)
    size 要显示的条目个数

  特点：
    ①limit语句放在查询语句的最后
    ②公式
    要显示的页数 page ，每页条目数size
    select 查询列表
    from 表
    limit (page-1)*size,size
    size = 10
    page
    1       0
    2       10
    3       20
*/
-- 案例1：查询前5条员工信息
select * from employees limit 0,5;
select * from employees limit 5;

-- 案例2：查询第11条到第25条
select * from employees limit 10,15;

-- 案例3：有奖金的员工信息，并且工资较高的前10名显示出来
select
  *
from
  employees
where commission_pct is not null
order by salary desc
limit 10;
