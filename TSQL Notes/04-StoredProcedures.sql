use car_transactions;

IF OBJECT_ID('show_cars') is NOT NULL
	DROP PROCEDURE show_cars;
GO

CREATE PROCEDURE show_cars @p_salesman VARCHAR(30)
AS
BEGIN
	SELECT	c.car,
			c.model,
			s.surname,
			s.name,
			t.price,
			t.amount
	FROM	dbo.Transactions_facts_table t WITH (NOLOCK) INNER JOIN
			dbo.Cars c WITH (NOLOCK) ON t.CarId = c.CarId INNER JOIN
			dbo.Salesmen s WITH (NOLOCK) ON t.SalesmanId = s.SalesmanID
	WHERE	s.Surname = @p_salesman;
END;
GO

EXECUTE show_cars @p_salesman = 'Cronenberg';
EXECUTE show_cars 'Cronenberg';
EXEC show_cars 'Johnson';
show_cars 'Kolarov';
GO

IF OBJECT_ID('sp_show_object_info') is NOT NULL
	DROP PROCEDURE sp_show_object_info;
GO

CREATE PROCEDURE sp_show_object_info @p_object_type VARCHAR(30) = 'BASE TABLE'
AS
BEGIN
	SELECT	*
	FROM	INFORMATION_SCHEMA.TABLES WITH (NOLOCK)
	WHERE	table_type = @p_object_type;
END;
GO

EXEC sp_show_object_info;
EXEC sp_show_object_info 'VIEW';

EXEC sp_MS_marksystemobject 'dbo.sp_show_object_info';
GO

IF OBJECT_ID('show_info') is NOT NULL
	DROP PROCEDURE show_info;
GO

CREATE PROCEDURE show_info @p_salesman VARCHAR(30), @p_result VARCHAR(30) OUTPUT
AS
BEGIN
	DECLARE
		@v_count INT,
		@v_result VARCHAR(30);

	SELECT	@v_count = COUNT(*)
	FROM	dbo.Transactions_facts_table t WITH (NOLOCK) INNER JOIN
			dbo.Cars c WITH (NOLOCK) ON t.CarId = c.CarId INNER JOIN
			dbo.Salesmen s WITH (NOLOCK) ON t.SalesmanId = s.SalesmanID
	WHERE	s.Surname = @p_salesman;

	IF @v_count >= 3
		SET @p_result = 'Good Result';
	ELSE
		SET @p_result = 'Bad Result';
END;
GO

BEGIN
	DECLARE @vv_result VARCHAR(30);

	EXEC show_info 'Cronenberg', @vv_result OUTPUT;
	print 'Cronenberg: ' + @vv_result;

	EXEC show_info 'Smith', @vv_result OUTPUT;
	print 'Smith: ' + @vv_result;
END