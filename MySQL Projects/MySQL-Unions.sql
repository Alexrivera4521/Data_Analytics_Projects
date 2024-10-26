-- unions 

select first_name, last_name from parks_and_recreation.employee_demographics
union -- Union distinct by default
SELECT first_name, last_name FROM parks_and_recreation.employee_salary;

select first_name, last_name from parks_and_recreation.employee_demographics
union all -- with duplicates
SELECT first_name, last_name FROM parks_and_recreation.employee_salary;

select first_name, last_name, 'Old Man' as Label from parks_and_recreation.employee_demographics WHERE AGE > 40 and gender = 'Male'
union
select first_name, last_name, 'Old Lady' as Label from parks_and_recreation.employee_demographics WHERE AGE > 40 and gender = 'Female'
union
SELECT first_name, last_name, 'Highly paid employee' as Label FROM parks_and_recreation.employee_salary where salary > 70000 
ORDER BY first_name, last_name;


