-- What are Transactions?

IF OBJECT_ID('T1', 'U') IS NOT NULL
	DROP TABLE T1;
IF OBJECT_ID('T2', 'U') IS NOT NULL
	DROP TABLE T2;
GO

CREATE TABLE T1
(
	keycol	INT	NOT NULL	PRIMARY KEY,
	col1	INT	NOT NULL,
	col2	VARCHAR(50) NOT NULL
);

INSERT INTO T1(keycol, col1, col2) VALUES
	(1,101,'A'),
	(2,102,'B'),
	(3,103,'C');


CREATE TABLE T2
(
	keycol	INT	NOT NULL	PRIMARY KEY,
	col1	INT	NOT NULL,
	col2	VARCHAR(50) NOT NULL
);

INSERT INTO T2(keycol, col1, col2) VALUES
	(1,201,'X'),
	(2,202,'Y'),
	(3,203,'Z');
GO

BEGIN TRAN -- Very Basic Transaction
	INSERT INTO T1(keycol, col1, col2) VALUES (4, 101, 'C')
	INSERT INTO T2(keycol, col1, col2) VALUES (4, 201, 'X');
COMMIT TRAN
GO

-- LOCKING AND BLOCKING
--BEGIN TRAN
--	UPDATE T1 SET col2 = 'BB' WHERE keycol = 2;

-- ROLLBACK TRAN --(Uh Oh! We forgot to Rollback Tran!)

-- If you don't commit a transaction, it will stay locked. To view information about locks...
SELECT	request_session_id spid,
		resource_type restype,
		resource_database_id dbid,
		resource_description res,
		resource_associated_entity_id resid,
		request_mode mode,
		request_status status
FROM sys.dm_tran_locks;

-- Obtain Information about the connections involved in the conflict
SELECT * FROM sys.dm_exec_connections 
WHERE session_id IN (53)

-- Obtain Information about the sessions involved in the conflict
SELECT * FROM sys.dm_exec_sessions 
WHERE session_id IN (53)

-- Obtain Information about the blocked requests
SELECT * FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;

-- Determine which function is blocking the request
SELECT session_id, text
FROM sys.dm_exec_connections
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST
WHERE session_id IN (53);

-- ISOLATION LEVELS
-- (4 Levels)
-- READ UNCOMMITTED ISOLATION LEVEL
/*
- Not Locked
- Can cause conflicts
*/
-- READ COMMITTED ISOLATION LEVEL
/*
- Lock when Read starts and Unlocks afterwards automatically
- No dirty reads (will lock out other read attempts)
- Does not prevent other concurrency-related problems
*/
-- REPEATABLE READ ISOLATION LEVEL
/*
- Lock when Read starts
- Unlocks only upon termination of lock
- No dirty reads (will lock out other read attempts)
- Can alter data in between reads if in same transaction
*/
-- SERIALIZABLE ISOLATION LEVEL
/*
- Similar to Repeatable Read locks
- Plus acquire key-range locks (placed on Indexes) based on query filters
- Locks out things that don't yet exist on all data in queries 
- Preventation from phantom adds to be added to the data
*/

-- SAVEPOINTS
IF OBJECT_ID('dbo.Sequence', 'U') IS NOT NULL
	DROP TABLE dbo.Sequence;

CREATE TABLE Sequence (val INT IDENTITY);

IF OBJECT_ID('GetSequence', 'P') IS NOT NULL
	DROP PROC GetSequence;
GO
CREATE PROC GetSequence  @val AS INT OUTPUT
AS
BEGIN TRAN
	SAVE TRAN S1;

	INSERT INTO dbo.Sequence DEFAULT VALUES;
	SET @val = SCOPE_IDENTITY()

	ROLLBACK TRAN S1;
COMMIT TRAN
GO

DECLARE @key AS INT;
EXEC GetSequence @val = @key OUTPUT;
SELECT @key;

-- DEADLOCKS
-- When two locks interlock, it requires system override to fix