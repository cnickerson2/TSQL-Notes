-- SELECT AND ORDER BY
-------------------------------------------------------------------------------------
-- SELECT column_name(s)
-- FROM table_name

SELECT * -- star (*) means all
FROM EMPLOYEES;

SELECT	EMPLOYEEID, DEPID, SURNAME, GIVENNAME, BIRTHDATE, HEIGHT, BOSSID
FROM EMPLOYEES;

SELECT GIVENNAME, SURNAME, BIRTHDATE -- Can only get certain columns
FROM EMPLOYEES;

SELECT SURNAME, GIVENNAME, BIRTHDATE -- Can be in any order you want
FROM EMPLOYEES;

SELECT GIVENNAME AS FIRSTNAME, SURNAME, BIRTHDATE -- AS allows you to specify a new column alias
FROM EMPLOYEES;

SELECT GIVENNAME FIRSTNAME, SURNAME, BIRTHDATE -- AS is not necessary
FROM EMPLOYEES;

SELECT PERSONID, GROSS, 30 AS increase_percent -- This adds an additional column with a result on the fly
FROM SALARIES;

SELECT PERSONID, GROSS, 30 AS increase_percent, GROSS * 1.3 AS new_salary
FROM SALARIES;

SELECT PERSONID, GROSS, 30 AS increase_percent, GROSS + (GROSS * 0.3) AS new_salary -- FOLLOWS PEDMAS
FROM SALARIES;

SELECT SURNAME + ' ' + GIVENNAME as FullName, BIRTHDATE -- Concatination of two strings
FROM EMPLOYEES;

SELECT GIVENNAME, SURNAME, BIRTHDATE 
FROM EMPLOYEES
ORDER BY BIRTHDATE; -- ORDER BY defaults to ASC (ascending) with NULL first

SELECT GIVENNAME, SURNAME, BIRTHDATE 
FROM EMPLOYEES
ORDER BY BIRTHDATE ASC;

SELECT GIVENNAME, SURNAME, BIRTHDATE 
FROM EMPLOYEES
ORDER BY BIRTHDATE DESC; -- Using DESC will sort it into descending order, with NULL last

SELECT GIVENNAME, SURNAME, BIRTHDATE, HEIGHT
FROM EMPLOYEES
ORDER BY SURNAME DESC, BIRTHDATE ASC; -- You can sort by multiple columns, done from left to right. Duplicates will then be sorted by second value

SELECT PERSONID, GROSS * 1.3 AS NEW_SALARY
FROM SALARIES
ORDER BY GROSS * 1.3; -- You can sort by calculated columns too

SELECT PERSONID, GROSS * 1.3 AS NEW_SALARY
FROM SALARIES
ORDER BY NEW_SALARY; -- The alias can be used to sort columns

SELECT PERSONID, GROSS * 1.3 AS NEW_SALARY
FROM SALARIES
ORDER BY 2; -- You can designate which number of column you want to sort by, starting with 1 and moving right

SELECT 8
FROM SALARIES;