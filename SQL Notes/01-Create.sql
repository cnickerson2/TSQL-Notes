-- CREATE DATABASE/TABLE
-------------------------------------------------------------------------------------

CREATE DATABASE tutorial;	-- CREATE DATABASE creates a database with a given name
GO							-- GO keyword batches commands together to ensure they are completed before the next steps do

USE	tutorial;				-- USE keyword specifies which database to use
GO

CREATE TABLE DEPARTMENTS	-- CREATE TABLE will make a table within the current database (ensure you have a USE to specify where to make it)
(
--	COL_NAME	DATA_TYPE		CONSTRAINTS
	DEPID		INT				PRIMARY KEY,	-- PRIMARY KEY constraint signifies which row should be a unique, non-clustered index to find this object easier
	[NAME]		VARCHAR(50)						-- Wrap reserved keywords in []
);												-- Always end SQL statements with a delimiter (;)

-- COMMON DATA TYPES
--------------------------------
-- VARCHAR(#)	- variable-length string. Max size in paranthesis

-- CHAR(#)		- fixed-length string. Size in paranthesis

-- INT			- integer value

-- DATETIME		- Date value
-- DATE

-- NUMBER(#,#)	- Number with Max of first # in paranthesis, and significant digits of the second #. Watch for floating-point imprecision
-- FLOAT(#,#)	- Consider using INT and dividing by the 10^n instead.


CREATE TABLE EMPLOYEES
(
	EMPLOYEEID	INT				PRIMARY KEY,
	DEPID		INT				FOREIGN KEY REFERENCES DEPARTMENTS (DEPID),		-- FOREIGN KEY points to a VALID primary key on another table
	SURNAME		VARCHAR(40),
	GIVENNAME	VARCHAR(30),
	BIRTHDATE	DATETIME,
	HEIGHT		FLOAT,
	BOSSID		INT
);

CREATE TABLE SALARIES
(
	SALARYID	INT				PRIMARY KEY,
	PERSONID	INT				FOREIGN KEY REFERENCES EMPLOYEES(EMPLOYEEID),
	GROSS		MONEY,
	SALARYDATE	DATETIME
);

CREATE TABLE BONUSES
(
	BONUSID		INT				PRIMARY KEY,
	PERSONID	INT				FOREIGN KEY REFERENCES EMPLOYEES(EMPLOYEEID),
	DESCRIPT	VARCHAR(100)
);

CREATE TABLE [PERCENT]	-- While valid, it's VERY POOR practice to use keywords, spaces, numbers or symbols (except _ or -)
(
	[BIRTH DATE] DATETIME,
	[50]		INT,
	[COL*]		INT
);

DROP TABLE [PERCENT];
GO