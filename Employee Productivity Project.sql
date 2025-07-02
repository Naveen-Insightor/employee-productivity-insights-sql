-- NAME : NAVEEN N 
-- GITHUB : Naveen_Insightor

Create Database Emp_Productivity;
use Emp_Productivity;

create table Employee (Emp_ID varchar(20) Primary key,Emp_Name Varchar(200),
Department varchar(100), Role varchar(100),JoinDate Date, Location varchar(100));
select * from employee;

create table Dailylogs (Emp_ID varchar(20), Date Date,
Hours_worked Decimal(4,1),Task_completed INT,Task_Summary TEXT,
FOREIGN KEY (Emp_ID) references Employee(Emp_ID));
select * from  Dailylogs;
Show tables;

-- IMPORT WIZARD-- 

-- TOTAL RECORDS
select count(*) from employee;
select count(*) from Dailylogs;
-- Columns check
SELECT * FROM EMPLOYEE;
SELECT * FROM DAILYLOGS;

-- KPI Calculations
-- Total hours worked	Total time spent by each employee
select b.Emp_name,sum(a.Hours_worked)Total_Hours 
from dailylogs as a inner join employee as b
on a.Emp_ID = b.EMP_ID
Group by Emp_name;

-- Avg daily hours worked	(Total hours / no. of working days)
select avg(Hours_worked) from dailylogs; 						-- Overall employees average working in organization
select Emp_ID,sum(hours_worked)/22 from dailylogs group by 1; 	-- Aveage working of each employee

-- Total tasks completed	Sum of daily tasks completed
select sum(task_completed)Total_Task from dailylogs;

-- Tasks per hou   Tasks_Completed ÷ Hours_Worked
select Sum(task_completed)/sum(hours_worked)Task_perH from dailylogs;   -- OVERALL Employee
select emp_id , sum(task_completed)/sum(hours_worked)Task_perH from dailylogs Group by Emp_id; -- Per employee

-- Productivity score   (Custom score = Task per hur *100 + Hours worked) out of 100
select Emp_ID,sum(task_completed)*100/sum(Hours_worked)Pro_Score from dailylogs group by EMP_ID;

-- Days Active	Number of distinct days worked // Number of days employee worked;
select Count(distinct Date) from dailylogs;

-- Low Hour Day (Total Days worked < 4 hours)
Select COUNT(*) FROM DAILYLOGS WHERE HOURS_WORKED <=4 ; --  by overall
Select Emp_id,COUNT(*)LowHrDays FROM DAILYLOGS WHERE HOURS_WORKED <=4 group by 1; -- By employe


-- Late Joiners based on MID DATE  -- DATE_ADD(MIN(D), INTERVAL ** DAY)
-- Find MID date of Dataset
select min(joindate),max(joindate),							   			
DATE_ADD(MIN(JOINDATE),INTERVAL DATEDIFF(MAX(JOINDATE),MIN(JOINDATE))/2 DAY)Mid_Date from employee;
-- FIND all emp join after min date
select Emp_Name , JoinDate from employee where joindate >( 				 
select DATE_ADD(MIN(JOINDATE),INTERVAL DATEDIFF(MAX(JOINDATE),MIN(JOINDATE))/2 DAY)Mid From employee);


-- Avg hours per department	Overall department effort
Select a.Department , Round(avg(b.hours_worked),2)Average_hrs from employee as a inner join dailylogs as b 
on a.Emp_ID = b.EMP_ID group by a.Department;

-- Total tasks by department	Workload contribution per department
select a.Department, count(b.Task_completed)TOT_tasks from Employee as a inner join Dailylogs as b
on a.Emp_ID = b.Emp_ID group by a.Department order by Tot_tasks desc;

-- Top performing roles	Highest avg. tasks/hour by role
Select a.Role ,sum(b.task_completed)/sum(b.hours_worked)Task_perhour from employee as a inner join dailylogs as b
on a.Emp_ID = b.Emp_ID group by a.role ORDER BY A.ROLE DESC;

-- Departments with underperformance    Based on   -- low hours 
Select a.Department ,avg(b.hours_worked)Tot_Hrs from employee as a inner join dailylogs as b
on A.Emp_ID = B.Emp_ID GROUP BY 1 having Tot_hrs <(
select avg(hours_worked) from dailylogs);
                                                  -- Low tasks
select a.Department , avg(b.Task_completed)Avg_Tasks from employee as a inner join dailylogs as b
on a.emp_id = b.emp_id  group by a.department having Avg_Tasks <
(select avg(Task_completed) from dailylogs);
												   -- Low Task per hr
select a.Department ,sum(task_completed)/sum(hours_worked)Task_perHR  from employee as a inner join dailylogs as b
on a.emp_id = b.emp_id  group by a.department having Task_perHR <
(select AVG(Task_completed)/AVG(HOURS_WORKED) from dailylogs);

-- Metric	Description
-- Daily trend of avg hours	Time-series of effort over time
select date,Dayname(date)Day,avg(hours_worked)Avg_WorkHRTrend from dailylogs  group by date order by 1;

-- Daily tasks completed	Workload trend over time
select date,count(task_completed)Task_Trend from dailylogs group by 1; -- Very stable trend 

-- Weekly peak/off-peak days	Identify which weekdays are productive
select dayname(date)WeekDays ,avg(task_completed)Tasks,avg(hours_worked)Hours from dailylogs 
group by WeekDays order by field(WeekDays,'tueday','wednesday','thursday','friday','saturday','sunday')  ;

-- Date of lowest performance   Date with lowest avg tasks/Hour
select Date,sum(Task_completed)/sum(Hours_worked)as Avg_TaskperH from dailylogs GROUP BY 1 hAVING Avg_TaskperH <( 
select sum(task_completed)/sum(hours_worked)TaskAvg_Hour from dailylogs) order by 1;

#Category Logic
-- Top performers	Tasks per hour > 90th percentile
select * from (
select b.Emp_name, sum(a.task_completed)/sum(a.Hours_worked)T_perH , 
NTILE(100) OVER (ORDER BY sum(task_completed)/sum(Hours_worked))Bucket100 
from dailylogs as a inner join employee as b on a.Emp_id = b.Emp_ID group by b.Emp_ID)a 
Where Bucket100 > 90;

-- Consistent	Worked all business days Employees who login everyday
select count(distinct date)Unique_Dates from dailylogs ; -- Actual Working dates

select Emp_Id , count(date)Logins from dailylogs group by Emp_Id having logins >=(
select count(distinct date)Working_days from dailylogs); 

-- Underperformers	<7 avg hours or <1 tasks/hour
select Emp_ID, avg(Hours_worked)Avg_Hrs , 
Sum(Task_completed)/Sum(hours_worked)as Task_perH from dailylogs group by Emp_ID
Having Avg_Hrs < 7 and Task_perH < 1 ORDER BY Emp_ID;

#Metric	Description
-- Active vs Inactive Employees	Employees with logs vs. those without
-- FIND THE ACTIVE MEMBERS IN DAILY LOGS AND EMPLOYEES TABLE TOO
select count(emp_id)Tot_Emp from employee; -- Total employees
select count(distinct emp_Id)Active_Emp from dailylogs; -- ACTIVE

#left join to know the weather all employees of left table in right are there any null
select count(Distinct a.Emp_Id)Emp from employee as a left join dailylogs as b
on A.Emp_ID = B.Emp_ID Where b.Emp_ID is NULL;  -- There are no Inactive employees

-- % days attended	Days worked / total working days
select emp_ID ,concat(round(count(DISTINCT Date)*100/22,0),"%")as `% Days Attended` 
from dailylogs group by Emp_ID;

-- Insight	Value
-- Who is overloaded?	Employees with >8 hours consistently
select b.Emp_Name, avg(a.Hours_worked)Avg_Hrs from dailylogs as a inner join employee as b
on a.emp_id = b. emp_id group by 1 having Avg_Hrs > 8;


-- Are interns working more than leads?	Compare productivity by role
select role,sum(Task_completed)Total_Task,sum(hours_worked)Tot_Hrs,
sum(Task_completed)/sum(hours_worked)*10 TASK_PH from employee AS A INNER JOIN dailylogs as b
on a.emp_id = b.Emp_ID group by Role Having role in ("Intern","Lead");

#ADVANCED
-- Rolling 7-day average of productivity
select *,avg(Pro_score) over(order by date Rows between 6 preceding and current row)Rolling7_daysAvg from (
select date , sum(task_completed)/sum(hours_worked)Pro_Score from dailylogs group by 1) a;

-- Cumulative task count over week as data is available for one week
select *, Sum(Tasks) over(order by Weekno)CummTasks from (
Select  monthname(date)Month,week(date)Weekno, sum(Task_completed)Tasks
 from dailylogs group by 1,2)a;

-- Employee ramp-up time after joining
select a.emp_name,Joindate, min(b.date)First_Task, datediff(min(b.date),a.joindate)Warmup_DaysTAKEN 
from employee as a inner join dailylogs as b
on a.emp_id = b.emp_id Where b.date > a.joindate group by 1,2;

-- Time between joining and first task
select a.Emp_name,a.Joindate,Min(b.Date)FirstTask, datediff(Min(b.date),Joindate)Time_Taken 
from employee as a inner join dailylogs as b 
on a.emp_ID= b.emp_ID Where a.joindate < b.date group by 1,2 order by 1;

-- Find the most productive day (highest tasks/hour) for each employee  NOO SUM Bcauz Non Aggregated
select * from ( 
Select Emp_ID,Date, Task_completed/hours_worked as Task_PerH,
row_number() over(Partition by Emp_ID order by Task_completed/hours_worked desc )Rnk
from dailylogs )a Where Rnk = 1  ;

-- Rank departments by total hours worked and (find if any tie-- RANK)
select a.Department , sum(b.Hours_worked)Hours, rank() over (order by sum(b.Hours_worked) desc)Ranks
 from employee as a inner join dailylogs as b 
on a.emp_id = b. emp_id group by 1;

-- Densely rank roles by average tasks per hour across all employees.
select Role, sum(task_completed)/sum(hours_worked)Task_H , dense_rank() over (order by sum(task_completed)/sum(hours_worked) desc)D_Rank 
from employee as a inner join dailylogs as b on a.Emp_ID = b.Emp_ID group by 1; 

-- Divide employees into 4 productivity quartiles based on tasks per hour.
select a.Emp_Name, sum(b.task_completed)/sum(b.hours_worked)Task_H, Ntile(4) over(order by sum(b.task_completed)/sum(b.hours_worked))Qtile 
from employee as a join dailylogs as b
on a.Emp_ID = b.Emp_ID group by 1;

-- Identify employees whose productivity dropped from the previous day. 
select Emp_ID, DATE, Task_PH, concat(Round(`%change`,0),"%")PD_Change from (
select Emp_ID, Date, Task_completed/hours_worked as Task_PH,(Task_completed/hours_worked-lag(Task_completed/hours_worked) over(order by date))*100/
lag(Task_completed/hours_worked) over(order by date) as`%change`
from dailylogs)a Where `%change` < 0;

-- Get the first day each employee logged any hours (first active day).
select DISTINCT Emp_ID, first_value(Date) over (order by Emp_ID)First_login FROM dailylogs;

-- Find the last day an employee was active before going absent.
Select  Distinct Emp_ID , Last_value(Date) over(order by Emp_ID)last_Login from dailylogs;


 -- CUME_DIST() Considering 1 as full it distibutes how many people are behind him
 -- Shows How many rows are less than or equal to current row
 
-- Calculate cumulative distribution of employees based on tasks/hour.
Select EMp_id, Sum(Task_completed)/sum(Hours_worked)as Task_PerH,
cume_dist() OVER(Order by Sum(task_completed)/sum(hours_worked)) as Cum_Dist
from dailylogs group by EmP_ID;


-- PERCENT_RANK() -- Divede Data into 100 parts starting from 0-1
-- Compare employee efficiency rank as a percentile, ignoring ties.
Select Emp_ID, percent_rank() over(order by Sum(task_completed)/sum(hours_worked))Per_Rnk 
from dailylogs group by 1;
