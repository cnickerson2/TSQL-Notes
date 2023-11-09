-- Window = The context the function is operating in
-- OVER = clause that specifies the exact set of rows the current row being evaluated relates to, relevant ordering specification, and other elements

SELECT	orderid, orderdate, val,
		RANK() OVER(ORDER BY val DESC) AS rnk -- RANK calculates the rank of the current row with respect to a specified set of rows and a sort order
FROM	dbo.vw_OrderValues
ORDER BY rnk;

-- OVER defines a window for the function with respect to the CURRENT row. Basically it's independent of other rows


-- WINDOWS FUNCTIONS EXPLAINED
SELECT	orderid, orderdate, val,
		RANK() OVER(ORDER BY val DESC) AS rnk 
FROM	dbo.vw_OrderValues;
-- RANK
/*
	arrange the rows sorted by val
	iterate through the rows
	foreach row
		if the current row is the first row in the partition emit 1
		else if val is equal to the previous val emit previous rank
		else emit count of rows so far
*/

-- DRAWBACKS OF ALTERNATIVES TO WINDOWS FUNCTIONS
/*
	Alternative methods to Window Functions are:
	- Grouped Queries
	- Subqueries
	- Others
*/

-- calculate the percentage of the current order value of the customer's total as well as the difference from the average
-- Grouped Queries...
WITH Aggregates AS
(
	SELECT custid, SUM(val) AS sumval,	AVG(val) AS avgval
	FROM dbo.vw_OrderValues
	GROUP BY custid
)
SELECT O.orderid, O.custid, O. val,
	CAST(100. * O.val / A.sumval AS NUMERIC(5,	2)) AS pctcust,
	O. val - A.avgval AS diffcust
FROM dbo.vw_OrderValues AS O
	JOIN Aggregates AS A
	ON O.custid = A.custid;

WITH CustAggregates AS
(
	SELECT custid, SUM(val) AS sumval,	AVG(val) AS avgval
	FROM dbo.vw Ordervalues
	GROUP BY custid
),
GrandAggregates AS
(
	SELECT SUM(val) AS sumval, AVG(val) AS avgval
	FROM dbo. Ordervalues
)
SELECT O.orderid, O.custid, O.val,
	CAST(100. * O.val / CA. sumval AS NUMERIC(5,	2)) AS pctcust,
	O. val - CA. avgval AS diffcust,
	CAST(100. * O.val / GA.sumval AS NUMERIC(5,	2)) AS pctall,
	O. val - GA. avgval AS diffall
FROM dbo.vw Ordervalues AS O
	JOIN CustAggregates AS CA
	ON O.custid = CA. custid
	CROSS JOIN GrandAggregates AS GA;

-- Subqueries (More complex, more visits per subquery added)
SELECT orderid, custid, val,
	CAST(100 . * val /
		(SELECT SUM(O2.val)
		FROM dbo.vw_Ordervalues AS O2
		WHERE O2.custid = Ol.custid) AS NUMERIC(5,	2)) AS pctcust,
	val - (	SELECT AVG(O2.val)
			FROM dbo.vw_Ordervalues AS O2
			WHERE O2.custid = Ol.custid) AS diffcust
FROM dbo.vw_Ordervalues AS O1;

SELECT orderid, custid, val,
	CAST(IØØ . * val /
		(SELECT SUM(02.va1)
		 FROM dbo.vw OrderVa1ues AS 02
		 WHERE 02. custid = Ol.custid) AS NUMERIC(5,	2)) AS pctcust,
	val-(SELECT AVG(02.va1)
		 FROM dbo.vw OrderVa1ues AS 02
		 WHERE 02.custid = 01. custid) AS diffcust,
	CAST(IØØ. * val /
		(SELECT SUM(02.va1)
		 FROM dbo. vw_OrderVa1ues AS 02) AS NUMERIC (5,	2)) AS pctall,
	val-(SELECT AVG(02.va1)
		 FROM dbo. vw_OrderVa1ues AS 02) AS diffall
FROM dbo.vw OrderVa1ues AS 01;

-- Windows Function!
SELECT orderid, custid, val
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust
FROM dbo.vw_OrderValues;

SELECT orderid, custid, val
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall -- Find percent against all? EZ PZ
	val - AVG(val) OVER() AS diffall
FROM dbo.vw_OrderValues;

SELECT orderid, custid, val
	CAST(100. * val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) AS pctcust,
	val - AVG(val) OVER(PARTITION BY custid) AS diffcust,
	CAST(100. * val / SUM(val) OVER() AS NUMERIC(5,2)) AS pctall
	val - AVG(val) OVER() AS diffall
FROM dbo.vw_OrderValues
WHERE orderdate BETWEEN '20070101' AND '20071231'; -- Added a filter just like that! Need to add to all subqueries if doing that way


-- GLIMPSE OF SOLUTIONS USING WINDOWS FUNCTIONS
IF OBJECT_ID('dbo.T1','U') IS NOT NULL 
	DROP TABLE	dbo.T1;
GO

CREATE TABLE dbo.T1
(
	col1 INT NOT NULL CONSTRAINT PK_T1 PRIMARY KEY
)

INSERT INTO dbo.T1(col1)
	VALUES(2) , (3) , (11) , (12), (13) , (27), (33) ,(34) ,(35),(42);
GO

SELECT Col1,
		(SELECT MIN(B.Col1)
		 FROM dbo.T1 AS B
		 WHERE B.col1 >= A.col1 
		 AND NOT EXISTS -- is this row the last in its group?
			(SELECT *
			 FROM T1 AS C
			 WHERE C.col1 = B.col1 + 1)) AS grp
FROM T1 AS A

SELECT MIN(col1) as start_range, MAX(col1) AS end_range
FROM (SELECT Col1,
		(SELECT MIN(B.Col1)
		 FROM dbo.T1 AS B
		 WHERE B.col1 >= A.col1 
		 AND NOT EXISTS -- is this row the last in its group?
			(SELECT *
			 FROM T1 AS C
			 WHERE C.col1 = B.col1 + 1)) AS grp
	  FROM T1 AS A) AS D
GROUP BY grp;

SELECT col1, ROW_NUMBER() OVER(ORDER BY col1) AS rownum
FROM T1;

SELECT col1, col1 - ROW_NUMBER() OVER(ORDER BY col1) AS diff
FROM T1;

SELECT MIN(col1) as start_range, MAX(col1) AS end_range
FROM (SELECT col1, 
			 col1 - ROW_NUMBER() OVER(ORDER BY col1) AS grp
	  FROM T1) AS D
GROUP BY grp;