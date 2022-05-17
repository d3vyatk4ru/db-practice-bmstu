USE [Airport];
GO

CREATE VIEW [Flight_info]
AS
	SELECT
		[t].[seat_id], [t].[last_name], [t].[first_name],
		[f].[date], [f].[arrival_airport], [f].[departure_airport], [f].[status],
		[a].[model]
	FROM
		[Ticket] t INNER JOIN [Flight] f
		ON [t].[FID] = [f].[FID]
			INNER JOIN [Aircraft] a
			ON [a].[aircraft_id] = [f].[aircraft_id]
GO

CREATE VIEW [Orders_info]
AS
	SELECT
		[c].[passport_customer], [c].[email], [c].[first_name], [c].[last_name],
		[f].[arrival_airport], [f].[departure_airport], [f].[date]
	FROM
		[Customer] c INNER JOIN [Ticket] t
		ON [t].[passport_customer] = [c].[passport_customer]
			INNER JOIN [Flight] f
			ON [f].FID = [t].FID
GO

SELECT * FROM [Orders_info];
GO

DROP VIEW [Flight_info];
GO

DROP VIEW [Orders_info];
GO