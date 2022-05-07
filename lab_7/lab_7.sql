USE master;
GO

IF DB_ID(N'Lab7DB') IS NOT NULL
DROP DATABASE Lab7DB;
GO

CREATE DATABASE Lab7DB

	ON (NAME = Lab7DB_dat,
		FILENAME = 'D:\Учеба\Магистр\db\lab_7\Lab7DB.mdf',
		SIZE = 5MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%
	)

	LOG ON (NAME = Lab7DB_log,
			FILENAME = 'D:\Учеба\Магистр\db\lab_7\Lab7DB_log',
			SIZE = 5MB,
			MAXSIZE = 25MB,
			FILEGROWTH = 5MB);
GO

USE Lab7DB;
GO

IF OBJECT_ID(N'[Aircraft]') IS NOT NULL
DROP TABLE [Aircraft]
GO

CREATE TABLE [Aircraft]
	([aircraft_id] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [model] VARCHAR(30) NOT NULL
	)

INSERT INTO [Aircraft]
VALUES
	('Airbus A318'),
	('Boeing 727'),
	('Airbus A320'),
	('Туполев Ту-204'),
	('Saab'),
	('Ил-86')
GO

USE Lab7DB;
GO

IF OBJECT_ID(N'[Flight]') IS NOT NULL
DROP TABLE [Flight];
GO

CREATE TABLE [Flight]
	([FID] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [flight_id] INT NOT NULL UNIQUE DEFAULT -1,
	 [date] DATETIME NOT NULL DEFAULT GETDATE(),
	 [departure_airport] CHAR(3) NOT NULL CHECK (departure_airport LIKE '[A-Z]%') DEFAULT 'UNK',
	 [arrival_airport] CHAR(3) NOT NULL CHECK (arrival_airport LIKE '[A-Z]%') DEFAULT 'UNK',
	 [status] CHAR(3) CHECK([status] LIKE '[A-Z]%') DEFAULT 'UNK',
	 [amount] INT DEFAULT NULL,
	 [aircraft_id] INT FOREIGN KEY REFERENCES [Aircraft]([aircraft_id])
	)

INSERT INTO [Flight]
	([flight_id], [departure_airport], [arrival_airport], [status], [amount], [aircraft_id])
VALUES
	(999, 'ARH', 'KWG', 'INF', 5, 1),
	(998, 'VOG', 'BQS', 'INF', 8, 1),
	(997, 'KEJ', 'SVX', 'ARR', 2, 5),
	(996, 'LPP', 'KDL', 'ARR', 5, 2),
	(995, 'GYG', 'DEE', 'INF', 7, 3)
GO

-- 1. Creating view (VIEW) for [LAB7DB].[Flight] table

CREATE VIEW [FlightInfo] AS

SELECT
	[departure_airport],
	[arrival_airport],
	[status]
FROM
	[Flight]
WITH CHECK OPTION
GO

-- 2. Creating view which based to fields from both table

CREATE VIEW
	[FullFlightInfo]
AS
SELECT 
	[f].[departure_airport],
	[f].[arrival_airport],
	[f].[status],
	[f].[aircraft_id],
	[a].[model]
FROM
	[Flight] f INNER JOIN [Aircraft] a
ON
	[f].[aircraft_id] = [a].[aircraft_id]
WITH
	CHECK OPTION;
GO

-- 3. Создать индекс для одной из таблиц задания 6, включив в него дополнительные неключевые поля.

CREATE INDEX 
	[IX_FID_dep_arr_airport]
ON
	[Flight]([FID])		-- Почему не сработало, когда все было записано в ON ...
INCLUDE
	([departure_airport], [arrival_airport])
GO

-- 4. Создать индексированное представление.

CREATE VIEW
	dbo.[VIEW_WITH_INDEX] 
WITH
	SCHEMABINDING AS
SELECT
	[f].[FID],
	[f].[departure_airport],
	[f].[arrival_airport],
	[f].[status],
	[f].[aircraft_id],
	[f].[date],
	[a].[model]
FROM
	dbo.[Flight] f INNER JOIN dbo.[Aircraft] a
ON
	[f].[aircraft_id] = [a].[aircraft_id]
GO

CREATE UNIQUE CLUSTERED INDEX
	[IX_VIEW]
ON
	[VIEW_WITH_INDEX]([FID]);
GO

-- TASK [4]

SELECT * FROM [VIEW_WITH_INDEX];
GO

-- Task [3]
SELECT 
	[FID], [departure_airport], [arrival_airport]
FROM
	[Flight]
WITH
	(INDEX([IX_FID_dep_arr_airport]))
GO

-- Task [2]
SELECT * FROM [FullFlightInfo];
GO

-- Task [1]
SELECT * FROM [FlightInfo];
GO

---------- DELETE ------------

DROP INDEX	
	[IX_VIEW]
ON
	[VIEW_WITH_INDEX];
GO

DROP VIEW [VIEW_WITH_INDEX];
GO

DROP INDEX
	[IX_FID_dep_arr_airport]
ON
	[Flight];
GO

DROP VIEW [FlightInfo];
GO

DROP VIEW [FullFlightInfo];
GO

DROP TABLE [Flight];
GO

DROP TABLE [Aircraft];
GO
