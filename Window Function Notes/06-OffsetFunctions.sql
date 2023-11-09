-- Current Row Category
/*
	LAG
	LEAD
*/

SELECT custid, orderdate, orderid, val,
	LAG(val)	OVER(PARTITION BY custid
					 ORDER BY orderdate,orderid) AS prevval,
	LAG(val)	OVER(PARTITION BY custid
					 ORDER BY orderdate,orderid) AS nextval,
FROM vw_OrderValues; -- Assumes an offset of 1 by default

SELECT custid, orderdate, orderid, val,
	LAG(val, 3)	OVER(PARTITION BY custid						-- Check 3 spots behind
					 ORDER BY orderdate,orderid) AS prev3val,
	LAG(val, 3, 0.00)	OVER(PARTITION BY custid				-- Default to 0.00 if the thing didn't exist
					 ORDER BY orderdate,orderid) AS next3val,
FROM vw_OrderValues;


-- Relative to Start/End of Window
/*
	FIRST_VALUE
	LAST_VALUE
	NTH_VALUE (Not supported in MSSQL2012)
*/

SELECT custid, orderdate, orderid, val,
	FIRST_VALUE(val)	OVER(PARTITION BY custid
						     ORDER BY orderdate,orderid) AS val_firstorder,
	LAST_VALUE(val)	OVER(PARTITION BY custid
						     ORDER BY orderdate,orderid
							 ROWS BETWEEN CURRENT ROW
								      AND UNBOUNDED FOLLOWING) AS val_lastorder, -- by default, it will attempt UNBOUNDED PRECEDING, which would just give you this current row. Explicitly stating that it should give a later one, if possible
FROM vw_OrderValues; -- Assumes an offset of 1 by default