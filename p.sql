DROP DATABASE student_society;
create database student_society;
use student_society;
SET SQL_SAFE_UPDATES = 0;#safe mode 
create table STUDENT(
`Roll No` char(6) PRIMARY key,
StudentName varchar(20),
Course VARCHAR(10),
DOB date
);

insert into STUDENT VALUES("1","Rahul","CS","2000-12-25");
insert into STUDENT values("2","Mohal","chemistry","2002-10-10");
insert into STUDENT values("39","Kunal","Maths","2001-04-04");
insert into STUDENT values("A4","Ramesh","Bio","2005-02-28");
insert into STUDENT values("X5","Arman","BMS","2004-02-25");

CREATE TABLE SOCIETY(
SocID CHAR(6) primary key,
SocName VARCHAR(20),
MentorName VARCHAR(15),
TotalSeats INT unsigned
);

insert into SOCIETY values("0124","A","Himanshu",25);
insert into SOCIETY values("2354","B","Astha",50);
insert into SOCIETY values("138124","D","Prashant",30);
insert into SOCIETY values("3651","Z","Lalu",60);
insert into SOCIETY value("4512","NSS","Ankush",45);


CREATE TABLE ENROLLMENT(
`Roll No` Char(6)primary key,
SID CHAR(6) unique key,
DateOfEnrollment date,
FOREIGN KEY (`Roll No`) REFERENCES STUDENT(`Roll No`),
FOREIGN KEY (SID) REFERENCES SOCIETY(SocID)
);

insert into ENROLLMENT values("1","3651","2024-06-25");
insert into ENROLLMENT values("2","1246","2023-08-20");
insert into ENROLLMENT values("X5","3651","2021-02-16");
insert into ENROLLMENT values("A4","4512","2022-10-18");
insert into ENROLLMENT values("39","3651","2024-02-28");


#queries
#1
SELECT StudentName FROM STUDENT s JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`;
#2
SELECT SocName FROM SOCIETY;
#3
SELECT StudentName FROM STUDENT WHERE StudentName LIKE "A%";
#4
SELECT StudentName FROM STUDENT where Course = "CS" or Course = "chemistry";
#5
SELECT * FROM STUDENT WHERE `Roll No` LIKE "X%" or `Roll No` LIKE "Y%" AND `Roll No` LIKE "%9";
#6
#let N=20
SELECT 	* FROM SOCIETY WHERE TotalSeats > 20;
DESC SOCIETY;
#7
UPDATE SOCIETY SET MentorName = 'XYZ' WHERE SocID = '138124';
#8
SELECT s.SocName FROM SOCIETY s JOIN ENROLLMENT e ON s.SocID = e.SID 
GROUP BY s.SocName 
HAVING COUNT(e.`Roll No`) > 5;
#9
SELECT s.StudentName  FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
JOIN SOCIETY sc ON e.SID = sc.SocID
WHERE sc.SocName = "NSS"
ORDER BY s.DOB ASC
LIMIT 1;
#10
SELECT sc.SocName FROM SOCIETY sc
JOIN ENROLLMENT e ON sc.SocID = e.SID
GROUP BY sc.SocName
ORDER BY COUNT(e.`Roll No`) DESC
LIMIT 1;
#or
SELECT sc.SocName, COUNT(e.`Roll No`) AS TotalStudents
FROM SOCIETY sc
JOIN ENROLLMENT e ON sc.SocID = e.SID
GROUP BY sc.SocName
ORDER BY TotalStudents DESC
LIMIT 1;
 
#11
SELECT sc.SocName FROM SOCIETY sc 
JOIN ENROLLMENT e ON sc.SocID = e.SID
GROUP BY sc.SocName
ORDER BY COUNT(e.`Roll No`) ASC
LIMIT 2;

#12
SELECT StudentName s FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
#JOIN SOCIETY sc ON e.SID = sc.SocID
WHERE e.SID = null;
#13
SELECT s.StudentName FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
JOIN SOCIETY sc ON e.SID = sc.SocID
GROUP BY s.StudentName
HAVING COUNT(e.`Roll No`) >= 2;
#14
SELECT sc.SocName FROM SOCIETY sc
JOIN ENROLLMENT e ON sc.SocID = e.SID
group by sc.SocName
order by count(e.`Roll No`) desc
limit 1 ;
#15
SELECT s.StudentName, sc.SocName FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
JOIN SOCIETY sc ON e.SID = sc.SocID;
#16
SELECT s.StudentName FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
JOIN SOCIETY sc ON e.SID = sc.SocID
WHERE sc.SocName = "Debating" OR sc.SocName = "Dancing" OR sc.SocName = "Sashakt";
#17
SELECT sc.SocName FROM SOCIETY sc
WHERE sc.MentorName = "GUPTA";
#18
SELECT sc.SocName FROM SOCIETY sc
JOIN ENROLLMENT e ON sc.SocID = e.SID
JOIN STUDENT s ON e.`Roll No` = s.`Roll No`
GROUP BY sc.SocName,sc.TotalSeats
HAVING COUNT(e.`Roll No`) = floor(0.1 * sc.TotalSeats);
#19
SELECT sc.SocName, sc.TotalSeats, COUNT(e.`Roll No`) AS FillSeats,
sc.TotalSeats - Count(e.`Roll No`) AS VacantSeats
FROM SOCIETY sc
LEFT JOIN ENROLLMENT e ON sc.SocID = e.SID
Group by sc.SocName, sc.TotalSeats;
#20
UPDATE SOCIETY
SET TotalSeats = floor (TotalSeats * 1.1);
#21
ALTER TABLE ENROLLMENT
ADD Fees enum("Yes","No") default "No";
#22
UPDATE ENROLLMENT
SET DateOfEnrollment = CASE
WHEN SID = "0124" then "2018-01-15"
WHEN SID = "1246" then current_date()
WHEN SID = "138124" then "2018-01-02"
ELSE DateOfEnrollment
END
WHERE SID IN ("0124","1246","138124");

#ALTER TABLE SOCIETY
#DROP COLUMN TotalStudentEnrolled;
#23
CREATE VIEW SocietyEnrollmentViews AS SELECT sc.SocName,COUNT(e.`Roll No`) AS 	TotalEnrolled FROM SOCIETY sc 
LEFT JOIN ENROLLMENT e ON sc.SocID = e.SID
GROUP BY sc.SocID,sc.SocName;

DESC SOCIETY;
#view result/table
SELECT * FROM SocietyEnrollmentViews;

#24
SELECT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
GROUP BY s.`Roll No`, s.StudentName
HAVING COUNT(DISTINCT e.SID) = (SELECT COUNT(*) FROM SOCIETY);
#or HAVING COUNT(DISTINCT e.SID) = (SELECT COUNT(SOCIETY.SocID) FROM SOCIETY);

#25
SELECT COUNT(*) 
FROM (
    SELECT SID 
    FROM ENROLLMENT 
    GROUP BY SID 
    HAVING COUNT(`Roll No`) > 5
) AS temp;

#26
ALTER TABLE STUDENT
ADD `Mob No` varchar(10) default "99999999";

#27
SELECT COUNT(*) AS Studentsof20
FROM  STUDENT
WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) > 20;

#28
SELECT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.`Roll No` = e.`Roll No`
WHERE YEAR(s.DOB) = 2001;

#29
SELECT COUNT(*) 
FROM SOCIETY s
JOIN ENROLLMENT e ON s.SocID = e.SID
WHERE s.SocName LIKE 'S%t' 
GROUP BY s.SocID
HAVING COUNT(DISTINCT e.`Roll No`) >= 5;

#30
SELECT 
    s.SocName AS SocietyName,
    s.MentorName AS MentorName,
    s.TotalSeats AS TotalCapacity,
    COUNT(e.`Roll No`) AS TotalEnrolled,
    (s.TotalSeats - COUNT(e.`Roll No`)) AS UnfilledSeats
FROM SOCIETY s
LEFT JOIN ENROLLMENT e ON s.SocID = e.SID
GROUP BY s.SocID, s.SocName, s.MentorName, s.TotalSeats;

#/////////////////////////////
#DROP DATABASE company;

CREATE DATABASE company;
USE company;

CREATE TABLE DEPARTMENT (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE NOT NULL,
    Location VARCHAR(100)
);

CREATE TABLE EMPLOYEE (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    DepartmentID INT,
    ManagerID INT,
    FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES EMPLOYEE(EmployeeID) ON DELETE SET NULL
);

CREATE TABLE PROJECT (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(12,2)
);

CREATE TABLE EMPLOYEEPROJECTS (
    EmployeeID INT,
    ProjectID INT,
    Role VARCHAR(50),
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (ProjectID) REFERENCES PROJECT(ProjectID) ON DELETE CASCADE
);

CREATE TABLE SALARY (
    SalaryID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID INT,
    Amount DECIMAL(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID) ON DELETE CASCADE
);

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# Query 1: Retrieve the names of all employees who do not have supervisors.
SELECT FirstName, LastName 
FROM EMPLOYEE 
WHERE ManagerID IS NULL;

# Query 2: Retrieve the project IDs of projects that have an employee with the last name 'Smith' as a worker.
SELECT DISTINCT ProjectID
FROM EMPLOYEEPROJECTS
WHERE EmployeeID IN (
    SELECT EmployeeID FROM EMPLOYEE WHERE LastName = 'Smith'
);

# Query 3: Retrieve employees who work on the same project as 'John Smith'.
SELECT DISTINCT E1.FirstName, E1.LastName
FROM EMPLOYEE E1
JOIN EMPLOYEEPROJECTS EP1 ON E1.EmployeeID = EP1.EmployeeID
WHERE EP1.ProjectID IN (
    SELECT ProjectID FROM EMPLOYEEPROJECTS EP2
    JOIN EMPLOYEE E2 ON EP2.EmployeeID = E2.EmployeeID
    WHERE E2.FirstName = 'John' AND E2.LastName = 'Smith'
);

# Query 4: Retrieve the names of employees whose salary is greater than all employees in Department 5.
SELECT FirstName, LastName
FROM EMPLOYEE
WHERE Salary > ALL (
    SELECT Salary FROM EMPLOYEE WHERE DepartmentID = 5
);

# Query 5: Retrieve employees who have a salary greater than $50,000 and are assigned to at least one project.
SELECT DISTINCT FirstName, LastName
FROM EMPLOYEE
WHERE Salary > 50000 AND EmployeeID IN (
    SELECT EmployeeID FROM EMPLOYEEPROJECTS
);

# Query 6: Retrieve the total number of employees in each department.
SELECT DepartmentID, COUNT(*) AS TotalEmployees
FROM EMPLOYEE
GROUP BY DepartmentID;

# Query 7: Retrieve the total salary expense for each department.
SELECT D.DepartmentID, D.DepartmentName, SUM(E.Salary) AS TotalSalary
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentID;

# Query 8: Retrieve the highest, lowest, and average salary of employees.
SELECT MAX(Salary) AS HighestSalary, MIN(Salary) AS LowestSalary, AVG(Salary) AS AverageSalary
FROM EMPLOYEE;

# Query 9: Retrieve the details of employees who have no projects assigned.
SELECT * FROM EMPLOYEE
WHERE EmployeeID NOT IN (
    SELECT DISTINCT EmployeeID FROM EMPLOYEEPROJECTS
);

# Query 10: Retrieve the project names and number of employees working on each project.
SELECT P.ProjectName, COUNT(EP.EmployeeID) AS EmployeeCount
FROM PROJECT P
LEFT JOIN EMPLOYEEPROJECTS EP ON P.ProjectID = EP.ProjectID
GROUP BY P.ProjectName;

# Query 11: Retrieve the department with the highest total salary expense.
SELECT D.DepartmentName, SUM(E.Salary) AS TotalSalary
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentID
ORDER BY TotalSalary DESC
LIMIT 1;

# Query 12: Retrieve employees who joined before the year 2010.
SELECT FirstName, LastName, HireDate
FROM EMPLOYEE
WHERE YEAR(HireDate) < 2010;

# Query 13: Retrieve employees with the same last name working in different departments.
SELECT E1.FirstName, E1.LastName, E1.DepartmentID, E2.DepartmentID
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON E1.LastName = E2.LastName AND E1.EmployeeID <> E2.EmployeeID
WHERE E1.DepartmentID <> E2.DepartmentID;

# Query 14: Retrieve the project with the maximum budget.
SELECT ProjectName, Budget
FROM PROJECT
ORDER BY Budget DESC
LIMIT 1;

# Query 15: Retrieve employees who work on more than 3 projects.
SELECT E.FirstName, E.LastName, COUNT(EP.ProjectID) AS ProjectCount
FROM EMPLOYEE E
JOIN EMPLOYEEPROJECTS EP ON E.EmployeeID = EP.EmployeeID
GROUP BY E.EmployeeID
HAVING COUNT(EP.ProjectID) > 3;

# Query 16: Retrieve employees who do not have a phone number recorded.
SELECT FirstName, LastName
FROM EMPLOYEE
WHERE Phone IS NULL;

# Query 17: Retrieve employees whose salary is in the top 10% of all employees.
#SELECT FirstName, LastName, Salary 
#FROM EMPLOYEE 
#WHERE Salary >= (
#    SELECT MIN(Salary) FROM (
#        SELECT Salary 
#        FROM EMPLOYEE 
#        ORDER BY Salary DESC 
#        LIMIT (SELECT COUNT(*) * 0.1 FROM EMPLOYEE)
#    ) AS TopSalaries
#);



# Query 18: Retrieve the number of employees who have an email ending in '@company.com'.
SELECT COUNT(*) AS EmployeeCount
FROM EMPLOYEE
WHERE Email LIKE '%@company.com';

# Query 19: Retrieve the total number of employees who have worked on a project.
SELECT COUNT(DISTINCT EmployeeID) AS TotalEmployees
FROM EMPLOYEEPROJECTS;

# Query 20: Retrieve projects that started after January 1, 2020.
SELECT ProjectName, StartDate
FROM PROJECT
WHERE StartDate > '2020-01-01';

# Query 21: Retrieve employees who have the same first and last name as another employee.
SELECT FirstName, LastName, COUNT(*) AS Count
FROM EMPLOYEE
GROUP BY FirstName, LastName
HAVING COUNT(*) > 1;





1.	mysql -u root -p
2.	show databases;
3.	show index from STUDENT;
4.	create index rn on STUDENT (`Roll No`);
5.	create index rnc on STUDENT (`Roll No`,Course);
6.	DROP INDEX rnc ON STUDENT;
7.	create user 'user1'@'localhost' IDENTIFIED BY '1111';
8.	rename user 'user1'@'localhost' to 'localuser'@'localhost';
9.	create user 'temp'@'localhost' identified by '1111';
10.	drop user 'temp'@'localhost';
11.	GRANT ALL PRIVILEGES ON student_society.* TO 'localuser'@'localhost'; 
12.	GRANT SELECT, INSERT ON student_society.STUDENT TO 'localuser'@'localhost';
13.	create user 'localuser2'@'localhost' identified by '111';
14.	grant update,insert,select  on student_society.STUDENT TO 'localuser2'@'localhost';
15.	select Host,User from mysql.user;
16.	REVOKE SELECT ON student_society.* FROM 'localuser'@'localhost';
17.	SHOW GRANTS FOR 'localuser'@'localhost';
18.	REVOKE ALL PRIVILEGES ON *.* FROM 'localuser2'@'localhost';
19.	CREATE ROLE 'read_only';
20.	GRANT SELECT ON student_society.* TO 'read_only';
21.	GRANT 'read_only' TO 'localuser'@'localhost';
22.	DROP ROLE 'read_only';
23. REVOKE SELECT ON student_society.* FROM 'read_only';
