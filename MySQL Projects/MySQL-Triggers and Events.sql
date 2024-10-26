-- Triggers and Events

SELECT * FROM employee_demographics;
select * from employee_salary;


DELIMITER $$
CREATE TRIGGER employee_insert
	after insert on employee_salary
    for each row 
begin
	insert into employee_demographics(employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;


insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Alex','Rivera','Analyst','120000', null);

select * from employee_salary;

SELECT * FROM employee_demographics;



-- EVENTS
-- Take place on a schedule

delimiter $$
CREATE EVENT retire_employee
on schedule every 30 second
do
begin
	delete FROM employee_demographics where age >= 60;
end $$
delimiter ;

SHOW VARIABLES LIKE 'event%';
