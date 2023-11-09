-- PARTITIONING
/*
	Restricts the window to the rows that have the same values as the partitioning attributes
*/

SELECT orderid, custid, val,
	   SUM(val) OVER() as sumall, -- val of all rows
	   SUM(val) OVER(PARTITION BY custid) AS sumcust -- vals of the custid
FROM vw_OrderValues AS O1;

SELECT orderid, custid, val,
	   CAST(100.* val / SUM(val) OVER() AS NUMERIC(5,2)) as pctall, -- percent of val of all rows
	   CAST(100.* val / SUM(val) OVER(PARTITION BY custid) AS NUMERIC(5,2)) as pctcust -- percent of val of the custid
FROM vw_OrderValues AS O1;


-- ORDERING AND FRAMING
/*
Framing is another option that enables you to further restrict the rows in the window partition. The ordering
element plays a different role for window aggregate functions than for ranking, distribution, and offset
functions. With aggregate functions, ordering just gives meaning to the framing option. Once ordering is
defined, framing identifies two bounds in the window partition, and only the rows between those two bounds
are filtered.

	function name (<arguments>) OVER (
		[ <window partition clause> ]
		[ <window order clause> [ <window frame clause> ] ] )

The window frame clause can include three parts and takes the following form:

	<window frame units> <window frame extent> [ <window frame exclusion> ]

In the window frame units part, you indicate ROWS or RANGE. The former means that the bounds, or
endpoints, of the frame can be expressed as offsets in terms of the number of rows of difference from the
current row. The latter means that the offsets are more dynamic and expressed as a logical value difference
from the current row's (only) ordering attribute value.

Using ROWS as the window frame units part means that you indicate the frame bounds as offsets in terms of
the number of rows with respect to the current row. The standard ROWS clause supports the following
options, all of which are implemented in SQL Server 2012:

	ROWS BETWEEN UNBOUNDED PRECEDING I
	<n> PRECEDING I
	<n> FOLLOWING I
	CURRENT ROW
	AND
	UNBOUNDED FOLLOWING I
	<n> PRECEDING I
	<n> FOLLOWING I
	CURRENT ROW

These options are probably straightforward, but just in case they're not, I'll provide a brief explanation. For the
low bound of the frame, UNBOUNDED PRECEDING means there is no low boundary point; <n> preceding
and <n> following specifies a number of rows before and after the current one, respectively; and CURRENT
ROW, obviously, means that the starting row is the current row.
As for the high bound of the frame, you can see the options are quite similar, except that if you don't want a
high boundary point, you indicate UNBOUNDED FOLLOWING, naturally.
*/

SELECT empid, ordermonth, qty
	   SUM(qty) OVER(PARTITION BY empid
					 ORDER BY ordermonth
					 ROWS BETWEEN UNBOUNDED PRECEDING
					 AND CURRENT ROW) AS runqty
FROM vw_EmpOrders;

SELECT empid, ordermonth, qty
	   SUM(qty) OVER(PARTITION BY empid
					 ORDER BY ordermonth
					 ROWS UNBOUNDED PRECEDING) AS runqty -- Same thing as before
FROM vw_EmpOrders;

SELECT empid, ordermonth, 
	   MAX(qty) OVER(PARTITION BY empid
					 ORDER BY ordermonth
					 ROWS BETWEEN 1 PRECEDING
					 AND 1 PRECEDING) AS prvqty, -- Just the previous row in the partition
	   qty as curqty,
	   MAX(qty) OVER(PARTITION BY empid
					 ORDER BY ordermonth
					 ROWS BETWEEN 1 FOLLOWING
					 AND 1 FOLLOWING) AS nxtqty, -- Just the next row int he partition
	   AVG(qty) OVER(PARTITION BY empid
					 ORDER BY ordermonth
					 ROWS BETWEEN 1 PRECEDING
					 AND 1 FOLLOWING) AS nxtqty, -- The average of (up to) the three!
FROM vw_EmpOrders;

IF OBJECT_ID('dbo.T1') IS NOT NULL 
	DROP TABLE dbo.T1
GO

CREATE TABLE dbo.T1
(
	keycol INT NOT NULL CONSTRAINT PK_T1 PRIMARY KEY,
	col1 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.T1 VALUES
(2, 'A'),(3,'A'),
(5,'B'),(7,'B'),(11,'B'),
(13,'C'), (17,'C'), (19,'C'),(23,'C');

SELECT keycol, col1,
	   COUNT(*) OVER(ORDER BY col1
					 ROWS BETWEEN UNBOUNDED PRECEDING
					 AND CURRENT ROW) AS cnt
FROM T1;

SELECT keycol, col1,
	   COUNT(*) OVER(ORDER BY col1, keycol -- Make it deterministic (only one way this will ever show)
					 ROWS BETWEEN UNBOUNDED PRECEDING
					 AND CURRENT ROW) AS cnt
FROM T1;

-- RANGE WINDOW FRAME EXTENT OPTION
SELECT empid, ordermonth, qty
	   SUM(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth
					  RANGE BETWEEN UNBOUNDED PRECEDING
							AND		CURRENT ROW) AS runqty
FROM vw_EmpOrders

SELECT empid, ordermonth, qty
	   SUM(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth
					  RANGE UNBOUNDED PRECEDING) AS runqty -- Same thing
FROM vw_EmpOrders;

SELECT empid, ordermonth, qty
	   SUM(qty) OVER (PARTITION BY empid
					  ORDER BY ordermonth) AS runqty -- Same thing. RANGE UNBOUNDED PRECEDING is the default
FROM vw_EmpOrders;

SELECT keycol, col1,
	   COUNT(*) OVER(ORDER BY col1
					 ROWS BETWEEN UNBOUNDED PRECEDING
					 AND CURRENT ROW) AS cnt -- Ignores peers
FROM T1;

SELECT keycol, col1,
	   COUNT(*) OVER(ORDER BY col1
					 RANGE BETWEEN UNBOUNDED PRECEDING
					 AND CURRENT ROW) AS cnt -- Includes peers. Means current ordering value
FROM T1;

--DISTINCT AGGREGATES
SELECT empid, orderdate,orderid, val,
	   COUNT(DISTINCT custid) OVER(PARTITION BY empid				-- Cannot use DISTINCT with the OVER clause
								   ORDER BY orderdate) AS numcusts
FROM vw_OrderValues;

SELECT empid, orderdate,orderid, val,
	CASE
	   WHEN ROW_NUMBER() OVER(PARTITION BY empid, custid
							  ORDER BY orderdate) = 1
	   THEN custid
	END AS distinct_custid; -- This gets around the DISTINCT restriction by using ROW_NUMBER to check for the first instance of each
FROM vw_OrderValues;

WITH C AS
(
	SELECT empid, orderdate, orderid, custid, val,
		CASE
			WHEN ROW_NUMBER() OVER (PARTITION BY empid, custid
									ORDER BY orderdate) = 1
			THEN custid
		END AS distinct_custid
	FROM vw_OrderValues
)
SELECT empid, orderdate, orderid, val
	COUNT(distinct_custid) OVER (PARTITION BY empid ORDER BY orderdate) AS numcusts
FROM C;

-- NESTED AGGREGATES
SELECT	empid,
		SUM(val) AS emptotal,
		SUM(val) / SUM(SUM(VAL)) OVER() * 100. AS pct
FROM vw_OrderValues
GROUP BY empid;

--Same as teh following but over total amount of rows
SELECT empid,
	SUM(val) AS emptotal
FROM vw_OrderValues
GROUP BY empid;

-- So we can use CTEs to avoid the complexity and make it more readable
WITH C AS
(
	SELECT empid,
		SUM(val) AS emptotal
	FROM vw_OrderValues
	GROUP BY empid;
)
SELECT empid, emptotal, 
	emptotal / SUM(emptotal) OVER() * 100. AS pct
FROM C;