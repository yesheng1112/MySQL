-- 查询语句中涉及到的所有的关键字，以及执行先后顺序
/*
  select 查询列表                ⑦
  from 表                       ①
  连接类型 join 表2              ②
  on 连接条件                    ③
  where 筛选条件                 ④
  group by 分组列表              ⑤
  having 分组后的筛选             ⑥
  order by 排序列表              ⑧
  limit 偏移，条目数              ⑨
*/
-----------------------经典案例---------------------------------
-- 1.查询工资最低的员工信息:last_name,salary
-- ①查询最低的工资
select min(salary)
from employees
-- ②查询last_name,salary，要求salary=①
select last_name,salary
from employees
where salary = (
  select min(salary)
  from employees
);

-- 2.查询平均工资最低的部门信息
-- 方式一：
-- ①各部门的平均工资
select avg(salary),department_id
from employees
group by department_id
-- ②查询①结果上的最低平均工资
select min(ag)
from (
  select avg(salary) ag,department_id
  from employees
  group by department_id
) ag_dep
-- ③查询那个部门的平均工资=②
select avg(salary),department_id
from employees
group by department_id
having avg(salary)=
(
  select min(ag)
  from (
    select avg(salary) ag,department_id
    from employees
    group by department_id
) ag_dep
);
-- ④查询部门信息
select d.*
from departments d
where d.department_id =(
  select department_id
  from employees
  group by department_id
  having avg(salary)=
  (
    select min(ag)
    from (
      select avg(salary) ag,department_id
      from employees
      group by department_id
  ) ag_dep)
);

-- 方式二：
-- ①各部门的平均工资
select avg(salary),department_id
from employees
group by department_id
-- ②求出最低平均工资的部门编号
select department_id
from employees
group by department_id
order by avg(salary)
limit 1;
-- ③查询部门信息
select *
from departments
where department_id = (
  select department_id
  from employees
  group by department_id
  order by avg(salary)
  limit 1
);

-- 3.查询平均工资最低的部门信息和该部门的平均工资
-- ①各部门的平均工资
select avg(salary),department_id
from employees
group by department_id
-- ②求出最低平均工资的部门编号
select avg(salary),department_id
from employees
group by department_id
order by avg(salary)
limit 1;
--③查询部门信息
select d.*,ag
from departments d
inner join (
  select avg(salary) ag,department_id
  from employees
  group by department_id
  order by avg(salary)
  limit 1
) ag_dep
on d.department_id = ag_dep.department_id;

-- 4.查询平均工资最高的job信息
-- ①查询最高的job的平均工资
select avg(salary),job_id
from employees
group by job_id
order by avg(salary) desc
limit 1
-- ②查询job信息
select *
from jobs
where job_id=(
  select job_id
  from employees
  group by job_id
  order by avg(salary) desc
  limit 1
);

-- 5.查询平均工资高于公司平均工资的部门有哪些
-- ①查询平均工资
select avg(salary)
from employees
-- ②查询每个部门的平均工资
select avg(salary)
from employees
group by department_id
-- ③筛选②结果集，满足平均工资>①
select avg(salary),department_id
from employees
group by department_id
having avg(salary) >(
  select avg(salary)
  from employees
);

-- 6.查询出公司中所有manager 的详细信息
-- ①查询所有manager的员工编号
select distinct manager_id
from employees;
-- ②查询详细信息，满足employee_id = ①
select *
from employees
where employee_id = any (
  select distinct manager_id
  from employees
);

-- 7.各个部门中最高工资中最低的那个部门的 最低工资是多少
-- ①查询各部门的最高工资中最低的部门编号
select department_id
from employees
group by department_id
order by max(salary)
limit 1
-- ②查询①结果的那个部门的最低工资
select min(salary)
from employees
where department_id = (
  select department_id
  from employees
  group by department_id
  order by max(salary)
  limit 1
);

-- 8.查询平均工资最高的部门的manager 的详细信息:last_name,department_id ,email,salary
-- ①查询平均工资最高的部门编号
select department_id
from employees
group by department_id
order by avg(salary) desc
limit 1
-- ②将employees和departments连接查询，筛选条件是①
select
  last_name,d.department_id,email,salary
from
  employees e
inner join
  departments d on e.department_id = d.department_id
where
  d.department_id = (
  select department_id
  from employees
  group by department_id
  order by avg(salary) desc
  limit 1
);

-- 进阶9：联合查询
/*
  union 联合 合并：将多条查询语句的结果合并成一个结果
  语法：
    查询语句1
    union
    查询语句2
    union
    ...
  应用场景:
    要查询的结果来自多个表，且多个表没有直接的连接关系，但查询的信息一致时
  特点：
    1.要求多条查询语句的查询列数是一致的！
    2.要求多条查询语句的查询的每一列的类型和顺序最好一致
    3.union关键字默认去重，如果使用union all可以包含重复项
*/
-- 引入案例：查询部门编号>90或者邮箱中包含a的员工信息
select * from employees
where email like '%a%'
or department_id > 90;

select * from employees
where email like '%a%'
union
select * from employees
where department_id > 90;

-- 案例：查询中国用户中男性的信息以及外国用户男性的用户信息
select id,cname,csex
from t_ca where csex = '男'
union
select t_id,tName,tGender
from t_ua where tGender = 'male';

-- DML语言
/*
  数据操作语言：
    插入: insert
    修改: update
    删除: delete
*/
-- 一，插入语句
-- 方式一：经典的插入
/*
  语法:
    insert into 表名 (列名,.....)
    values(值1,....);
*/
select * from beauty order by id desc ;
-- 1.插入的值的类型要与列的类型一致或兼容
insert into beauty (id,name,sex,borndate,phone,photo,boyfriend_id)
values(13,'唐艺昕','女','1990-4-23','18988888888',null ,2);

-- 2.不可以为null的列必须插入值。可以为null的列如何插入值？
-- 方式一：
insert into beauty (id,name,sex,borndate,phone,photo,boyfriend_id)
values(13,'唐艺昕','女','1990-4-23','18988888888',null ,2);
-- 方式二
insert into beauty (id,name,sex,borndate,phone,boyfriend_id)
values(14,'金星','女','1990-4-23','13888888888',9);

insert into beauty (id,name,sex,phone)
values(15,'娜扎','女','13888888888');

-- 3.列的顺序是否可以调换
insert into beauty(name,sex,id,phone)
values('蒋欣','女',16,'110');

-- 4.列数和值的个数必须一致
insert into beauty(name,sex,id,phone)
values('关晓彤','女',17,'110');

-- 5.可以省略列名，默认所有列，而且列的顺序和表中列的顺序一致
insert into beauty
values (18,'张飞','男',null ,'119',null ,null );

-- 方式二：
/*
  语法:
    insert into 表名
    set 列名=值,列名=值,...
*/
insert into beauty
set id = 19,name ='刘涛',phone='999';

-- 两种方式大PK
-- 1.方式一支持插入多行,方式二不支持
insert into beauty
values
(23,'唐艺昕1','女','1990-4-23','18988888888',null ,2),
(24,'唐艺昕2','女','1990-4-23','18988888888',null ,2),
(25,'唐艺昕3','女','1990-4-23','18988888888',null ,2);

-- 2.方式一支持子查询，方式二不支持
insert into beauty(id,name,phone)
select 26,'宋茜','11809866';

insert into beauty(name,phone)
select boyName,'11809866'
from boys where id <3 ;

-- 二，修改语句
/*
  1.修改单表的记录
    语法
      update 表名
      set 列 = 新值,列 = 新值,...
      where 筛选条件;
  2.修改多表的记录【补充】
    语法：
    sql92语法:
      update 表1 别名，表2 别名
      set 列=值,...
      where 连接条件
      and 筛选条件
    sql99语法：
      update 表1 别名
      inner|left|right join 表2 别名
      on 连接条件
      set 列 = 值，...
      where 筛选条件;
*/
-- 1.修改单表的记录
-- 案例1：修改beauty表中姓唐的女神的电话为13899888899
update beauty set phone = '13899888899'
where name like '唐%';

-- 案例2：修改boys表中id号为2的名称为张飞，魅力值为10
update boys set  boyName = '张飞',userCP=10
where id = 2;

-- 2.修改多表的记录
-- 案例1：修改张无忌的女朋友的手机号为114
update boys bo
inner join beauty b
on bo.id = b.boyfriend_id
set b.phone = '114'
where bo.boyName = '张无忌';

-- 案例2：修改没有男朋友的女神的男朋友的编号都为2号
update boys bo
right join beauty b
on bo.id = b.boyfriend_id
set b.boyfriend_id = 2
where bo.id is null ;

-- 三，删除语句
/*
  方式一:delete
    语法：
     1.单表的删除
      delete from 表名 where 筛选条件
     2.多表的删除【补充】
      sql92语法：
        delete 表1的别名，表2的别名
        from 表1 别名，表2 别名
        where 连接条件
        and 筛选条件;
      sql99语法:
         delete 表1的别名，表2的别名
        from 表1 别名
        inner|left|right join 表2 别名
        on 连接条件
        where 筛选条件;
  方式二:truncate
    语法：truncate table 表名;
*/
-- 方式一：delete
-- 1.单表的删除
-- 案例:删除手机号以9结尾的女神信息
delete from beauty
where phone like '%9';

-- 2.多表的删除
-- 案例:删除张无忌的女朋友的信息
delete b
from beauty b
inner join boys bo
on b.boyfriend_id = bo.id
where bo.boyName = '张无忌';

-- 案例：删除黄晓明的信息以及他女朋友的信息
delete b,bo
from beauty b
inner join boys bo
on b.boyfriend_id = bo.id
where bo.boyName = '黄晓明';

-- 方式二：truncate语句
-- 案例：将魅力值>100的男神信息删除
truncate table boys;

-- delete pk truncate【面试题】
/*
  1.delete 可以加where条件，truncate不能加
  2.truncate删除，效率高一丢丢
  3.假如要删除的表中有自增长列，
  如果用delete删除后，再插入数据，自增长列的值从断点开始，
  而truncate删除后，再插入数据，自增长列的值从1开始。
  4.truncate删除没有返回值，而delete删除有返回值
  5.truncate删除不能回滚，delete可以回滚
*/
select * from boys;
delete from boys;
truncate table boys;
insert into boys(boyName, userCP) values
('张飞',100),
('刘备',100),
('关云长',100);

-- DDL语言
/*
  数据定义语言
  库和表的管理
  一，库订单管理
    创建，修改，删除
  二，表的管理
    创建，修改，删除
  创建:create
  修改:alter
  删除:drop
*/
-- 一，库的管理
-- 1.库的创建
/*
  语法：
    create database (if not exists) 库名;
*/
-- 案例：创建库Books
create database if not exists books;
use books;

-- 2.库的修改
-- rename database books to 新库名;(失效)
-- 更改库的字符集
alter database books character set gbk;

-- 3.库的删除
drop database if exists books;

-- 二，表的管理
-- 1.表的创建
/*
  语法：
    create table 表名(
      列名 列的类型[(长度) 约束],
      列名 列的类型[(长度) 约束],
      列名 列的类型[(长度) 约束],
      ...
      列名 列的类型[(长度) 约束]
    )
*/
-- 案例：创建表Book
create table book(
  id int ,-- 编号
  bName varchar(20),-- 图书名
  price double ,-- 价格
  authorId int, -- 作者编号
  publishDate datetime -- 出版日期
);
desc book;

-- 案例：创建author
create table author(
  id int ,
  au_name varchar(20),
  nation varchar(10)
);
desc author;

-- 2.表的修改
/*
  语法:
    alter table 表名 add|drop|modify|change column [列名 列类型];
*/
-- ①修改列名
alter table book change column publishDate pubDate datetime;

-- ②修改列的类型或约束
alter table book modify column pubDate timestamp ;

-- ③添加新列
alter table book add column annual double ;

-- ④删除列
alter table book drop column annual;

-- ⑤修改表名
alter table author rename to book_author;

-- 3.表的删除
drop table if exists book_author;

show tables;

-- 通用的写法:
/*
  drop database if exists 旧库名;
  create database 新库名;

  drop table if exists 旧表名;
  create table 新表名;
*/

-- 4.表的复制
insert into author values
(1,'村上春树','日本'),
(2,'莫言','中国'),
(3,'冯唐','中国'),
(4,'金庸','中国');

-- ①.仅仅复制表的结构
create table copy like author;

-- ②.复制表的结构+数据
create table copy2 select * from author;

-- ③.只复制部分数据
create table copy3 select id,au_name from author where nation = '中国';

-- ④.仅仅复制某些字段
create table copy4 select id,au_name from author where 1=2;

-- 常见的数据类型
/*
  数值型：
    整型
    小数：
      定点数
      浮点数
  字符型：
    较短的文本:char varchar
    较长的文本:text blob(较长的二进制数据)
  日期型：
*/
-- 一，整型
/*
  分类：
    tinyint , smallint , mediumint , int/integer , bigint
      1           2           3           4           8
  特点：
    ①如果不设置无符号还是有符号，默认是有符号，如果想设置无符号，需要添加unsigned关键字
    ②如果插入的数值超出的整型的范围，会报out of range异常，并且插入临近值
    ③如果不设置长度，会有默认的长度
    ④长度代表显示的最大宽度，如果不够会用0在左边填充，但必须搭配zerofill使用
*/
use test;
-- 1.如何设置无符号和有符号,默认是有符号的
drop table if exists tab_int;
create table tab_int(
  t1 int(7),
  t2 int(7) unsigned
);

desc tab_int;
select * from tab_int;
insert into tab_int values (-123456);
insert into tab_int values (-123456,-123456);

-- 二，小数
/*
分类：
  1.浮点型
    float(M,D)
    double(M,D)
  2.定点型
    dec(M,D)
    decimal(M,D)
特点：
  ①
    M:整数部位+小数部位
    D:小数部位
    如果超过范围，则插入临界值
  ②.M和D都可以省略
  如果是decimal，则M默认为10，D默认为0
  如果是float和double，则会根据插入的数值的精度来决定精度
  ③ 定点型的精度较高，如果要求插入数值的精度较高如货币运算则考虑使用
*/
-- 测试M和D
create table tab_float(
  f1 float (5,2),
  f2 double (5,2),
  f3 decimal (5,2)
);
select * from tab_float;
insert into tab_float values (123.45,123.45,123.45);
insert into tab_float values (123.456,123.456,123.456);
insert into tab_float values (123.4,123.4,123.4);
insert into tab_float values (1523.4,1523.4,1523.4);

-- 原则：
/*
  所选的类型越简单越好，能保存数值的类型越小越好
*/

-- 三，字符型
/*
  较短的文本:
    char
    varchar
  其他:
    binary和varbinary用于保存较短的二进制
    enum用于保存枚举
    set用于保存集合
  较长的文本：
    text
    blob(较大的二进制)
  特点:
                写法                   M的意思                   特点             空间的耗费     效率
    char        char(M)       最大的字符数，可以省略默认为1      固定长度的字符        比较耗费        高
    varchar     varchar(M)    最大的字符数，不可以省略          可变长度的字符        比较节省        低
*/
create table tab_char(
  c1 enum('a','b','c')
);

select * from tab_char;

insert into tab_char values ('a');
insert into tab_char values ('b');
insert into tab_char values ('c');
insert into tab_char values ('m');
insert into tab_char values ('A');

create table tab_set(
  s1 set ('a','b','c','d')
);

select * from tab_set;

insert into tab_set values ('a');
insert into tab_set values ('a,b');
insert into tab_set values ('a,c,d');

-- 四，日期型
/*
  分类:
    date 只保存日期
    time 只保存时间
    year 只保存年
    datetime 保存日期+时间
    timestamp 保存日期+时间

  特点：
                      字节           范围                 是否受时区的影响
    datetime            8         1000-9999                 不受
    timestamp           4         1970-2038                  受
*/
create table tab_date(
  t1 datetime,
  t2 timestamp
);
insert into tab_date
values (now(),now());

select * from tab_date;

show variables like 'time_zone';
set time_zone = '+9:00';
