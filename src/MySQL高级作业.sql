CREATE TABLE `t_dept`(
    `id` INT(11) NOT NULL AUTO_INCREMENT ,
    `deptName` VARCHAR(30) DEFAULT NULL ,
    `address` VARCHAR(40) DEFAULT NULL ,
    PRIMARY KEY(`id`)
)ENGINE=INNODB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8;
             
CREATE	TABLE `t_emp`(
    `id` INT(11) NOT NULL AUTO_INCREMENT ,
    `name` VARCHAR(20) DEFAULT NULL ,
    `age` INT(3) DEFAULT NULL ,
    `deptId` INT(11) DEFAULT NULL ,
    empno INT NOT NULL ,
    PRIMARY KEY(`id`)
)ENGINE=INNODB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8;

INSERT INTO t_dept(deptName,address) VALUES('华山','华山');
INSERT INTO t_dept(deptName,address) VALUES('丐帮','洛阳');
INSERT INTO t_dept(deptName,address) VALUES('峨眉','峨眉山');
INSERT INTO t_dept(deptName,address) VALUES('武当','武当山');
INSERT INTO t_dept(deptName,address) VALUES('明教','光明顶');
INSERT INTO t_dept(deptName,address) VALUES('少林','少林寺');
             
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('风清扬',90,1,100001);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('岳不群',50,1,100002);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('令狐冲',24,1,100003);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('洪七公',70,2,100004);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('乔峰',35,2,100005);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('灭绝师太',70,3,100006);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('周芷若',20,3,100007);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('张三丰',100,4,100008);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('张无忌',25,5,100009);
INSERT INTO t_emp(NAME,age,deptId,empno) VALUES('韦小宝',18,NULL,100010);

ALTER TABLE `t_dept` ADD CEO INT(11);

UPDATE t_dept SET ceo = 2 WHERE id=1;
UPDATE t_dept SET ceo = 4 WHERE id=2;
UPDATE t_dept SET ceo = 6 WHERE id=3;
UPDATE t_dept SET ceo = 8 WHERE id=4;
UPDATE t_dept SET ceo = 9 WHERE id=5;

-- 清空所有的索引
CALL proc_drop_index ('mydb','emp');

CALL proc_drop_index ('mydb','dept');

-- 1.列出自己掌门比自己年龄小的人员
SELECT a.name,a.age,c.name ceoname,c.age ceoage FROM t_emp a
LEFT JOIN t_dept b ON a.deptid = b.id
LEFT JOIN t_emp c ON b.CEO = c.id
WHERE a.age > c.age;

EXPLAIN	SELECT SQL_NO_CACHE a.name,a.age,c.name ceoname,c.age ceoage FROM emp a
LEFT JOIN dept b ON a.deptid = b.id
LEFT JOIN emp c ON b.CEO = c.id
WHERE a.age > c.age; #1.027


-- 2.列出所有年龄低于自己门派平均年龄的人员
SELECT c.name,c.age, aa.age avgage FROM t_emp c
INNER JOIN
(	SELECT a.deptId ,AVG(age) age FROM t_emp a
	WHERE a.deptId IS NOT NULL
	GROUP BY a.deptid
) aa ON c.deptId = aa.deptid
WHERE c.age < aa.age;

EXPLAIN SELECT SQL_NO_CACHE c.name,c.age, aa.age avgage FROM emp c
INNER JOIN
(	SELECT a.deptId ,AVG(age) age FROM emp a
	WHERE a.deptId IS NOT NULL
	GROUP BY a.deptid
) aa ON c.deptId = aa.deptid
WHERE c.age < aa.age;

CREATE INDEX idx_deptid ON emp(deptid);
CREATE INDEX idx_deptid_age ON emp(deptid,age);

-- 3.列出至少有2个年龄大于40岁的成员的门派
SELECT b.deptName ,COUNT(*) FROM t_emp a
INNER JOIN t_dept b ON a.deptId = b.id
WHERE a.age > 40
GROUP BY b.deptName
HAVING COUNT(*) >=2;

EXPLAIN	SELECT SQL_NO_CACHE b.deptName ,COUNT(*) FROM dept b
STRAIGHT_JOIN emp a ON a.deptId = b.id
WHERE a.age > 40
GROUP BY b.deptName
HAVING COUNT(*) >=2;


CREATE INDEX idx_deptid_age ON emp(deptid,age);
CREATE INDEX idx_deptname ON dept(deptname);

-- 4.至少有3位非掌门人成员的门派
SELECT * FROM t_emp WHERE id NOT IN(
SELECT ceo FROM t_dept WHERE ceo IS NOT NULL
)

-- not in ->left join ... where xxx is null
SELECT c.deptname,COUNT(*) FROM t_emp a
INNER JOIN t_dept c ON a.deptid = c.id
LEFT JOIN t_dept b ON a.id = b.ceo WHERE b.id IS NULL
AND a.deptid IS NOT NULL
GROUP BY c.deptname
HAVING COUNT(*)>=2;

EXPLAIN SELECT SQL_NO_CACHE c.deptname,COUNT(*) FROM  dept c
STRAIGHT_JOIN emp a ON a.deptid = c.id
LEFT JOIN dept b ON a.id = b.ceo WHERE b.id IS NULL
AND a.deptid IS NOT NULL
GROUP BY c.deptname
HAVING COUNT(*)>=2;

CREATE INDEX idx_ceo ON dept(ceo);

CREATE INDEX idx_deptid ON emp(deptid);

CREATE INDEX idx_deptname ON dept(deptname);

-- 5.列出全部人员，并增加一列备注‘是否为掌门’，如果是掌门人显示是，不是掌门人显示否
SELECT a.name,
(CASE WHEN b.id IS NULL
THEN '否'
ELSE '是'
END)
'是否为掌门'
FROM t_emp a
LEFT JOIN t_dept b
ON a.id = b.CEO;

EXPLAIN SELECT a.name,
(CASE WHEN b.id IS NULL
THEN '否'
ELSE '是'
END)
'是否为掌门'
FROM emp a
LEFT JOIN dept b
ON a.id = b.CEO;


-- 6.列出全部门派，并增加一列备注‘老鸟or菜鸟’，若门派的平均值年龄>50 显示‘老鸟’，否则显示‘菜鸟’
SELECT  b.deptName ,
IF(AVG(age)>50,'老鸟','菜鸟')
'老鸟or菜鸟'
FROM t_emp a
INNER JOIN t_dept b
ON a.deptId = b.id
GROUP BY b.deptName;

EXPLAIN  SELECT SQL_NO_CACHE  b.deptName ,
IF(AVG(age)>50,'老鸟','菜鸟')
'老鸟or菜鸟'
FROM dept b
STRAIGHT_JOIN emp a
ON a.deptId = b.id
GROUP BY b.deptName;

CREATE INDEX idx_deptid ON emp(deptid);

CREATE INDEX idx_deptname ON dept(deptname);

-- 7.显示每个门派年龄最大的人
SELECT aa.name,ab.age FROM t_emp aa
INNER JOIN
(
	SELECT a.deptId,MAX(a.age) age
	FROM t_emp a
	WHERE a.deptId IS NOT NULL
	GROUP BY a.deptId
) ab ON aa.deptId = ab.deptid AND aa.age = ab.age;

EXPLAIN SELECT SQL_NO_CACHE aa.name,ab.age
FROM emp aa
INNER JOIN
(
	SELECT a.deptId,MAX(a.age) age
	FROM emp a
	WHERE a.deptId IS NOT NULL
	GROUP BY a.deptId
) ab
ON aa.deptId = ab.deptid
AND aa.age = ab.age;

CREATE INDEX idx_deptid_age ON emp(deptid,age);


-- 8.显示每个门派年龄第二大的人
##  扩展性不好 ，需要取更多名次 无法实现
EXPLAIN SELECT SQL_NO_CACHE emp.name,dept.deptname
	FROM (SELECT MAX(age) MAX,a.deptid
		FROM (SELECT MAX(age) MAX,deptid  FROM  emp GROUP BY deptid) a
		INNER JOIN  emp b ON a.deptid = b.deptid
		WHERE b.age !=a.max
		GROUP BY a.deptid) d
	INNER JOIN  emp emp ON d.deptid = emp.deptid
	INNER JOIN  dept dept ON emp.deptid = dept.id
	WHERE age = d.max;

#分组排名
SET @rank = 0;
SET @last_deptid = 0;
EXPLAIN SELECT * FROM(
SELECT
	t.*,
	IF(@last_deptid=deptid,@rank:=@rank+1,@rank:=1) AS rk,
	 @last_deptid:=deptid AS last_deptid
	FROM t_emp t
	ORDER BY deptid,age DESC
) a WHERE a.rk = 2;

SET @rank = 0;
SET @last_deptid = 0;
SELECT NAME FROM(
SELECT
	t.*,
	IF(@last_deptid=deptid,@rank:=@rank+1,@rank:=1) AS rk,
	 @last_deptid:=deptid AS last_deptid
	FROM emp t
	ORDER BY deptid,age DESC
) a WHERE a.rk = 2;

SHOW INDEX FROM emp;

SELECT a.name ,a.age,a.ceoname newceo,c.name ceoname
FROM t_emp a
LEFT JOIN t_dept b ON a.deptId = b.id
LEFT JOIN t_emp c ON b.CEO = c.id;

SELECT a.name,a.age,a.ceoname FROM t_emp a;

#冗余字段
UPDATE t_emp a
LEFT JOIN t_dept b ON a.deptId = b.id
LEFT JOIN t_emp c ON b.CEO = c.id
SET a.ceoname = c.name

UPDATE t_dept SET ceo = 5 WHERE id =2;

#跨表更新
ALTER TABLE t_emp ADD COLUMN ceoname VARCHAR(200);

#触发器
DELIMITER $$
##触发器更新冗余
CREATE TRIGGER trig_update_dept
AFTER UPDATE ON t_dept
FOR EACH ROW
 BEGIN
  UPDATE t_emp a
  LEFT JOIN t_dept b ON a.deptId = b.id
  LEFT JOIN t_emp c ON b.CEO = c.id
  SET a.ceoname = c.name
  WHERE a.deptid = new.id;
 END $$
DELIMITER ;

##不要自己触发自己
CREATE TRIGGER trig_update_dept
AFTER UPDATE ON t_emp
FOR EACH ROW
  BEGIN
	  UPDATE t_emp a
	    LEFT OUTER JOIN  t_dept b ON a.deptid=b.id
	    LEFT JOIN  t_emp c ON b.ceo=c.id
	  SET a.ceoname=c.name
	  WHERE a.deptid=NEW.id;
  END $$

UPDATE t_emp SET NAME ='萧峰'  WHERE id =5

SET @rank = 0;
SET @last_deptid = 0;
SELECT empno,NAME,rk FROM(
SELECT t.*,
IF(@last_deptid=deptid,@rank:=@rank+1,@rank:=1) AS rk,
@last_deptid:=deptid AS last_deptid
FROM t_emp t
ORDER BY deptid,age DESC
) a ;


SET @rank = 0;
SET @last_deptid = 0;
CREATE TABLE t_top_emp
AS
SELECT empno,NAME,rk FROM(
SELECT t.*,
IF(@last_deptid=deptid,@rank:=@rank+1,@rank:=1) AS rk,
@last_deptid:=deptid AS last_deptid
FROM t_emp t
ORDER BY deptid,age DESC
) a ;

SELECT * FROM t_top_emp;

TRUNCATE TABLE t_top_emp;

SET @rank = 0;
SET @last_deptid = 0;
INSERT INTO t_top_emp
SELECT empno,NAME,rk FROM(
SELECT t.*,
IF(@last_deptid=deptid,@rank:=@rank+1,@rank:=1) AS rk,
@last_deptid:=deptid AS last_deptid
FROM t_emp t
ORDER BY deptid,age DESC
) a ;

DELIMITER $$
CREATE PROCEDURE proc_top_emp()
BEGIN
  TRUNCATE TABLE t_top_emp;
  SET @rank = 0;
  SET @last_deptid = 0;
  INSERT INTO t_top_emp
  SELECT empno,NAME,rk FROM(
  SELECT t.*,
  IF(@last_deptid=deptid,@rank:=@rank+1,@rank:=1) AS rk,
  @last_deptid:=deptid AS last_deptid
  FROM t_emp t
  ORDER BY deptid,age DESC
  ) a ;
END $$

CALL proc_top_emp();

SHOW  VARIABLES  LIKE '%event_scheduler%';
SET GLOBAL event_scheduler =1;

-- 事件
DELIMITER $$
CREATE event ev_top_emp
ON SCHEDULE EVERY 1 MINUTE START NOW()
ON COMPLETION PRESERVE ENABLE
DO
  BEGIN
    CALL proc_top_emp();
  END $$

# oracle 物化视图