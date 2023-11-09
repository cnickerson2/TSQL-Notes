use car_transactions;

-- TRY/CATCH Error Handling
IF OBJECT_ID('Employees') IS NOT NULL
	DROP TABLE Employees
GO

CREATE TABLE Employees
(
	empid INT NOT NULL,
	empname VARCHAR(25) NOT NULL,
	mgrid INT NULL,
	CONSTRAINT PK_Employees PRIMARY KEY(empid),
	CONSTRAINT CHK_Employees_empid CHECK(empid > 0),
	CONSTRAINT FK_Employees_Employees FOREIGN KEY (mgrid) REFERENCES Employees(empid)
);

BEGIN TRY
	INSERT INTO Employees(empid, empname, mgrid)
	VALUES (1, 'Emp1', NULL);

	PRINT 'INSERT succeeded!';
END TRY
BEGIN CATCH
	PRINT 'INSERT failed.';
END CATCH

-- ERROR HANDLING FUNCTIONS
/*
--ERROR_NUMBER()
--ERROR_MESSAGE()
--ERROR_SEVERITY()
--ERROR_STATE()
--ERROR_LINE()
--ERROR_PROCEDURE()
*/

print 'Before Try/Catch Block.';
BEGIN TRY
	print 'Entering Try block';
	INSERT INTO Employees(empid, empname, mgrid)
	VALUES (2, 'Emp2', 1);

	PRINT 'After Insert';
	Print 'Exiting Try Block';
END TRY
BEGIN CATCH
	PRINT 'Entering Catch block';

	IF ERROR_NUMBER() = 2627
	BEGIN
		PRINT ' Handling PK violation...';
	END
	ELSE IF ERROR_NUMBER() = 547
	BEGIN
		PRINT ' Handling CHECK/FK constraint violation...'
	END
	ELSE IF ERROR_NUMBER() = 515
	BEGIN
		PRINT ' Handling NULL violation...'
	END
	ELSE IF ERROR_NUMBER() = 245
	BEGIN
		PRINT ' Handling conversion error...'
	END
	ELSE 
	BEGIN
		PRINT ' Handling unknown error...'
	END
	
	print ' ERROR NUMBER : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
	print ' ERROR MESSAGE : ' + ERROR_MESSAGE();
	print ' ERROR SEVERITY : ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
	print ' ERROR STATE : ' + CAST(ERROR_STATE() AS VARCHAR(10));
	print ' ERROR LINE : ' + CAST(ERROR_LINE() AS VARCHAR(10));
	print ' ERROR PROCEDURE : ' + ISNULL(ERROR_PROCEDURE(),'Not within a procedure');
	print ' Exiting Catch Block';
END CATCH

print 'After TRY/CATCH Block.';

-- USING XACT_STATE
SET XACT_ABORT ON; -- Sets XACT_STATE() to -1

BEGIN TRY
	BEGIN TRAN
		INSERT INTO Employees
		VALUES (3, 'Emp3', 1);

	COMMIT TRAN

	PRINT 'Code Completed Successfully';
END TRY
BEGIN CATCH
	PRINT 'Error: '+CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' found.';
	IF (XACT_STATE()) = -1
	BEGIN
		PRINT 'Transaction is open but uncommittable.';

		ROLLBACK TRAN; -- can only rollback;
	END
	ELSE IF (XACT_STATE() = 1)
	BEGIN
		PRINT 'Transaction is open and committable';

		COMMIT TRAN; -- or rollback
	END
	ELSE
	BEGIN
		PRINT 'No Open Transactions';
	END
END CATCH

SET XACT_ABORT OFF;