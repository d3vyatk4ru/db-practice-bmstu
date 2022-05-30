
IF DB_ID(N'Airport') IS NULL
BEGIN
	RAISERROR(N'db in sot exist', 10, 1)
END
ELSE
BEGIN
	USE [Airport];
	ALTER DATABASE [Airport] 
		SET SINGLE_USER 
		WITH ROLLBACK IMMEDIATE;
END
GO

DROP VIEW IF EXISTS [Flight_info];
GO

DROP VIEW IF EXISTS [Orders_info];
GO

DROP TABLE IF EXISTS [Ticket];
GO

DROP VIEW IF EXISTS [Orders_count];
GO

IF OBJECT_ID(N'Ticket') IS NULL
PRINT '[Ticket] table was delete!'
GO

DROP TABLE IF EXISTS [Customer];
GO

IF OBJECT_ID(N'Customer') IS NULL
PRINT '[Customer] table was delete!'
GO

DROP TABLE IF EXISTS [Flight];
GO

IF OBJECT_ID(N'Flight') IS NULL
PRINT '[Flight] table was delete!'
GO

DROP TABLE IF EXISTS [Aircraft];
GO

IF OBJECT_ID(N'Aircraft') IS NULL
PRINT '[Aircraft] table was delete!'
GO

USE master;
GO

DROP DATABASE IF EXISTS [Airport];
GO