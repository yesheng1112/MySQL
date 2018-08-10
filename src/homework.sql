-- 1.查询每个专业的学生人数
select majorid,count(*)
from student
group by majorid;

-- 2.查询参加考试的学生中，每个学生的平均分，最高分
select avg(score),max(score),studentno
from result
group by studentno;

-- 3.查询姓张的美国学生最低分大于60的学好，姓名
select s.studentno,s.studentname,min(score)
from student s
inner join result r
on s.studentno = r.studentno
where s.studentname like '张%'
group by s.studentno
having min(score) > 60;

-- 4.查询专业在'1988-1-1'后的学生姓名，专业名称
select studentname,majorname
from student s
inner join major m
on s.majorid = m.majorid
where datediff(borndate,'1988-1-1')>0;

-- 5.查询每个专业的男生人数和女生人数分别是多少
-- 方式一：
select count(*),sex,majorid
from student
group by sex,majorid;
-- 方式二：
select majorid,
(select count(*) from student where sex = '男' and majorid = s.majorid) 男,
(select count(*) from student where sex = '女' and majorid = s.majorid) 女
from student s
group by majorid;

-- 6.查询专业和张翠山一样的学生的最低分
-- ①查询张翠山的专业编号
select majorid
from student
where studentname = '张翠山'
-- ②查询编号=①的所有学生编号
select studentno
from student
where majorid =(
  select majorid
  from student
  where studentname = '张翠山'
);
-- ③查询最低分
select min(score)
from result
where studentno in (
  select studentno
  from student
  where majorid =(
    select majorid
    from student
    where studentname = '张翠山'
  )
);

-- 7.查询大于60分的学生的姓名，密码，专业名
select studentname,loginpwd,majorname
from student s
inner join major m
on s.majorid = m.majorid
inner join result r
on s.studentno = r.studentno
where r.score > 60;

-- 8.按邮箱位数分组，查询每组的学生个数
select count(*),length(email)
from student
group by length(email);

-- 9.查询学生名，专业名，分数
select studentname,majorname,score
from student s
inner join major m
on s.majorid = m.majorid
left join result r
on s.studentno = r.studentno;

-- 10.查询哪个专业没有学生，分别用左连接和右连接实现
-- 左
select m.majorid,m.majorname,s.studentno
from major m
left join student s on m.majorid = s.majorid
where s.studentno is null ;
-- 右
select m.majorid,m.majorname,s.studentno
from student s
right join major m on m.majorid = s.majorid
where s.studentno is null ;

-- 11.查询没有成绩的学生人数
select count(*)
from student s
left join result r
on s.studentno = r.studentno
where r.id is null ;
