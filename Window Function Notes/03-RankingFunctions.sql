-- ROW_NUMBER

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
FROM vw_orderValues;

SELECT orderid, val,
	ROW_NUMBER() OVER(ORDER BY orderid) AS rownum
FROM vw_orderValues
ORDER BY rownum; -- Be sure to add this if you need the rows in a certain order. SQL will presume you don't need it in order if you don't specify this. Doesn't need to be window ordering

SELECT orderid, val,
	COUNT(*) OVER(ORDER BY orderid
					ROWS UNBOUNDED PRECEDING) AS rownum
FROM vw_orderValues; -- Essentially the same as ROW_NUMBER

-- DETERMINISM
/*
	If the window ordering is unique, it is deterministic (guaranteed repeatable results)
	Else it's non-deterministic (more than one correct result)
*/

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum -- Because orderdate is not unique, this is non-deterministic
FROM vw_orderValues;

SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate, orderid DESC) AS rownum -- Because orderid is unique, this is deterministic. This gets around the issue
FROM vw_orderValues;

-- ROW_NUMBER() must have an ORDER BY clause in the OVER()
-- Can get around this by doing ROW_NUMBER() OVER(ORDER BY(SELECT NULL))

-- OVER CLAUSE AND SEQUENCES
CREATE SEQUENCE Seq1 AS INT START WITH 1 INCREMENT BY 1; -- Sequences are database objects that autogenerate numbers, often used as keys

SELECT NEXT VALUE FOR Seq1;

SELECT orderid, orderdate, val,
	NEXT VALUE FOR Seq1 AS seqval
FROM vw_OrderValues;

SELECT orderid, orderdate, val,
	NEXT VALUE FOR Seq1 OVER(ORDER BY orderdate, orderid) AS seqval
FROM vw_OrderValues;

-- NTILE
SELECT orderid, val
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	NTILE(10) OVER(ORDER BY val) AS tile		--830 rows, divided by 10 means 83 rows per tile
FROM vw_OrderValues;							-- If there is a remainder, it will add rows to the tilesets to begin with until you get all remainders dealt with (ie. 25 rows on 3 tiles will give 9 and 8 and 8)

-- RANK AND DENSE_RANK
SELECT orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS rownum, -- Produces unique value for each row in window
	RANK()		 OVER(ORDER BY orderdate DESC) AS rnk, -- Same value for all in window, gives next window the value of 1 higher than the last rownumber in the previous window
	DENSE_RANK() OVER(ORDER BY orderdate DESC) as drnk -- Same value for all in window, next window gets 1 higher than previous dense_rank
FROM vw_OrderValues;


-- DISTRIBUTION FUNCTIONS
/*
Computes the rank on a scale of 0 to 1. Done differently for each function:
	Rank Distribution - PERCENT_RANK and CUME_DIST 
*/

SELECT * from dbo.Scores;

SELECT testid, studentid, score,
	PERCENT_RANK()	OVER(PARTITION BY testid ORDER BY score) AS percentrank, -- Percentile Rank (Percent of students who have a lower score than the currently evaluated one)
	CUME_DIST()		OVER(PARTITION BY testid ORDER BY score) AS cumedist	 -- Cumulative Distribution (Percent of students who have a lower or the same score)
FROM dbo.Scores;
/*
	Inverse Distribution - PERCENTILE_CONT and PERCENTILE_DISC
*/
DECLARE @pct as FLOAT = 0.5;

SELECT testid, score,
	PERCENTILE_DISC(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testID) AS percentiledisc, -- Discrete Distribution Model - Return the first value whose value is greater than or equal to the input
	PERCENTILE_CONT(@pct) WITHIN GROUP(ORDER BY score) OVER(PARTITION BY testID) AS percentilecont	-- Continuous Distribution Model - 
FROM dbo.Scores;
GO