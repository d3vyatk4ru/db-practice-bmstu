USE [Airport];
GO

----------------------------------------------------------------------------

CREATE VIEW [Flight_info]
AS
	SELECT
		[t].[seat_id], [t].[last_name], [t].[first_name],
		[f].[date], [f].[arrival_airport], [f].[departure_airport], [f].[status],
		[a].[model]
	FROM
		[Ticket] t INNER JOIN [Flight] f
		ON [t].[FID] = [f].[FID]
			LEFT JOIN [Aircraft] a
			ON [a].[aircraft_id] = [f].[aircraft_id]
GO

SELECT * FROM
	[Flight_info]
WHERE
	[arrival_airport] LIKE '___'
	AND [seat_id] IS NOT NULL
ORDER BY
	[date] ASC;
GO

DROP VIEW [Flight_info];
GO

----------------------------------------------------------------------------

CREATE VIEW [Orders_info]
AS
	SELECT
		[c].[passport_customer], [c].[email], [c].[first_name], [c].[last_name],
		[f].[arrival_airport], [f].[departure_airport], [f].[date]
	FROM
		[Customer] AS [c] INNER JOIN [Ticket] AS [t]
		ON [t].[passport_customer] = [c].[passport_customer]
			INNER JOIN [Flight] f
			ON [f].FID = [t].FID
GO

SELECT DISTINCT * FROM
	[Orders_info]
WHERE
	DATEADD(Week, 1, [date]) 
	< (SELECT MAX([date]) FROM [Orders_info])
	AND [departure_airport] IN ('ARH', 'VOG')
GO

----------------------------------------------------------------------------

CREATE VIEW [Orders_count]
AS
	SELECT
		[c].[first_name], [c].[last_name], [t].[passport_customer], COUNT([t].[passport_customer]) AS [amount]
	FROM
		[Ticket] AS [t] FULL OUTER JOIN [Customer] AS [c]
		ON [t].passport_customer = [c].passport_customer
	GROUP BY
		[t].[passport_customer], [c].[first_name], [c].[last_name]
	HAVING
		COUNT([t].[passport_customer]) = 2
GO

SELECT * FROM [Orders_count]
ORDER BY
	[first_name] DESC;
GO

----------------------------------------------------------------------------

CREATE VIEW [Unused_aircrafts]
AS
	SELECT [aircraft_id]   
	FROM
		[Aircraft]
	EXCEPT    
	SELECT [aircraft_id]   
	FROM
		[Flight]
GO

CREATE VIEW [Used_aircrafts]
AS
	SELECT [aircraft_id]   
	FROM
		[Aircraft]
	INTERSECT    
	SELECT [aircraft_id]   
	FROM
		[Flight]
GO

SELECT
	[unused].[aircraft_id], [a].[model]
FROM 
	[Unused_aircrafts] AS [unused] JOIN [Aircraft] AS [a]
	ON [unused].[aircraft_id] = [a].[aircraft_id]
UNION
SELECT
	[used].[aircraft_id], [a].[model] 
FROM
	[Used_aircrafts] AS [used] JOIN [Aircraft] AS [a]
	ON [used].[aircraft_id] = [a].[aircraft_id]
GO

----------------------------------------------------------------------------
