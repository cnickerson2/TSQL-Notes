BEGIN	
	print 'first lesson';
END; -- Basic Anonymous Block. Begin starts exception block and end ends it


DECLARE
	@v_count INT;
	-- here we are declaring variables. Must start with a @. And we must declare its type
BEGIN
	SET @v_count = 5;
	print @v_count;
	/*
		This is an executable section
	*/
END;

DECLARE
	@v_text VARCHAR(6) = 'world';
BEGIN
	print 'Hello ' + @v_text; -- Concatination
END;

DECLARE
	@v_num	NUMERIC(10,2)	=	100.56,
	@v_date	DATETIME		=	'20120921';
BEGIN
	print	'NUMERIC VALUE: ' + CAST(@v_num AS VARCHAR);
	print	'NUMERIC VALUE: ' + CONVERT(VARCHAR, @v_num);
	print	'DATE VALUE: ' + CAST(@v_date AS VARCHAR);
	print	'DATE VALUE: ' + CONVERT(VARCHAR, @v_date, 121);
	print	'DATE VALUE: ' + CONVERT(VARCHAR, @v_date, 112);
END;

DECLARE
	@v_count_BMW INT,
	@v_count_Ferrari INT;
BEGIN
	SET @v_count_BMW = (SELECT COUNT(*) FROM cars WHERE car = 'BMU');
	print 'BMW Count: ' + CAST(@v_count_BMW AS VARCHAR);
	SET @v_count_Ferrari = (SELECT COUNT(*) FROM cars WHERE car = 'Ferrari');
	print 'Ferrari Count: ' + CAST(@v_count_Ferrari AS VARCHAR);
END

DECLARE
	@v_count INT = 5;
BEGIN
	IF @v_count = 5
		print '@v_count value is equal to 5'
	ELSE
		print '@v_count value is not equal to 5'
END;

DECLARE
	@v_count INT;
BEGIN
	SELECT
	CASE
		WHEN car = 'BMU' THEN 'BMW'
		WHEN car = 'Ferrari' THEN 'Ferrari'
		ELSE 'Other'
	END AS Info, 
	*
	FROM Cars;
END;

DECLARE
	@v_i INT = 1;
BEGIN
	WHILE (@v_i < 10)
	BEGIN
		print '@v_i value = ' + CAST(@v_i AS VARCHAR);
		SET @v_i = @v_i + 1;
	END;
END;

DECLARE
	@v_i INT = 1;
BEGIN
	WHILE (@v_i < 100)
	BEGIN
		SET @v_i = @v_i + ROUND(RAND() * 10, 2) + 1;
		print '@v_i value = ' + CAST(@v_i AS VARCHAR);
		IF @v_i > 105
			BREAK;
		ELSE
			CONTINUE;
	END;
END;