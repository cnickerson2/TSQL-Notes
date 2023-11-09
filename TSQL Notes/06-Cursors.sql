use car_transactions;

DECLARE cur_car CURSOR FOR
	SELECT car, model
	FROM Cars
	ORDER BY car;

DECLARE @v_name		VARCHAR(40),
		@v_model	VARCHAR(40);

OPEN cur_car; -- Populating the results set

FETCH NEXT FROM cur_car -- FETCH returns the row into the set
INTO @v_name, @v_model;

WHILE @@FETCH_STATUS = 0 -- The info from the latest FETCH statement
BEGIN
	IF(@v_name IN ('Ferrari', 'BMW', 'Maserati'))
		print 'Very good car for me: ' +@v_name + ' ' + @v_model;
	ELSE
		print 'Good car for me: ' +@v_name + ' ' + @v_model;

	FETCH NEXT FROM cur_car
	INTO @v_name, @v_model;
END;

CLOSE cur_car;	-- Release the cursor results
DEALLOCATE cur_car;	-- Release the resources used by the cursor