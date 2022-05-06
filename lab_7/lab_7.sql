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
GO

INSERT INTO [Flight]
	([flight_id], [departure_airport], [arrival_airport], [status], [amount], [aircraft_id])
VALUES
	(999, 'ARH', 'KWG', 'INF', 5, 1),
	(998, 'VOG', 'BQS', 'INF', 8, 1),
	(997, 'KEJ', 'SVX', 'ARR', 2, 5),
	(996, 'LPP', 'KDL', 'ARR', 5, 2),
	(995, 'GYG', 'DEE', 'INF', 7, 3)
GO

-- 1. Создание представление (VIEW) для таблицы [LAB7DB].[Flight]

CREATE VIEW [FlightInfo] AS

SELECT
	[departure_airport],
	[arrival_airport],
	[status]
FROM
	[Flight]
WITH CHECK OPTION
GO

-- 2. Создание представления на основе поле обеих таблиц

CREATE VIEW [FullFlightInfo] AS

SELECT 
	[f].[departure_airport],
	[f].[arrival_airport],
	[f].[status],
	[f].[aircraft_id],
	[a].[model]
FROM [Flight] f INNER JOIN [Aircraft] a
	ON f.aircraft_id = a.aircraft_id
WITH CHECK OPTION;
GO

-- Task [2]
SELECT * FROM [FullFlightInfo];
GO

-- Task [1]
SELECT * FROM [FlightInfo];
GO

DROP TABLE [Flight];
GO

DROP TABLE [Aircraft];
GO
