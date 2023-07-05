Use Projects;
Select * from hr;


ALTER Table hr 
Change column ï»¿id emp_id varchar(20) Null;


Describe Hr;



select birthdate from hr;

Set sql_safe_updates=0;

Update hr
set birthdate = case
    when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
    else Null
End;

Alter table hr
modify column birthdate Date;



Select hire_date from hr;
Update hr
set hire_date= case
    when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
    when birthdate like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'), '%Y-%m-%d')
    else Null
End;

Alter table hr
modify column hire_date  Date;





Select termdate from hr;

Update hr 
set termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
where termdate is  null and termdate!= '';

Set sql_mode ='';

Alter table hr
modify column termdate Date;

Select termdate from hr;




Alter table hr Add column age int;

update Hr
Set age = timestampdiff(Year, birthdate, curdate());
Select birthdate, age from hr;

Select
  min(age) As Youngest, 
  max(age) as Oldest
  from hr;
  
select count(*) from hr where age<18;
----------------------------------------------------------------------------------------------------------

-- Questions
-- 1. What is the gender breakdown of employees in the company?
Select gender, count(*) as Count
from Hr
Where age>=18 and termdate='0000-00-00'
Group by Gender;


-- 2. What is the race/ethnicity breakdown of employees in the company?
Select race, Count(*) as Count
from hr
Where age>=18 and termdate='0000-00-00'
Group by race
Order by Count(*) Desc;


-- 3. What is the age distribution of employees in the company?
Select
  min(age) As Youngest, 
  max(age) as Oldest
  from hr
Where age>=18 and termdate='0000-00-00';

Select 
     Case
        When age>=18 and age<=24 then '18-24'
        When age>=25 and age<=34 then '25-34'
        When age>=35 and age<=44 then '35-44'
		When age>=45 and age<=54 then '45-54'
        When age>=55 and age<=64 then '55-64'
        Else '65+'
End As age_group,
count(*) as Count
from hr
Where age>=18 and termdate='0000-00-00'
Group by age_group
Order by age_group;

Select 
     Case
        When age>=18 and age<=24 then '18-24'
        When age>=25 and age<=34 then '25-34'
        When age>=35 and age<=44 then '35-44'
		When age>=45 and age<=54 then '45-54'
        When age>=55 and age<=64 then '55-64'
        Else '65+'
End As age_group, gender,
count(*) as Count
from hr
Where age>=18 and termdate='0000-00-00'
Group by age_group, gender
Order by age_group, gender;
        


-- 4. How many employees work at headquaters versus remote locations?
Select location, Count(*) as Count 
from hr
Where age>=18 and termdate='0000-00-00'
Group by location;


-- 5. What is the avg lenth of employment for employees who have been terminated?
Select 
    round(avg(datediff(termdate, hire_date))/365,0) As avg_lenth_employment
    from hr
where termdate<=curdate() and termdate<>'0000-00-00' and age>=18;


-- 6. How does the gender distribution vary across departments and jobs titles?
Select department, gender , count(*) as Count
From hr 
Where age>=18 and termdate='0000-00-00'
Group by department, gender
order by department;


-- 7. What is the distribution of job titles across the company?	
Select jobtitle, count(*) as count
from hr
Where age>=18 and termdate='0000-00-00'
group by jobtitle
order by jobtitle desc;


-- 8. Which department has the highest turnover rate?
Select department,
       total_count,
       terminated_count,
       terminated_count/ total_count as termination_rate
From (
     Select department,
     count(*) as total_count,
     Sum( Case when termdate<>'0000-00-00' and termdate<=curdate() Then 1 Else 0 end) as terminated_count
     From hr
     Where age>=18
     group by department
	 ) As subquery
Order by termination_rate Desc;


-- 9. What is the distribution of employees across locations by city and state?
Select location_state, count(*) as Count
from hr 
Where age>=18 and termdate='0000-00-00'
Group by location_state
Order by Count desc;


-- 10. How has the company's employee count changed over time based on hire and termdates?
Select 
     year,
     hires,
     terminations,
     hires-terminations as net_change,
     round((hires-terminations)/hires*100,2) as net_change_percent
From (
      Select 
      year(hire_date) as year,
      count(*) as hires,
      Sum( Case when termdate<>'0000-00-00' and termdate<=curdate() Then 1 Else 0 end) as terminations
      From hr
      Where age>=18
      Group by year (hire_date)
      ) As subquery
Order by year Asc;


-- 11. What is the tenure distribution for each department?
Select department, round(avg(datediff(termdate, hire_date)/365),0) As avg_tenure
from hr
where termdate<= curdate() and termdate<>'0000-00-00' and age>=18
Group by department;


        







