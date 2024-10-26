-- So let's look at how we can create a stored procedure

-- First let's just write a super simple query
SELECT *
FROM employee_salary
WHERE salary >= 60000;

-- Now let's put this into a stored procedure.
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 60000;

CALL large_salaries();


-- Now how we have written is not actually best practice.alter
-- Usually when writing a stored procedure you don't have a simple query like that. It's usually more complex

-- if we tried to add another query to this stored procedure it wouldn't work. It's a separate query:
DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;
END $$
DELIMITER ;


CALL large_salaries3();



USE `parks_and_recreation`;
DROP procedure IF EXISTS `new_procedure`;
DELIMITER $$
USE `parks_and_recreation`$$
CREATE PROCEDURE `new_procedure` ()
BEGIN
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;
END$$
DELIMITER ;


-- Parameters
DELIMITER $$
CREATE PROCEDURE large_salaries7(p_test INT)
BEGIN
SELECT salary
FROM employee_salary
where employee_id = p_test
;
END $$
DELIMITER ;

CALL large_salaries7(1)






