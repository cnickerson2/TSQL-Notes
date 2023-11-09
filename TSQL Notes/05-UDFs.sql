IF OBJECT_ID('fn_get_car_name') IS NOT NULL
	DROP FUNCTION fn_get_car_name;
GO

CREATE FUNCTION fn_get_car_name (@p_model VARCHAR(40)) RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @p_result VARCHAR(100)

	SET @p_result =
	(
		SELECT car+ ' ' +model
		FROM Cars
		WHERE model = @p_model
	);

	RETURN @p_result;
END;
GO


SELECT dbo.fn_get_car_name ('A-Class');
SELECT dbo.fn_get_car_name ('Navigator');
SELECT dbo.fn_get_car_name (model) FROM Cars WITH (NOLOCK);
EXEC fn_get_car_name @p_model='Navigator';

BEGIN
	DECLARE @Name varchar(100);
	SET @Name = dbo.fn_get_car_name('Navigator');
	print @name;
END;


IF OBJECT_ID('T1') IS NOT NULL
	DROP TABLE T1;
GO

CREATE TABLE T1
(
	id INT NOT NULL CONSTRAINT PK_ID PRIMARY KEY,
	col VARCHAR(5)
);

IF OBJECT_ID('fn_T1_getid') IS NOT NULL
	DROP FUNCTION fn_T1_getid;
GO

CREATE FUNCTION fn_T1_getid() RETURNS INT -- Create a function that returns the minimum missing ID in T1
AS
BEGIN
	RETURN
		CASE
			WHEN NOT EXISTS (SELECT * FROM T1 WHERE ID = 1) THEN 1
			ELSE	
			(
			SELECT MIN(id) + 1
			FROM T1 AS A WITH (NOLOCK)
			WHERE NOT EXISTS
				(
				SELECT *
				FROM T1 AS B WITH (NOLOCK)
				WHERE B.id = A.id + 1
				)							
			)				
		END;
END;
GO

ALTER TABLE T1
ADD DEFAULT (dbo.fn_T1_getID()) FOR Id; -- Add a default constraint on ID that will set it as the minimum non-existant ID

INSERT INTO T1(col) VALUES ('A');
INSERT INTO T1(col) VALUES ('B');
INSERT INTO T1(col) VALUES ('C');
DELETE FROM T1 WHERE id =2;
INSERT INTO T1(col) VALUES ('D');

SELECT * FROM T1 with (NOLOCK);

-- UNIQUE AND PRIMARY KEY CONSTRAINTS
IF OBJECT_ID('fn_add') IS NOT NULL
	DROP FUNCTION fn_add;
GO

CREATE FUNCTION fn_add(@p_id INT) RETURNS INT
AS
BEGIN
	RETURN @p_id + 1;
END;
GO

ALTER TABLE T1
ADD col2 AS dbo.fn_add(id) CONSTRAINT UK_T1_col2 UNIQUE; -- FAILS! Because the function was not schemabound
GO

ALTER FUNCTION dbo.fn_add(@p_id INT) RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	RETURN @p_id+1;
END;
GO

ALTER TABLE T1
ADD col2 AS dbo.fn_add(id) CONSTRAINT UK_T1_col2 UNIQUE; -- SUCCESS! Because the function is now schemabound
GO

ALTER TABLE T1
DROP CONSTRAINT PK_ID;
GO

ALTER TABLE T1
ADD col3 AS dbo.fn_add(id) CONSTRAINT PK_ID PRIMARY KEY; -- FAILS! Because not labelled as PERSISTED and NOT NULL
GO

ALTER TABLE T1
ADD col3 AS dbo.fn_add(id) PERSISTED NOT NULL CONSTRAINT PK_ID PRIMARY KEY; -- SUCCESS!
GO

-- INLINE UDFs (Parameterized Views)
IF OBJECT_ID('fn_get_cars') IS NOT NULL
	DROP FUNCTION fn_get_cars;
GO

CREATE FUNCTION fn_get_cars(@p_car_name VARCHAR(40)) RETURNS TABLE
AS
RETURN	SELECT Car, Model
		FROM Cars with (NOLOCK)
		WHERE Car = @p_car_name;
GO

SELECT * FROM fn_get_cars('Ferrari');
SELECT * FROM fn_get_cars('BMW');

-- MULTISTATEMENT TABLE-VALUED UDF
IF OBJECT_ID('fn_get_cars2') IS NOT NULL
	DROP FUNCTION fn_get_cars2;
GO

CREATE FUNCTION fn_get_cars2(@p_car_name VARCHAR(40)) 
RETURNS @t_cars TABLE
(
	car VARCHAR(40),
	model VARCHAR(40)
)
AS
BEGIN
	INSERT INTO @t_cars
			SELECT Car, Model
			FROM Cars with (NOLOCK)
			WHERE Car = @p_car_name;
	DECLARE @p_letter VARCHAR(1);

	SET @p_letter = UPPER(SUBSTRING(@p_car_name, 2,1));
	
	INSERT INTO @t_cars
			SELECT Car, Model
			FROM Cars with (NOLOCK)
			WHERE UPPER(SUBSTRING(Car,1,1)) = @p_letter;
	
	RETURN
END;
GO

SELECT * FROM fn_get_cars2('Ferrari');
SELECT * FROM fn_get_cars2('BMW');

-- PER ROW UDFs
SELECT RAND(), GETDATE(), NEWID(), * FROM Cars WITH (NOLOCK); -- Only NEWID() is created Per-Row.

IF OBJECT_ID('fn_rand') IS NOT NULL
	DROP FUNCTION fn_rand;
GO

CREATE FUNCTION fn_rand() RETURNS FLOAT
AS
BEGIN
	RETURN RAND();
END;
GO	-- FAILS! As you cannot create a Function that has "side-effects"


IF OBJECT_ID('v_rand') IS NOT NULL
	DROP VIEW v_rand;
GO

CREATE VIEW v_rand
AS
SELECT RAND() AS R;
GO

CREATE FUNCTION fn_rand() RETURNS FLOAT
AS
BEGIN
	RETURN (SELECT R FROM v_rand);
END;
GO -- SUCCESS! Backdoor way of getting around the Per-Row is to invoke a View with Per-Row functionality

SELECT *, RAND() FROM Cars with (NOLOCK); -- All RANDs are the same
SELECT *, dbo.fn_rand() FROM Cars with (NOLOCK); -- All RANDs are different!

