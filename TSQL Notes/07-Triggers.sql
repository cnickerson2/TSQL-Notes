use car_transactions;


-- IDENTIFYING THE TYPE OF TRIGGER
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL
	DROP TABLE dbo.T1;

CREATE TABLE T1
(
	keycol	INT			NOT NULL	PRIMARY KEY,
	datacol	VARCHAR(10)	NOT NULL
);
GO

CREATE TRIGGER trg_T1_iud ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS
	DECLARE @i AS INT = 
	(
		SELECT COUNT(*)
		FROM (SELECT TOP(1) * FROM INSERTED) AS I
	);	
	
	DECLARE @d AS INT = 
	(
		SELECT COUNT(*)
		FROM (SELECT TOP(1) * FROM DELETED) AS D
	);

	IF @i = 1 AND @d = 1
		PRINT 'UPDATE of atleast one row identified';
	ELSE IF @i = 1 AND @d = 0
		PRINT 'INSERT of atleast one row identified';
	ELSE IF @i = 0 AND @d = 1
		PRINT 'DELETE of atleast one row identified';
	ELSE
		PRINT 'No rows affected';
GO

INSERT INTO T1 SELECT 1, 'A' WHERE 1 = 0;
INSERT INTO T1 SELECT 1, 'A';
UPDATE T1 SET datacol = 'AA' WHERE keycol = 1;
DELETE FROM T1 WHERE keycol = 1;

-- TRIGGERS WITH VIEWS
IF OBJECT_ID('dbo.OrderTotals', 'V') IS NOT NULL
	DROP VIEW dbo.OrderTotals;

IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL
	DROP TABLE dbo.OrderDetails;


CREATE TABLE OrderDetails
(
	oid INT NOT NULL,
	pid INT NOT NULL,
	qty INT NOT NULL,
	PRIMARY KEY (oid, pid)
);

INSERT INTO OrderDetails (oid, pid, qty) VALUES
	(10248, 1, 10),
	(10248, 2, 20),
	(10248, 3, 30),
	(10249, 1, 5),
	(10249, 2, 10),
	(10249, 3, 15),
	(10250, 1, 20),
	(10250, 2, 20),
	(10250, 3, 20);
GO

CREATE VIEW OrderTotals
AS
	SELECT oid, SUM(qty) as totalqty
	FROM OrderDetails
	GROUP BY oid;
GO

CREATE TRIGGER trg_OrderTotals_iou ON OrderTotals INSTEAD OF UPDATE
AS
	IF NOT EXISTS (SELECT * FROM INSERTED) RETURN;
	IF UPDATE(oid)
	BEGIN
		RAISERROR('Updates to the OrderID column are not allowed.', 16, 1);
		ROLLBACK TRAN;
		RETURN;
	END;

	WITH UPD_CTE AS
	(
	SELECT qty, ROUND(1.*OD.qty / D.totalqty * I.totalQty, 0) AS newqty
	FROM	OrderDetails OD INNER JOIN
			INSERTED I ON od.oid = i.oid INNER JOIN
			DELETED D ON i.oid = d.oid
	)

	UPDATE UPD_CTE
	SET qty = newqty;
GO

SELECT oid, pid, qty FROM OrderDetails;
SELECT oid, totalqty FROM OrderTotals;

UPDATE	OrderTotals
SET		totalqty = totalqty * 2;

SELECT oid, pid, qty FROM OrderDetails;
SELECT oid, totalqty FROM OrderTotals;
GO

-- DDL AND DATABASE-LEVEL TRIGGERS
CREATE TRIGGER trg_create_table_with_pk ON DATABASE FOR CREATE_TABLE
AS
	DECLARE @eventdata as XML, @objectname AS NVARCHAR(257), @msg AS NVARCHAR(500);

	SET @eventdata = EVENTDATA();
	SET @objectname = 
		+ QUOTENAME(@eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname'))
		+ N'.' + QUOTENAME(@eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'));

	IF COALESCE(
		OBJECTPROPERTY(OBJECT_ID(@objectname), 'TableHasPrimaryKey'), 0) = 0
	BEGIN
		SET @msg =N'Table ' + @objectname + ' does not contain a primary key.'
		+ CHAR(10) + N'Table creation rolled back.';
		RAISERROR(@msg, 16, 1);
		ROLLBACK;
		RETURN;
	END
GO

IF OBJECT_ID('T','U') IS NOT NULL
	DROP TABLE T;

CREATE TABLE T(Col1 INT NOT NULL);

CREATE TABLE T(Col1 INT NOT NULL PRIMARY KEY);
GO


-- DATABASE-LEVEL TRIGGERS AND XQUERY EXPRESSIONS
IF OBJECT_ID('dbo.AuditDDLEvents','U') IS NOT NULL
	DROP TABLE dbo.AuditDDLEvents;
GO

CREATE TABLE AuditDDLEvents
(
	lsn	INT	NOT NULL	IDENTITY,
	posttime	DATETIME	NOT NULL,
	eventtype sysname	NOT NULL,
	loginname sysname	NOT NULL,
	schemaname sysname	NOT NULL,
	objectname sysname	NOT NULL,
	targetobjectname sysname	NULL,
	eventdata XML NOT NULL,
	CONSTRAINT PK_AuditDDLEvents PRIMARY KEY (lsn)
);
GO

IF EXISTS(	SELECT *
			FROM sys.triggers
			WHERE parent_class = 0
			AND name = 'trg_audit_ddl_events')
		DROP TRIGGER trg_audit_ddl_events ON DATABASE;
GO

CREATE TRIGGER trg_audit_ddl_events ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS
	DECLARE @eventdata as XML;
	SET @eventdata = EVENTDATA();
	INSERT INTO AuditDDLEvents ( posttime, eventtype, loginname, schemaname, objectname, targetobjectname, eventdata)
	VALUES 
	(
		@eventdata.value('(/EVENT_INSTANCE/PostTime)[1]', 'VARCHAR(23)'),
		@eventdata.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/LoginName)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'sysname'),
		@eventdata
	);
GO

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL
	DROP TABLE dbo.T1;

CREATE TABLE T1
(
	col1	INT		NOT NULL	PRIMARY KEY
);
GO

ALTER TABLE T1 ADD col2 INT NULL;
ALTER TABLE T1 ALTER COLUMN col2 INT NOT NULL;
CREATE NONCLUSTERED INDEX idx1 on T1(col2)

SELECT * FROM AuditDDLEvents;

-- SERVER LEVEL TRIGGERS
use master;

IF OBJECT_ID('dbo.AuditDDLLogins','U') IS NOT NULL
	DROP TABLE dbo.AuditDDLLogins;
GO
CREATE TABLE AuditDDLLogins
(
	lsn	INT	NOT NULL	IDENTITY,
	posttime	DATETIME	NOT NULL,
	eventtype sysname	NOT NULL,
	loginname sysname	NOT NULL,
	objectname sysname	NOT NULL,
	logintype sysname	NOT NULL,
	eventdata XML NOT NULL,
	CONSTRAINT PK_AuditDDLLogins PRIMARY KEY (lsn)
);
GO

IF EXISTS(	SELECT *
			FROM sys.server_triggers
			WHERE name = 'trg_audit_ddl_logins')
		DROP TRIGGER trg_audit_ddl_logins ON ALL SERVER;
GO

CREATE TRIGGER trg_audit_ddl_logins ON ALL SERVER FOR DDL_LOGIN_EVENTS
AS
	DECLARE @eventdata as XML = EVENTDATA();
	INSERT INTO AuditDDLLogins ( posttime, eventtype, loginname, logintype, objectname, eventdata)
	VALUES 
	(
		@eventdata.value('(/EVENT_INSTANCE/PostTime)[1]', 'VARCHAR(23)'),
		@eventdata.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/LoginName)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/LoginType)[1]', 'sysname'),
		@eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
		@eventdata
	);
GO

CREATE LOGIN login1 WITH PASSWORD = 'asdfhasd';
CREATE LOGIN login2 WITH PASSWORD = 'Fagsadfg';
DROP LOGIN login1;

SELECT * FROM master.dbo.AuditDDLLogins;