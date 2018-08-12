-- 变量
/*
  系统变量：
    全局变量
    会话变量
  自定义变量：
    用户变量
    局部变量
*/
-- 一，系统变量
/*
  说明：变量由系统提供，不是用户定义，属于服务器层面的
  使用的语法：
    1.查看所有的系统变量
    show global|session variables;

    2.查看满足条件的部分系统变量
    show global|[session] variables like '%char%' ;

    3.查看指定的某个系统变量的值
    select @@global|[session].系统变量名;

    4.为某个系统变量赋值
    方式一：
    set global|[session] 系统变量名 = 值 ;
    方式二：
    set @@global|[session].系统变量名 = 值 ;
    注意：
    如果是全局级别，则需要加global ，如果是会话级别，则需要加session，如果不写，则默认session
*/
-- 1.全局变量
/*
  作用域：服务器每次启动将为所有的全局变量赋初始值，针对于所有的会话(连接)有效，但不能跨重启
*/
-- ①查看所有的全局变量
show global variables;

-- ②查看部分的全局变量
show global variables like '%char%';

-- ③查看某个特定的全局变量的值
select @@global.autocommit;
select @@tx_isolation;

-- ④为某个指定的全局变量赋值
set @@global.autocommit = 0

-- 2.会话变量
/*
  作用域：仅仅针对当前会话(连接)有效
*/
-- ①查看所有的会话变量
show session variables;
show variables;

-- ②查看部分的会话变量
show session variables like '%char%';
show variables like '%char%';

-- ③查看指定的某个会话变量
select @@tx_isolation;
select @@session.tx_isolation;

-- ④为某个会话变量赋值
-- 方式一:
set @@session .tx_isolation = 'read-uncommitted';
-- 方式二：
set session tx_isolation = 'read-committed';

-- 二，自定义变量
/*
  说明：变量是用户自定义的，不是由系统提供的
  使用步骤：
    声明
    赋值
    使用(查看，比较，运算等)
*/
-- 1.用户变量
/*
  作用域：针对于当前会话(连接)有效，同于会话变量的作用域
  应用在任何地方，也就是 begin end 里面或begin end 外面
*/
-- ①声明并初识化
/*
赋值的操作符: = 或 :=
  语法:
  set @用户变量名 = 值;
  set @用户变量名 := 值;
  select @用户变量名 := 值;
*/
-- ②赋值(更新用户变量的值)
/*
  方式一:通过set 或 select
    set @用户变量名 = 值;
    set @用户变量名 := 值;
    select @用户变量名 := 值;
  方式二:通过select into
    select 字段 into 用户变量名
    from 表;
*/
-- ③使用(查看用户变量的值)
/*
  select @用户变量名;
*/
-- 案例:
-- 声明并初识化
set @name = 'john';
set @name = 100;
set @count = 1;
-- 赋值
select count(*) into @count
from employees;
-- 查看
select @count ;

-- 2.局部变量
/*
  作用域：仅仅在定义它的begin end 中有效
  应用在 begin end 中的第一句话
*/
-- ①声明
/*
  declare 变量名 类型;
  declare 变量名 类型 default 值;
*/
-- ②赋值
/*
  方式一:通过set 或 select
    set 局部变量名 = 值;
    set 局部变量名 := 值;
    select 局部变量名 := 值;
  方式二:通过select into
    select 字段 into 局部变量名
    from 表;
*/
-- ③使用
/*
  select 局部变量名;
*/
/*
  对比用户变量和局部变量
                作用域                 定义和使用的位置                        语法
  用户变量       当前会话                会话中的任何地方                       必须加上@符号,不用限定类型
  局部变量       begin end 中           只能在begin end 中，且为第一句话        一般不用加@符号，需要限定类型
*/
-- 案例：声明两个变量并赋初识值，求和，并打印
-- 1.用户变量
set @m = 1;
set @n = 2;
set @sum = @m + @n;
select @sum;

-- 2.局部变量
declare m int default 1;
declare n int default 2;
declare sum int;
set sum  = m +n;
select sum ;

-- 存储过程和函数
/*
  存储过程和函数：类似于java中的方法
  好处：
    1.提高代码的重用性
    2.简化操作
*/
-- 存储过程
/*
  含义：一组预先编译好的SQL语句的集合，理解成批处理语句
  好处：
    1.提高代码的重用性
    2.简化操作
    3.减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
*/
-- 一，创建语法
/*
  create procedure 存储过程名(参数列表)
  begin
    存储过程体(一组合法的SQL语句)
  end
  注意：
  1.参数列表包含三部分
    参数模式 参数名 参数类型
    举例：
      in stuname varchar(20)
    参数模式：
      in:该参数可以作为输入，也就是该参数需要调用方传入值
      out:该参数可以作为输出，就是是该参数可以作为返回值
      inout:该参数可以作为输入又可以作为输出，也就是该参数既需要传入值，又可以返回值
  2.如果存储过程体中仅仅只有一句话，begin end可以省略
    存储过程体中每条SQL语句的结尾要求必须加分号
    存储过程体的结尾可以使用delimiter重新设置
    语法: delimiter 结束标记
    案例:
    delimiter $
*/

-- 二，调用语法
/*
  call 存储过程名(实参列表);
*/
-- 1.空参列表
-- 案例：插入到admin表中五条记录
select * from admin;

delimiter $
create procedure myp1()
begin
  insert into admin (username,password)
  values
  ('john1','0000'),
  ('lily','0000'),
  ('rose','0000'),
  ('jack','0000'),
  ('tom','0000');
end $

-- 调用
call myp1() $

-- 2.创建带in模式参数的存储过程
-- 案例1：创建存储过程实现 根据女神名，查询对应的男神信息
create procedure myp2(in beautyName varchar(20) )
begin
  select bo.*
  from boys bo
  right join beauty b
  on bo.id = b.boyfriend_id
  where b.name = beautyName;
end $

-- 调用
call myp2('柳岩') $

-- 案例2：创建存储过程实现，用户是否登录成功
create procedure myp3(in username varchar(20),in password varchar(20) )
begin
  declare result int default 0; -- 声明并初始化
  select count(*) into result -- 赋值
  from admin
  where admin.username = username
  and admin.password = password;
  select if(result>0,'成功','失败'); -- 使用
end $

-- 调用
call myp3('张飞','8888') $

-- 3.创建带out模式的存储过程

-- 案例1:根据女神名，返回对应的男神名
create procedure myp4(in beautyName varchar(20),out boyName varchar(20) )
begin
  select bo.boyName into boyName
  from boys bo
  inner join beauty b
  on bo.id = b.boyfriend_id
  where b.name = beautyName;
end $

-- 调用
call myp4('柳岩',@bName) $
select @bName $

-- 案例2：根据女神名，返回对应的男神名和男神魅力值
create procedure myp5(in beautyName varchar(20),out boyName varchar(20) , out userCP int )
begin
   select bo.boyName,bo.userCP into boyName,userCP
  from boys bo
  inner join beauty b
  on bo.id = b.boyfriend_id
  where b.name = beautyName;
end $

-- 调用
call myp5('柳岩',@boyName,@userCP) $
select @boyName,@userCP $

-- 4.创建带inout模式参数的存储过程
-- 案例1：传入a和b两个值，最终a和b都翻倍并返回
create procedure myp6(inout a int ,inout b int )
begin
  set a = a*2;
  set b = b*2;
end $

-- 调用
set @m = 10 $
set @n = 20 $
call myp6(@m,@n) $
select @m ,@n $

-------------------------测试-----------------------------------
-- 一，创建存储过程或函数实现传入用户名和密码，插入到admin表中
create procedure test_pro1(in username varchar(20),in loginPwd varchar (20))
begin
  insert into admin(admin.username, password)
  values (username,loginPwd)
end $

-- 二，创建存储过程或函数实现传入女神编号，返回女神名称和女神电话
create procedure test_pro2(in id int,out name varchar(20),out phone varchar(20))
begin
  select beauty.name,beauty.phone into name ,phone
  from beauty
  where beauty.id = id;
end $

-- 三，创建存储过程或函数实现传入两个女神生日，返回大小
create procedure test_pro3(in birth1 datetime,in birth2 datetime,out result int)
begin
  select datediff(birth1,birth2) into result;
end $

-- 四，创建存储过程或函数实现传入一个日期，格式化成xx年xx月xx日并返回
create procedure test_pro4(in mydate datetime ,out strDate varchar (50))
begin
  select date_format(mydate,'%y年%m月%d日') into strDate;
end $

call test_pro4(now(),@str) $
select @str $

-- 五，创建存储过程或函数实现传入女神名称，返回:女神 AND 男神 格式的字符串
-- 如传入:小昭
-- 返回:小昭 AND 张无忌
create procedure test_pro5(in beautyName varchar(20),out str varchar (50))
begin
  select concat(beautyName,'and',ifnull(boyName,'null')) into str
  from boys bo
  right join beauty b
  on b.boyfriend_id = bo.id
  where b.name = beautyName;
end $

call test_pro('柳岩',@str) $
select @str $

--六,创建存储过程或函数，根据传入的条目数和起始索引，查询beauty表的记录
create procedure test_pro6(in startIndex int,in size int )
begin
  select * from beauty limit startIndex,size;
end $
call test_pro6(3,5) $

-- 二，删除存储过程
/*
  语法：drop procedure 存储过程名;
  注意：不支持一次删除多个
*/

drop procedure test_pro3;

-- 三，查看存储过程的信息
/*
  语法:show create procedure 存储过程名;
*/
show create procedure myp1;

-- 函数：
/*
  含义：一组预先编译好的SQL语句的集合，理解成批处理语句
  好处：
    1.提高代码的重用性
    2.简化操作
    3.减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
  区别:
    存储过程:可以有0个返回，也可以有多个返回，适合做批量插入，批量更新
    函数:有且仅有有1个返回，适合做处理数据后返回一个结果
*/

-- 一.创建语法
/*
  create function 函数名(参数列表) returns 返回类型
  begin
    函数体
  end
  注意:
   1.参数列表 包含两个部分:
    参数名 参数类型
   2.函数体：肯定会有return语句，如果没有会报错
    如果return语句没有放在函数体的最后也不报错，但不建议
    return 值;
   3.函数体中仅有一句话，则可以省略begin end
   4.使用delimiter语句设置结束标记
*/
-- 二，调用语法
/*
  select 函数名(参数列表)
*/
-----------------------案例演示------------------------
-- 1.无参有返回
-- 案例:返回公司的员工个数
create function myf1() returns int
begin
  declare c int default 0; -- 定义变量
  select count(*) into c -- 赋值
  from employees;
  return c ;
end $

-- 调用
select myf1() $

-- 2.有参有返回
-- 案例1:根据员工名，返回他的工资
create function myf2(empName varchar(20)) returns double
begin
  set @sal = 0; -- 定义用户变量
  select salary into @sal -- 赋值
  from employees
  where last_name = empName;
  return @sal;
end $

select myf2('K_ing') $

-- 案例2：根据部门名，返回该部门的平均工资
create function myf3(deptName varchar(20)) returns double
begin
  declare sal double ;
  select avg(salary) into sal
  from employees e
  inner join departments d
  on e.department_id = d.department_id
  where d.department_name = deptName;
  return sal;
end $

select myf3('IT') $

-- 三，查看函数
show create function myf1;

-- 四，删除函数
drop function myf3;

-- 案例:创建函数，实现传入两个float，返回二者之和
create function test_fun1(num1 float ,num2 float ) returns float
begin
  declare sum float default 0;
  set sum = num1+num2;
  return sum;
end $

select test_fun1(1,2) $

-- 流程控制结构
/*
  顺序结构:程序从上往下依次执行
  分支结构:程序从两条或多条路径中选择一条去执行
  循环结构:程序在满足一定条件的基础上，重复执行一段代码
*/

-- 一，分支结构
-- 1.if函数
-- 功能：实现简单的双分支
-- 语法：
/*
  select if (表达式1,表达式2,表达式3)
  执行顺序：
  如果表达式1成立，则if函数返回表达式2的值，否则返回表达式3的值；
  应用：任何地方
*/
-- 2.case结构
/*
  情况1：类似于java中的switch语句，一般用于实现等值判断
  语法：
    case 变量|表达式|字段
    when 要判断的值 then 返回的值1或语句1;
    when 要判断的值 then 返回的值2或语句2;
    ...
    else 要返回的值n或语句n;
    end case;
  情况2：类似于java中的多重if语句，一盘用于实现区间判断
    case
    when 要判断的条件1 then 返回的值1或语句1;
    when 要判断的条件2 then 返回的值2或语句2;
    ...
    else 要返回的值n或语句n;
    end case
  特点：
    ①
    可以做为表达式，嵌套在其他语句中使用，可以放在任何地方，begin end 中或begin end的外面
    可以作为独立的语句去使用，只能放在begin end中
    ②
    如果when中的值或条件成立，则执行对应的then后面的语句，并且结束case
    如果都不满足，则执行else中的语句或值
    ③
    else可以省略，如果else省略了，并且所有when条件都不满足，则返回null
*/
-- 案例：
-- 创建存储过程，根据传入的成绩，来显示等级，
-- 比如传入的成绩:
-- 90-100,显示A，
-- 80-90，显示B，
-- 60-80,显示C,
-- 否则，显示D
create procedure test_case(in score int )
begin
  case
  when score>=90 and score<=100 then select 'A';
  when score>=80 then select 'B';
  when score>=60 then select 'C';
  else select 'D';
  end case ;
end $

call test_case(95) $

-- 3.if结构
/*
  功能：实现多重分支
  语法：
    if 条件1 then 语句1;
    elseif 条件2 then 语句2;
    ...
    [else 语句n;]
    end if;
  应用场合:应用在begin end 中
*/
-- 案例1：
-- 创建函数，根据传入的成绩，来显示等级，
-- 比如传入的成绩:
-- 90-100,返回A，
-- 80-90，返回B，
-- 60-80,返回C,
-- 否则，返回D
create function test_if(score int ) returns char
begin
  if score>=90 and score<=100 then return 'A';
  elseif score>=80 then return 'B';
  elseif score>=60 then return 'C';
  else return 'C';
  end if;
end $

-- 二，循环结构
/*
  分类：
    while，loop，repeat
  循环控制：
    iterate类似于 continue，继续，结束本次循环，继续下一次
    leave 类似于 break，跳出，结束当前所在的循环
*/
-- 1.while
/*
  语法：
    [标签:]while 循环条件 do
      循环体;
    end while [标签];
  联想(java):
    while(循环条件){
      循环体;
    }
*/

-- 2.loop
/*
  语法:
    [标签:] loop
      循环体;
    end loop [标签];
  可以用来描述简单的死循环
*/
-- 3.repeat
/*
  语法:
    [标签:] repeat
      循环体;
    until 结束循环的条件
    end repeat [标签];
*/
-- 1.没有添加循环控制语句
-- 案例1：批量插入，根据次数插入到admin表中多条记录
drop procedure pro_while1;
create procedure pro_while1(in insertCount int)
begin
  declare i int default 1;
  a:while i < insertCount do
    insert into admin(username,password) values
    (concat('Rose',i),'666');
    set i = i+1;
  end while a;
end $

call pro_while1(100) $

-- 2.添加leave语句
-- 案例2：批量插入，根据次数插入到admin表中多条记录，如果次数>20则停止
create procedure pro_while2(in insertCount int)
begin
  declare i int default 1;
  a:while i < insertCount do
    insert into admin(username,password) values
    (concat('Rose',i),'666');
    if i >=20 then leave a;
    end if;
    set i = i+1;
  end while a;
end $

call pro_while2(100) $

-- 3.添加iterate语句
-- 案例3：批量插入，根据次数插入到admin表中多条记录，只插入偶数次
create procedure pro_while3(in insertCount int)
begin
  declare i int default 0;
  a:while i < insertCount do
    set i = i+1;
    if mod(i,2) != 0 then iterate a;
    end if;
    insert into admin(username,password) values
    (concat('Rose',i),'666');
  end while a;
end $

call pro_while3(100) $

/*
                  特点
  while         先判断后执行
  repeat        先执行后判断
  loop          没有条件的死循环
*/
------------------循环的经典案例-------------------------
/*
  一，已知表stringcontent
  其中字段:
  id 自增长
  content varchar(20)

  向该表插入指定个数的，随机的字符串
*/
drop table if exists stringcontent;
create table stringcontent(
  id int primary key auto_increment,
  content varchar(26)
);

create procedure test_randstr_insert(in insertCount int )
begin
  declare i int default 1; -- 定义一个循环变量i，表示插入的次数
  declare str varchar(26) default 'abcdefghijklmnopqrstuvwxyz';
  declare startIndex int default 1; -- 代表起始索引
  declare len int default 1; -- 代表截取字符的长度
  while i < insertCount do
    set len = floor(rand()*(20-startIndex+1)+1);-- 产生一个随机的整数，代表截取长度，1-(26-startIndex+1)
    set startIndex = floor(rand()*26+1);-- 产生一个随机的整数，代表起始索引1-26
    insert into stringcontent(content) values (substring(str,startIndex));
    set i = i + 1;-- 循环变量更新
  end while;
end $

call test_randstr_insert(100) $