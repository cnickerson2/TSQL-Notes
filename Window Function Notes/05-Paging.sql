-- Index defined on the window ordering element will increase performance

CREATE UNIQUE INDEX idx_ordrders
	ON Orders(orderdate, orderid)
	INCLUDE(custid, empid);
GO

DECLARE
	@pagenum as INT = 3,
	@pagesize as INT = 25;

WITH C AS
(
	SELECT ROW_NUMBER() OVER (ORDER BY orderdate, orderid) AS rownum,
		orderid, orderdate, custid, empid
	FROM Orders
)
SELECT orderid, orderdate, custid, empid
FROM C
WHERE rownum BETWEEN (@pagenum - 1) * @pagesize + 1 -- First row on the page (51)
			 AND @pagenum * @pagesize				-- Last row on the page (75)
ORDER BY rownum;
GO

DECLARE
	@pagenum as INT = 3,
	@pagesize as INT = 25;

SELECT orderid, orderdate, custid, empid
FROM Orders
ORDER BY orderdate, orderid
OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY; -- New option, Starting at the OFFSET point, fetch the next @pagesize amount of rows
GO

DROP INDEX idx_ordrders on Orders;