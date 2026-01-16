use hr_analytics;
select * from employee_cleaned;

#Distinct Employee Count
SELECT COUNT(DISTINCT EmployeeID) AS distinct_employees
FROM employee_cleaned;

#Active Employees
SELECT COUNT(DISTINCT EmployeeID) AS distinct_employees 
FROM employee_cleaned where Status="Active";

#Terminated Employees
SELECT COUNT(DISTINCT EmployeeID) AS distinct_employees 
FROM employee_cleaned where Status="Terminated";

#Status Unknown
SELECT COUNT(DISTINCT EmployeeID) AS distinct_employees 
FROM employee_cleaned where Status="Unknown";

#Department wise Active Employee count
SELECT ltrim(rtrim(Department)) as Department ,COUNT(DISTINCT EmployeeID) AS distinct_employees 
FROM employee_cleaned where Status="Active" group by department order by distinct_employees desc;

#Yearly Employee Intake
select year(HireDate) as Hire_year,count(distinct employeeID) as emp_cnt from employee_cleaned group by hire_year order by hire_year asc;

#Performance Rating by Gender
select round(avg(performancerating),2) as performance_rating,ltrim(rtrim(gender)) as gender from employee_cleaned group by ltrim(rtrim(gender));

#Active Employees by Jobtitle
SELECT COUNT(DISTINCT EmployeeID) AS distinct_employees,ltrim(rtrim(Jobtitle)) as Jobtitle
FROM employee_cleaned where Status="Active" group by ltrim(rtrim(jobtitle)) order by distinct_employees desc;

#Average tenue in years
SELECT 
    ROUND(AVG(
        DATEDIFF(
            COALESCE(TerminationDate, CURRENT_DATE),
            HireDate
        ) / 365.0
    ), 2) AS avg_tenure_years,ltrim(rtrim(gender)) as gender
FROM employee_cleaned group by ltrim(rtrim(gender)) order by avg_tenure_years desc;

#Average Salary
select round(avg(Salary),2) as Salary from employee_cleaned;

#Attrition Rate
SELECT
    ROUND(
        COUNT(CASE WHEN TerminationDate IS NOT NULL THEN 1 END) * 100.0 /
        COUNT(*),
        2
    ) AS attrition_rate_percent
FROM employee_cleaned;


#Attrition rate by gender
SELECT
    ROUND(
        COUNT(CASE WHEN TerminationDate IS NOT NULL THEN 1 END) * 100.0 /
        COUNT(*),
        2
    ) AS attrition_rate_percent,ltrim(rtrim(gender)) as gender
FROM employee_cleaned group by ltrim(rtrim(gender)) order by attrition_rate_percent desc;

#Department wise  Employees Terminated 
SELECT ltrim(rtrim(Department)) as Department ,COUNT(DISTINCT EmployeeID) AS distinct_employees 
FROM employee_cleaned where Status="Terminated" group by department order by distinct_employees desc;

#Yearly Employee Terminated
select year(TerminationDate) as Term_year,count(distinct employeeID) as emp_cnt from employee_cleaned group by Term_year order by Term_year asc;

#Jobtitle by Employees Terminated
SELECT ltrim(rtrim(Jobtitle)) as Jobtitle,COUNT(DISTINCT EmployeeID) AS distinct_employees 
FROM employee_cleaned where Status="Terminated" group by Jobtitle order by distinct_employees desc;

#Salary Slab
SELECT
    EmployeeID,
    Salary,
    CASE
        WHEN Salary < 60000 THEN 'Below 60K'
        WHEN Salary BETWEEN 60000 AND 79999 THEN '60K–79K'
        WHEN Salary BETWEEN 80000 AND 99999 THEN '80K–99K'
        WHEN Salary BETWEEN 100000 AND 119999 THEN '100K–119K'
        WHEN Salary BETWEEN 120000 AND 139999 THEN '120K–139K'
        WHEN Salary BETWEEN 140000 AND 159999 THEN '140K–159K'
        ELSE '160K+'
    END AS salary_slab
FROM employee_cleaned;

#Attrition rate by salary slab
WITH salary_data AS (
    SELECT
        CASE
            WHEN Salary < 60000 THEN 'Below 60K'
            WHEN Salary BETWEEN 60000 AND 79999 THEN '60K-79K'
            WHEN Salary BETWEEN 80000 AND 99999 THEN '80K-99K'
            WHEN Salary BETWEEN 100000 AND 119999 THEN '100K-119K'
            WHEN Salary BETWEEN 120000 AND 139999 THEN '120K-139K'
            WHEN Salary BETWEEN 140000 AND 159999 THEN '140K-159K'
            ELSE '160K+'
        END AS salary_slab,
        TerminationDate
    FROM employee_cleaned
    WHERE Salary IS NOT NULL
)

SELECT
    salary_slab,
    ROUND(
        COUNT(CASE WHEN TerminationDate IS NOT NULL THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM salary_data
GROUP BY salary_slab
ORDER BY attrition_rate_percent DESC;


#Salary slab,average salary by gender
WITH salary_data AS (
    SELECT
        LTRIM(RTRIM(gender)) AS gender,
        Salary,
        CASE
            WHEN Salary < 60000 THEN 'Below 60K'
            WHEN Salary BETWEEN 60000 AND 79999 THEN '60K-79K'
            WHEN Salary BETWEEN 80000 AND 99999 THEN '80K-99K'
            WHEN Salary BETWEEN 100000 AND 119999 THEN '100K-119K'
            WHEN Salary BETWEEN 120000 AND 139999 THEN '120K-139K'
            WHEN Salary BETWEEN 140000 AND 159999 THEN '140K-159K'
            ELSE '160K+'
        END AS salary_slab
    FROM employee_cleaned
    WHERE Salary IS NOT NULL
      AND gender IS NOT NULL
)

SELECT
    gender,
    salary_slab,
    COUNT(*) AS employee_count,
    ROUND(AVG(Salary), 2) AS avg_salary
FROM salary_data
GROUP BY gender, salary_slab
ORDER BY gender, avg_salary DESC;




