USE [car_transactions]
GO

IF OBJECT_ID('v_cars_country') IS NOT NULL
	DROP VIEW v_cars_country;
GO

CREATE VIEW v_cars_country AS
SELECT	ca.Car,
		ca.Model,
		ct.Country,
		tr.SalesDate,
		tr.Price,
		tr.Amount,
		tr.Value
FROM	Cars ca							INNER JOIN
		Company co						ON ca.CompanyId = co.CompanyID INNER JOIN
		Cities ci						ON co.CityId = ci.CityId INNER JOIN 
		Countries ct					ON ci.CountryId = ct.CountryId INNER JOIN
		Transactions_facts_table tr		ON ca.CarID = tr.CarId;
GO

ALTER VIEW v_cars_country AS
SELECT TOP 100 PERCENT
		ca.Car,
		ca.Model,
		ct.Country,
		tr.SalesDate,
		tr.Price,
		tr.Amount,
		tr.Value
FROM	Cars ca							INNER JOIN
		Company co						ON ca.CompanyId = co.CompanyID INNER JOIN
		Cities ci						ON co.CityId = ci.CityId INNER JOIN 
		Countries ct					ON ci.CountryId = ct.CountryId INNER JOIN
		Transactions_facts_table tr		ON ca.CarID = tr.CarId
ORDER BY ca.Car ASC; -- Have to use TOP in order for ORDER BY to work


sp_helptext v_cars_country; -- View the definition of the object
GO

ALTER VIEW v_cars_country	WITH ENCRYPTION, SCHEMABINDING	-- ENCRYPTION will obfuscate your data, but not to a high enough degree to protected delicate data
AS															-- SCHEMABINDING will lock the underlying columns to prevent it from being altered or dropped
SELECT	ca.Car,												-- NOTE: In order to Schemabind, you must use the full qualified name of the objects (dbo.table_name) and cannot use * to select all rows
		ca.Model,
		ct.Country,
		tr.SalesDate,
		tr.Price,
		tr.Amount,
		tr.Value
FROM	dbo.Cars ca							INNER JOIN
		dbo.Company co						ON ca.CompanyId = co.CompanyID INNER JOIN
		dbo.Cities ci						ON co.CityId = ci.CityId INNER JOIN 
		dbo.Countries ct					ON ci.CountryId = ct.CountryId INNER JOIN
		dbo.Transactions_facts_table tr		ON ca.CarID = tr.CarId;
GO

INSERT INTO dbo.Cities VALUES (1, 'Berlin');

DELETE FROM dbo.Cities WHERE City = 'Berlin';

IF OBJECT_ID('v_cities') IS NOT NULL
	DROP VIEW v_cities;
GO

CREATE VIEW v_cities
AS
SELECT * FROM dbo.Cities
WHERE city > 'C';
GO

SELECT * FROM v_cities;

INSERT INTO v_cities VALUES (1, 'Berlin');

SELECT * FROM v_cities;

DELETE FROM v_cities WHERE City = 'Berlin';
DELETE FROM dbo.Cities WHERE City = 'Berlin';
GO

ALTER VIEW v_cities
AS
SELECT * FROM dbo.Cities
WHERE city > 'C'
WITH CHECK OPTION;
GO

INSERT INTO v_cities VALUES (1, 'Berlin'); -- Fails because it does not meet the conditions of the view


IF OBJECT_ID('v_trans_info') IS NOT NULL
	DROP VIEW v_trans_info;
GO

-- Indexed View
CREATE VIEW v_trans_info WITH SCHEMABINDING -- Must be created WITH SCHEMABINDING
AS
SELECT	s.Surname,
		SUM(ISNULL(tr.Price, 0)) AS Price,
		SUM(ISNULL(tr.Amount, 0)) AS Amount,
		SUM(ISNULL(tr.Value, 0)) AS Value,
		COUNT_BIG(*) AS cnt -- If aggregation is present, you must include a COUNT_BIG(*) aggregate too
FROM	dbo.Salesmen s	INNER JOIN
		dbo.Transactions_facts_table tr ON s.SalesmanID = tr.SalesmanId
GROUP BY s.Surname;
GO

SELECT * FROM v_trans_info;

CREATE UNIQUE CLUSTERED INDEX ix_trans_info ON v_trans_info(Surname);

SELECT * FROM v_trans_info;
