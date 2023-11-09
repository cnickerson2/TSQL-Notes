SELECT e.EMPLOYEEID, e.givenname, e.birthdate , d.name as DEPARTMENT
FROM employees e, departments d
WHERE e.depid = d.depid;
GO

-- CREATE VIEW SYNTAX
----------------------------------------
-- CREATE VIEW view_name
-- AS
-- SELECT column_name(s)
-- FROM table_name(s)
-- WHERE condition2

CREATE VIEW v_employees_dep
AS
SELECT e.EMPLOYEEID, e.givenname, e.birthdate , d.name as DEPARTMENT
FROM employees e, departments d
WHERE e.depid = d.depid;
GO

SELECT * from v_employees_dep;

DROP VIEW v_employees_dep;
GO

CREATE VIEW v_employees_dep (emp_id, emp_name, emp_surname, emp_birthdate, dep_name)
AS
SELECT e.EMPLOYEEID, e.givenname, e.surname, e.birthdate , d.name as DEPARTMENT
FROM employees e, departments d
WHERE e.depid = d.depid;
GO

SELECT * from v_employees_dep;
GO 

CREATE VIEW v_emp_bonus (emp_id, emp_name, emp_surname, dep_name, bonus_desc)
AS
SELECT v.emp_id, v.emp_name, v.emp_surname, v.dep_name, b.DESCRIPT
FROM v_employees_dep v, bonuses b	-- View can be used in place of another table name
WHERE v.emp_id = b.PERSONID;
GO

SELECT * from v_emp_bonus;
GO 

CREATE VIEW v_employees (emp_id, emp_depid, emp_surname, emp_name, emp_birthdate) -- This view is Updateable!
AS
SELECT EMPLOYEEID, depid, e.surname, e.givenname, e.birthdate
FROM employees e;
GO

INSERT INTO v_employees (emp_id, emp_surname, emp_name, emp_birthdate)
VALUES (36, 'Cooper', 'John', '1974-04-23');
GO

-- TO CREATE AN UPDATEABLE VIEW
-------------------------------------------
-- SELECT must pull from and reference only one table (no joins, unions)
-- SELECT must not have a group by or having clause
-- SELECT must not use DISTINCT clause
-- SELECT must not reference a non-updateable view
-- SELECT statement must not contain expressions (aggregates, computed columns, or functions)

UPDATE v_employees
SET emp_depid = 2
WHERE emp_surname = 'Cooper';

DELETE FROM v_employees
WHERE emp_surname = 'Cooper';
GO

ALTER VIEW v_employees (emp_surname, emp_name, emp_birthdate)
AS
SELECT surname, givenname, birthdate
FROM EMPLOYEES;
GO

SELECT * FROM v_employees;
