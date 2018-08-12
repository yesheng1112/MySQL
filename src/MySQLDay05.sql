-- 常见约束
/*
  含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确性和可靠性
  分类：六大约束
    NOT NULL:非空约束，用于保证该字段的值不能为空
    比如姓名，学号等
    DEFAULT:默认，用于保证字段有默认值
    比如性别
    PRIMARY KEY:主键，用于保证该字段的值具有唯一性，并且非空
    比如学号，员工编号等
    UNIQUE:唯一，用于保证该字段的值具有唯一性，可以为空
    比如座位号
    CHECK:检查约束[mysql中不支持]
    比如年龄，性别
    FOREIGN KEY:外键，用于限制两个表的关系，用于保证该字段的值必须来自于主表的关联列的值
    在从表添加外键约束，用于引用主表中某列的值
    比如学生表的专业编号，员工表的部门编号，员工表的工种编号
  添加约束的时机：
    1.创建表时
    2.修改表时
  约束的添加分类:
    列级约束：
      六大约束语法上都支持，但外键约束没有效果
    表级约束：
      除了非空，默认，其他的都支持
                     位置               支持的约束类型                 是否可以起约束名
    列级约束        列的后面              语法都支持，但外键没有效果       不可以
    表级约束        所有列的下面           默认和非空不支持，其他支持       可以(主键没有效果)
  主键和唯一的大对比:
            保证唯一性     是否允许为空      一个表中可以有多少个      是否允许组合
    主键      √             否               至多有1个             √但不推荐
    唯一      √             是               可以有多个            √但不推荐
  外键：
    1.要求在从表设置外键关系
    2.从表的外键类型和主表的关联列的类型要求一致或兼容，名称无要求
    3.主表的关联列必须是一个key(一般是主键或唯一)
    4.插入数据时，先插入主表，再插入从表
    删除数据是，先删除从表，再删除主表
    insert into major values (1,'java');
    insert into major values (2,'h5');
    insert into stuinfo values(1,'john','男',null,19,1);
    insert into stuinfo values(2,'lily','男',null,19,2);
  create table 表名(
    字段名 字段类型 约束
    字段名 字段类型，
    表级约束
  )
*/
-- 创建表时添加约束
-- 1.添加列级约束
/*
  语法:
    直接在字段名和类型后面追加约束类型即可
    只支持:默认，非空，主键，唯一
*/
create database if not exists students;
use students;
create table stuinfo(
  id int primary key , -- 主键
  stuName varchar(20) not null , -- 非空
  gender char(1) check(gender = '男' or gender = '女') , -- 检查
  seat int unique , -- 唯一
  age int default 18 ,-- 默认
  majorId int references major(id) -- 外键
);

create table major(
  id int primary key ,
  majorName varchar(20)
);

desc stuinfo;

-- 查看stuinfo表中所有的索引，包括主键，外键，唯一
show index from stuinfo;

-- 2.添加表级约束
/*
  语法：在各个字段的最下面
  [constraint 约束名] 约束类型(字段名)
*/
drop table if exists stuinfo;
create table stuinfo(
  id int ,
  stuName varchar(20) ,
  gender char(1),
  seat int ,
  age int ,
  majorId int,
  constraint pk primary key(id), -- 主键
  constraint uq unique(seat), -- 唯一键
  constraint ck check(gender = '男' or gender = '女'), -- 检查
  constraint fk_stuinfo_major foreign key(majorId) references major(id) -- 外键
);

-- 通用的写法:
create table stuinfo(
  id int primary key ,
  stuname varchar(20) not null ,
  sex char(1),
  age int default 18,
  seat int unique ,
  majorid int,
  constraint fk_stuinfo_major foreign key(majorid) references major(id)
);

-- 二，修改表时添加约束
/*
  1.添加列级约束
  alter table 表名 modify column 字段名 字段类型 新约束;
  2.添加表级约束
  alter table 表名 add [constraint 约束名] 约束类型(字段名) [外键的引用];
*/
drop table if exists stuinfo;
create table stuinfo(
  id int,
  stuname varchar (20),
  gender char(1),
  seat int,
  age int,
  majorid int
);

desc stuinfo;
-- 1.添加非空约束
alter table stuinfo modify column stuname varchar (20) not null ;
-- 2.添加默认约束
alter table stuinfo modify column age int default 18;
-- 3.添加主键
-- ①列级约束
alter table stuinfo modify column id int primary key ;
-- ②表级约束
alter table stuinfo add primary key(id) ;
-- 4.添加唯一
-- ①列级约束
alter table stuinfo modify column seat int unique ;
-- ②表级约束
alter table stuinfo add unique (seat);
-- 5.添加外键
alter table stuinfo add constraint fk_stuinfo_major foreign key (majorId) references major(id);

-- 三,修改表时删除约束
-- 1.删除非空约束
alter table stuinfo modify column stuname varchar(20) null;
-- 2.删除默认约束
alter table stuinfo modify column age int;
-- 3.删除主键
alter table stuinfo modify column id int ;
alter table stuinfo drop primary key ;
-- 4.删除唯一
alter table stuinfo drop index seat;
show index from stuinfo;
-- 5.删除外键
alter table stuinfo drop foreign key fk_stuinfo_major;
desc stuinfo;

-- 标识列
/*
  又称为自增长列
  含义：可以不用手动的插入值，系统提供默认的序列值
  特点：
    1.标识列必须和主键搭配吗？不一定，但要求是一个key
    2.一个表可以有几个标识列？至多一个！
    3.标识列的类型只能是数值型
    4.标识列可以通过set auto_increment_increment = 3; 设置步长
    也可以通过 手动插入值，设置起始值
*/
-- 一，创建表时设置标识列
drop table if exists tab_indentity;
create table tab_indentity(
  id int primary key auto_increment,
  name varchar(20)
);
truncate table tab_indentity;

insert into tab_indentity values (null ,'john');
insert into tab_indentity(name) values ('lucy');

select * from tab_indentity;

show variables like '%auto_increment%';

-- 修改每次增加的步长，不支持修改自动增长的起始值
set auto_increment_increment = 3;

-- 二，修改表时设置标识列
alter table tab_indentity modify column id int primary key auto_increment;

-- 三，修改表时删除标识列
alter table tab_indentity modify column id int;

-- TCL :事务控制语言
/*
  Transaction Control Language 事务控制语言
  事务：
    一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。
  案例：转账
  张三丰 1000
  郭襄   1000
  update 表 set 张三丰的余额=500 where name = '张三丰';
  意外
  update 表 set 郭襄的余额=1500 where name ='郭襄';
  特点：ACID属性[面试题]
  1.原子性(Atomicity)
    原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。
  2.一致性(Consistency)
    事务必须使数据库从一个一致性状态变换到另一个一致性状态。
  3.隔离性(Isolation)
    事务的隔离性是指一个事务的执行不能被其他事物干扰，即一个事务内部的操作及使用的数据对
    并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。
  4.持久性(Durability)
    持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，接下来的其他操作和数据库
    故障不应该对其有任何影响。
  事务的创建
    隐式事务:事务没有明显的开启和结束的标记
    比如 insert update delete语句
    delete from 表 where id = 1;
    显示事务:事务具有明显的开启和结束的标记
    前提：必须先设置自动提交功能为禁用
    set autocommit = 0;
    步骤1：开启事务
    set autocommit = 0;
    start transaction ; 可选的
    步骤2：编写事务中的sql语句(select insert update delete)
    语句1;
    语句2;
    ...
    步骤3：结束事务
    commit;提交事务
    rollback；回滚事务
    savepoint 节点名;设置保存点

    开启事务的语句
    update 表 set 张三丰的余额=500 where name = '张三丰';

    update 表 set 郭襄的余额=1500 where name ='郭襄';
    结束事务的语句
  常见的并发问题：
    脏读:对于两个事务T1，T2，T1读取了已经被T2更新但还没有被提交的字段之后，若T2回滚
    ，T1读取的内容就是临时且无效的
    不可重复读:对于两个事务T1,T2,T1读取了一个字段，然后T2更新了该字段之后，T1再次读取同一个字段，值就不同了
    幻读:对于两个事务T1,T2,T1从一个表中读取了一个字段，然后T2在该表中插入了一些新的行之后，如果T1再次读取同一个表，就会多出几行
  数据库事务的隔离性：数据库系统给必须具有隔离并发运行各个事务的能力，使他们不会相互影响，避免各种并发问题。
  事务的隔离级别：
                        脏读        不可重复读      幻读
    read uncommitted:    √          √           √
    read committed:       x          √           √
    repeatable read:      x          x            √
    serializable:         x          x            x
    mysql中默认第三个隔离级别 repeatable read
    oracle中默认第二个隔离级别 read committed
*/
-- 查看mysql支持的存储引擎
show engines;
show variables like 'autocommit';

drop table if exists account;

create table account(
  id int primary key auto_increment,
  username varchar(20),
  balance double
);
insert into account (username, balance)
values ('张无忌',1000),('赵敏',1000);

-- 演示事务的使用步骤
-- 开启事务
set autocommit = 0;
start transaction;
-- 编写一组事务的语句
update account set balance = 1000 where username = '张无忌';
update account set balance = 1000 where username = '赵敏';
-- 结束事务
rollback ;
commit ;
select * from account;

-- 查看事务隔离级别
select @@tx_isolation;

-- 设置当前事务隔离级别,设置成：read uncommitted
set session transaction isolation level read uncommitted ;

-- 设置数据库系统的全局的隔离级别
set global transaction isolation level read commit ;

-- 2.演示事务对于delete和truncate的处理区别
set autocommit = 0;
start transaction ;
delete from account;
rollback ;

-- 3.演示savepoint的使用
set autocommit = 0;
start transaction ;
delete from account where id = 25;
savepoint a; -- 设置保存点
delete from account where id = 28;
rollback to a; -- 回滚到保存点

-- 视图
/*
  含义:虚拟表，和普通表一样的使用
  mysql5.1版本出现的新特性，是通过表动态生成的数据
  比如：舞蹈班和普通班的对比
  应用场景：
    多个地方用到同样的查询结果
    该查询结果使用的sql语句较复杂
          创建语法的关键字      是否实际占用物理空间      使用
  视图      create view        只是保存了sql逻辑       增删改查，只是一般不能增删改
  表       create table        保存了数据             增删改查
*/
-- 案例：查询姓张的学生名和专业名
select stuName,majorName
from stuinfo s
inner join major m on s.majorId = m.id
where s.stuName like '张%';

create view v1
as
select stuName,majorName
from stuinfo s
inner join major m on s.majorId = m.id;

select * from v1 where stuName like '张%';

-- 一，如何创建视图
/*
  create view 视图名
  as
  查询语句;
  好处：
    重用sql语句
    简化复杂的sql操作，不必知道它的查询细节
    保护数据，提高安全性
*/
-- 1.查询姓名中包含a字符的员工名，部门名和工种信息
-- ①创建视图
create view myv1
as
select last_name,department_name,job_title
from employees e
inner join departments d
on e.department_id = d.department_id
inner join jobs j
on e.job_id = j.job_id;

-- ②使用视图
select * from myv1 where last_name like '%a%';

-- 2.查询各部门的平均工资级别
-- 创建视图查看每个部门的平均工资
create view myv2
as
select avg(salary) ag,department_id
from employees
group by department_id;

-- 使用
select myv2.ag,g.grade_level
from myv2
inner join job_grades g
on myv2.ag between g.lowest_sal and g.highest_sal;


-- 3.查询平均工资最低的部门信息
select * from myv2 order by ag limit 1;

-- 4.查询平均工资最低的部门名和工资
create view myv3
as
select * from myv2 order by ag limit 1;

select d.* , m.ag
from myv3 m
inner join departments d
on m.department_id = d.department_id;

-- 二，视图修改
-- 方式1
/*
  create or replace view 视图名
  as
  查询语句
*/
select * from myv3;
create or replace view myv3
as
select avg(salary) ,job_id
from employees
group by job_id;

-- 方式二：
/*
  语句：
  alter view 视图名
  as
  查询语句;
*/
alter view myv3
as
select * from employees;

-- 三，删除视图
/*
  语法:
   drop view 视图名，视图名，....;
*/
drop view emp_v1,emp_v2,myv3;

-- 四，查看视图
desc myv3;
show create view myv3;

-- 1.创建视图emp_v1,要求查询的电话号码以‘011’开头的员工姓名和工资，邮箱
create or replace view emp_v1
as
select last_name,salary,email
from employees
where phone_number like '011%';

select * from emp_v1;

-- 2.创建视图emp_v2,要求查询部门的最高工资高于12000的部门信息
create or replace view emp_v2
as
select max(salary) mx_dep,department_id
from employees
group by department_id
having max(salary) > 12000;

select d.* ,m.mx_dep
from departments d
inner join emp_v2 m
on m.department_id = d.department_id;

-- 五，视图的更新
create or replace view myv1
as
select last_name,email,salary*12*(1+ifnull(commission_pct,0)) "annual salary" from employees;

create or replace view myv1
as
select last_name,email from employees;


select * from myv1;

-- 1.插入
insert into myv1 values ('张飞','zf@qq.com');

-- 2.修改
update myv1 set last_name = '张无忌' where last_name = '张飞';

-- 3.删除
delete from myv1 where last_name = '张无忌';

-- 具备以下的特点的视图不允许更新
/*
  包含以下关键字的sql语句：
    分组函数，distinct，group by ,having ,union 或者 union all
    常量视图
    select 中包含子查询
    join
    from一个不能更新的视图
    where字句的子查询引用了from子句中的表
*/
-- ①分组函数，distinct，group by ,having ,union 或者 union all
create or replace view myv1
as
select max(salary) m,department_id
from employees
group by department_id;

select * from myv1;

-- ②常量视图
create or replace view myv2
as
select 'john' name ;

select * from myv2;

-- ③select 中包含子查询
create or replace view myv3
as
select (select max(salary) from employees) 最高工资;

select * from myv3;

-- ④join
create or replace view myv4
as
select last_name,department_name
from employees e
inner join departments d
on e.department_id = d.department_id;

select * from myv4;

-- ⑤from一个不能更新的视图
create or replace view myv5
as
select * from myv3;

-- ⑥where字句的子查询引用了from子句中的表
create or replace view myv6
as
select last_name,email,salary
from employees
where employee_id in (
  select manager_id
  from employees
  where manager_id is not null
);

-- 拓展：级联删除,添加级联删除的外键，主表中的数据删除从表中的数据也会删除
alter table stuinfo add constraint fk_stu_major foreign key
(majorId) references major(id) on delete cascade ;

-- 级联置空,删除主表中数据，从表中数据会置空
alter table stuinfo add constraint fk_stu_major foreign key
(majorId) references major(id) on delete set null;