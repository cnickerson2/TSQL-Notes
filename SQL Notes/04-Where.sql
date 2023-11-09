-- WHERE clause
-------------------------------------------------------------------------------------
SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME = 'Brown'; -- WHERE will extract data that only fulfills the specified criteria

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME = 'Brown'
ORDER BY BIRTHDATE; -- ORDER BY is optional, but must be the last clause in the SELECT statement

SELECT *
FROM EMPLOYEES
WHERE BIRTHDATE >= '1975-01-01'; -- You can use comparison operators on the WHERE clause
-- COMPARISON OPERATORS
------------------------------------
--	=		Equal
--	<>		Not Equal
--	>		Greater Than
--	>=		Greater Than or Equal To
--	<		Less Than
--	<=		Less Than or Equal To

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE BIRTHDATE <> '1976-04-03'
ORDER BY BIRTHDATE;

SELECT *
FROM SALARIES
WHERE GROSS < 777; -- Remember Numbers don't use single quotes

SELECT *
FROM EMPLOYEES
WHERE BIRTHDATE IS NULL;	-- IS NULL and IS NOT NULL can be used to test against null values
							-- REMINDER: NULL and 0 are not equal
SELECT *
FROM EMPLOYEES
WHERE BIRTHDATE IS NOT NULL;

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE BIRTHDATE BETWEEN '1970-01-01' AND '1975-12-31';			-- The BETWEEN keyword allows you to specify between a range
																-- NOTE: both values are included within the search
SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE BIRTHDATE >= '1970-01-01' AND BIRTHDATE <='1975-12-31';	-- Logical Operators can also be used to evaluate multiple criteria
-- LOGICAL OPERATORS
------------------------------------
-- ALL			TRUE if all of the subquery values meet the condition	
-- AND			TRUE if all the conditions separated by AND is TRUE	
-- ANY			TRUE if any of the subquery values meet the condition	
-- BETWEEN		TRUE if the operand is within the range of comparisons	
-- EXISTS		TRUE if the subquery returns one or more records	
-- IN			TRUE if the operand is equal to one of a list of expressions	
-- LIKE			TRUE if the operand matches a pattern	
-- NOT			Displays a record if the condition(s) is NOT TRUE	
-- OR			TRUE if any of the conditions separated by OR is TRUE	
-- SOME			TRUE if any of the subquery values meet the condition

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE BIRTHDATE <= '1970-01-01' OR BIRTHDATE >='1975-12-31';

SELECT *
FROM EMPLOYEES
WHERE GIVENNAME IN ('William', 'Emma', 'Jacob');

SELECT *
FROM EMPLOYEES
WHERE GIVENNAME IN ('WILLIAM', 'EMMA', 'JACOB'); -- SQL Server is case-insensitive, but some RDBMS are case-sensitive

SELECT *
FROM EMPLOYEES
WHERE GIVENNAME = 'William' OR GIVENNAME = 'Emma' OR GIVENNAME = 'Jacob'; -- IN can be replaced with multiple OR operators

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME LIKE '%s%';	-- Wildcard characters allow us to search for specific items within strings
							-- No wildcard characters means the string must be an exact match
-- WILDCARD CHARACTERS
------------------------------------
-- %	Represents zero or more characters
-- _	Represents a single character
-- []	Represents any single character within the brackets (not supported in PostgreSQL or MySQL)
-- ^	Represents any character not in the brackets (not supported in PostgreSQL or MySQL)
-- -	Represents any single character within the specified range (not supported in PostgreSQL or MySQL)
-- {}	Represents any escaped character (only in Oracle databases)

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME LIKE '%s%mit%';

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME LIKE 'Smit_';

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME LIKE 'Smith_'; -- NO results because _ requires atleast a single character

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE SURNAME NOT LIKE '%s%';

SELECT PERSONID, GROSS, GROSS*1.3 AS NEW_SALARY, GROSS * 0.3 AS INCREASE
FROM SALARIES
WHERE GROSS * 1.3 > 1000; -- Can apply arthimatic to evaluate expressions
-- ARITHMETIC OPERATORS
------------------------------------
-- +	Add	
-- -	Subtract	
-- *	Multiply	
-- /	Divide	
-- %	Modulo

SELECT GIVENNAME, SURNAME, BIRTHDATE
FROM EMPLOYEES
WHERE (SURNAME IN ('Smith','Johnson')) AND ((BIRTHDATE IN ('1976-01-12', '1979-05-21')) OR BIRTHDATE IS NULL) -- Order of Operator applies, so use paranthesis
ORDER BY BIRTHDATE DESC;