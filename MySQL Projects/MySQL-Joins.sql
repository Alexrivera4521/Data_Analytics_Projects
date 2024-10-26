SELECT ed.*, es.* FROM parks_and_recreation.employee_demographics ed left outer join parks_and_recreation.employee_salary es on es.employee_id = ed.employee_id;

SELECT * FROM parks_and_recreation.employee_salary;
select * from parks_and_recreation.employee_demographics;
SELECT * FROM parks_departments;


-- Outer Joins
SELECT ed.*, es.* FROM parks_and_recreation.employee_demographics ed right join parks_and_recreation.employee_salary es on es.employee_id = ed.employee_id;

-- Self join: Secret Santo Example
select 
s1.employee_id s1_santa,
s1.first_name s1_first_name_santa,
s1.last_name s1_last_name_santa,
s2.employee_id s2_santa,
s2.first_name s2_first_name_santa,
s2.last_name s2_last_name_santa
from employee_salary s1 join employee_salary s2 on s1.employee_id + 1 = s2.employee_id;


-- Join Multiple tables together
SELECT 
    *
FROM
    parks_and_recreation.employee_demographics ed
        INNER JOIN
    parks_and_recreation.employee_salary es ON es.employee_id = ed.employee_id
        INNER JOIN
    parks_departments pd on es.dept_id = pd.department_id;

