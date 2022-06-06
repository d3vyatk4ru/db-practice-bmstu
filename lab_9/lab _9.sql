USE master;
GO

IF DB_ID(N'Lab9DB') IS NOT NULL
DROP DATABASE [Lab9DB];
GO

CREATE DATABASE [Lab9DB]
ON
	(NAME = Lab9DB_dat,
	 FILENAME = 'D:\Study\Master\db\lab_9\Lab9BD.mdf',
	 SIZE = 5MB,
	 MAXSIZE = UNLIMITED,
	 FILEGROWTH = 10%)
LOG ON
	(NAME = Lab9DB_log,
	 FILENAME = 'D:\Study\Master\db\lab_9\Lab9BD_log',
	 SIZE = 5MB,
	 MAXSIZE = 25MB,
	 FILEGROWTH = 5MB
	)
GO

USE [Lab9DB];
GO

IF OBJECT_ID(N'Flight') IS NOT NULL
DROP TABLE [Flight];
GO

CREATE SEQUENCE [seq_flight_id]
	START WITH 999
    INCREMENT BY -1 ;
GO

CREATE TABLE [Flight]
	([FID] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [flight_id] INT NOT NULL UNIQUE DEFAULT NEXT VALUE FOR [seq_flight_id],
	 [date] DATETIME NOT NULL DEFAULT GETDATE(),
	 [departure_airport] CHAR(3) NOT NULL CHECK (LEN([departure_airport]) = 3 AND departure_airport LIKE '[A-Z]%') DEFAULT 'UNK',
	 [arrival_airport] CHAR(3) NOT NULL CHECK (LEN([arrival_airport]) = 3 AND arrival_airport LIKE '[A-Z]%') DEFAULT 'UNK',
	 [status] CHAR(3) CHECK(LEN([status]) = 3 AND [status] LIKE '[A-Z]%') DEFAULT 'UNK',
	 [amount] INT DEFAULT NULL,
	)
GO


INSERT INTO [Flight]
	([departure_airport], [arrival_airport], [status], [amount])
VALUES
	( 'ARH', 'KWG', 'INF', 5),
	( 'VOG', 'BQS', 'INF', 8),
	( 'KEJ', 'SVX', 'DEP', 2),
	( 'LPP', 'KDL', 'DEP', 5),
	( 'GYG', 'DEE', 'INF', 7)
GO
----------------------------------------------------------------------------

IF OBJECT_ID(N'Ticket') IS NOT NULL
DROP TABLE [Ticket];
GO

CREATE TABLE [Ticket]
	([ticket_id] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [seat_id] CHAR(3) NOT NULL CHECK (LEN([seat_id]) = 3 AND [seat_id] LIKE '[0-9][0-9][A-I]'),
	 [passport_ticket] CHAR(10) NOT NULL,
	 [last_name] VARCHAR(30) NOT NULL, 
	 [first_name] VARCHAR(15) NOT NULL,
	 [passport_customer] CHAR(10) NOT NULL,
	 [FID] INT NOT NULL FOREIGN KEY ([FID]) REFERENCES [Flight]([FID])
	);
GO

INSERT INTO
	[Ticket]([seat_id], [passport_ticket], [last_name], [first_name], [passport_customer], [FID])
VALUES
	('03A', '4820123456', 'Trenev', 'Ivan', '4820123456', @@IDENTITY),
	('03B', '5420123456', 'Irkutina', 'Daria', '4820123456', @@IDENTITY),
	('25F', '4917654321', 'Tkachenko', 'Andrew', '4917654321',@@IDENTITY - 1),
	('25E', '5320654321', 'Tkachenko', 'Maria', '4917654321', @@IDENTITY - 1),
	('13B', '7822098890', 'Chaplinskya', 'Nadya', '7822098890', @@IDENTITY - 2),
	('13C', '6719098890', 'Kupcov', 'Nikita', '7822098890', @@IDENTITY - 2),
	('99D', '4510567489', 'Devyatkin', 'Daniil', '4510567489', @@IDENTITY - 3)
GO

----------------------------------------------------------------------------
-- Task [1] Для одной из таблиц пункта 2 задания 7 создать триггеры на вставку,
-- удаление и добавление, при выполнении заданных условий один из триггеров должен
-- инициировать возникновение ошибки (RAISERROR / THROW).

CREATE TRIGGER [FlightInsertTrig] ON [Flight]
	AFTER INSERT
AS
BEGIN
	PRINT 'In table [Flight] was insert row'
END
GO

INSERT INTO [Flight]
	([flight_id], [departure_airport], [arrival_airport], [status], [amount])
VALUES
	(994, 'ARH', 'ARH', 'TIO', 1)
GO

CREATE TRIGGER [FlightUpdateTrig] ON [Flight]
	AFTER UPDATE
AS
BEGIN
	PRINT 'In table [Flight] was update some row' 
END
GO

UPDATE
	[Flight]
SET
	[status] = 'UNK'
WHERE
	[status] = 'TIO'
GO

CREATE TRIGGER [FlightDeleteTrig] ON [Flight]
	AFTER DELETE
AS
BEGIN
	RAISERROR( N'Calling RAISERROR when removed', 10, 1);
END
GO

DELETE FROM 
	[Flight]
WHERE
	[status] = 'UNK'
GO

----------------------------------------------------------------------------
-- Task [2] Для представления пункта 2 задания 7 создать 
-- триггеры на вставку, удаление и добавление, обеспечивающие 
-- возможность выполнения операций с данными непосредственно через представление.

CREATE VIEW [FlightInfo]
AS
	SELECT
		[date], [departure_airport], [arrival_airport], [status]
	FROM
		[Flight]
GO

SELECT * FROM [FlightInfo];
GO
----------------------------------------------------------------------------

<<<<<<< HEAD
<<<<<<< HEAD
IF OBJECT_ID(N'Сlassroom_teacher') IS NOT NULL
DROP TABLE Сlassroom_teacher;
GO

CREATE TABLE [Сlassroom_teacher]
	([TID] [INT] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [last_name] [NVARCHAR](30) NOT NULL DEFAULT 'NoLastName',
	 [group_name] [NVARCHAR](3) NOT NULL UNIQUE)
GO

INSERT INTO
	[Сlassroom_teacher]([last_name], [group_name])
VALUES
	('Ivanova', '1A'),
	('Petrova', '3B'),
	('Sidorova', '8A'),
	('Terehina', '6B')
GO

IF OBJECT_ID(N'Group') IS NOT NULL
DROP TABLE [Group];
GO

CREATE TABLE [Group]
	([CID] [INT] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [TID] [INT] NOT NULL 
	 FOREIGN KEY ([TID]) REFERENCES [Сlassroom_teacher]([TID]),
	 [n_students] [INT] DEFAULT NULL)
GO

INSERT INTO
	[Group]([n_students], [TID])
VALUES
	(28, 1),
	(17, 2),
	(24, 3),
	(31, 4)
GO

----------------------------------------------------------------------------

CREATE VIEW [ClassRoomInfo]
AS
	SELECT
		[c].[last_name], [c].[group_name], [g].[n_students]
	FROM
		[Сlassroom_teacher] AS [c] JOIN [Group] AS [g]
		ON [c].[TID] = [g].[TID]
GO

SELECT * FROM [ClassRoomInfo];
GO

----------------------------------------------------------------------------

CREATE TRIGGER [ClassRoomInfoInsertTrig] ON [ClassRoomInfo]
=======
CREATE TRIGGER [FlightInfoInsertTrig] ON [FlightInfo]
>>>>>>> parent of 90c8c6e (added remarks into task 2)
=======
CREATE TRIGGER [FlightInfoInsertTrig] ON [FlightInfo]
>>>>>>> parent of 90c8c6e (added remarks into task 2)
	INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO
		[Flight]([departure_airport], [arrival_airport], [status])
	SELECT
		[i].[departure_airport],
		[i].[arrival_airport],
		[i].[status]
	FROM
<<<<<<< HEAD
<<<<<<< HEAD
		inserted  AS [i]

	INSERT INTO
		[Group]([TID], [n_students])
	SELECT
		[c].[TID], [i].[n_students]
	FROM 
		inserted AS [i], [Сlassroom_teacher] as [c]
	WHERE
		[i].[last_name] = [c].last_name
		AND [i].[group_name] = [c].[group_name]
=======
		inserted AS i
		
	PRINT 'In view [FlightInfo] was insert some row'
>>>>>>> parent of 90c8c6e (added remarks into task 2)
=======
		inserted AS i
		
	PRINT 'In view [FlightInfo] was insert some row'
>>>>>>> parent of 90c8c6e (added remarks into task 2)
END
GO

INSERT INTO
	[FlightInfo]([departure_airport], [arrival_airport], [status])
VALUES
	('SVX', 'KEJ', 'ARR')
GO

SELECT * FROM [FlightInfo];
GO
----------------------------------------------------------------------------

CREATE TRIGGER [FlightInfoUpdateTrig] ON [FlightInfo]
	INSTEAD OF UPDATE
AS
BEGIN
	UPDATE
		[Flight]
	SET
		[status] = [i].[status]
	FROM
<<<<<<< HEAD
<<<<<<< HEAD
		(SELECT *, row_number() OVER (ORDER BY [n_students]) AS [row_num] FROM inserted) AS i 
		JOIN
		(SELECT *, row_number() OVER (ORDER BY [n_students]) AS [row_num] FROM deleted) AS d
		ON 
			[i].[row_num] = [d].[row_num]
		WHERE 
			[Сlassroom_teacher].[last_name] = [d].[last_name]

	UPDATE
		[Group]
	SET
		[n_students] = [i].[n_students]
	FROM
		(SELECT *, row_number() OVER (ORDER BY [n_students]) AS [row_num] FROM inserted) AS i 
		JOIN
		(SELECT *, row_number() OVER (ORDER BY [n_students]) AS [row_num] FROM deleted) AS d
		ON 
			[i].[row_num] = [d].[row_num]
	WHERE 
		[Group].[n_students] = [d].[n_students]
=======
		(SELECT *, row_number() OVER (ORDER BY [date]) AS [row_num] FROM inserted) AS i 
		JOIN
		(SELECT *, row_number() OVER (ORDER BY [date]) AS [row_num] FROM deleted) AS d
		ON 
			[i].[row_num] = [d].[row_num]
		WHERE 
			[Flight].[departure_airport] = [d].[departure_airport]
>>>>>>> parent of 90c8c6e (added remarks into task 2)
=======
		(SELECT *, row_number() OVER (ORDER BY [date]) AS [row_num] FROM inserted) AS i 
		JOIN
		(SELECT *, row_number() OVER (ORDER BY [date]) AS [row_num] FROM deleted) AS d
		ON 
			[i].[row_num] = [d].[row_num]
		WHERE 
			[Flight].[departure_airport] = [d].[departure_airport]
>>>>>>> parent of 90c8c6e (added remarks into task 2)
END
GO

UPDATE
	[FlightInfo]
SET
	[status] = 'ABC'
WHERE
	[departure_airport] = 'SVX';
GO

SELECT * FROM [FlightInfo];
GO
<<<<<<< HEAD
<<<<<<< HEAD

------------------------------------------------------------------------------
=======
=======
>>>>>>> parent of 90c8c6e (added remarks into task 2)
----------------------------------------------------------------------------
>>>>>>> parent of 90c8c6e (added remarks into task 2)

CREATE TRIGGER [FlightInfoDeleteTrig] ON [FlightInfo]
	INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM
		[Flight]
	WHERE
<<<<<<< HEAD
<<<<<<< HEAD
		[TID] = (SELECT [c].[TID] FROM [Сlassroom_teacher] AS [c], deleted AS [d]
				 WHERE [d].[group_name] = [c].[group_name])

	DELETE FROM
		[Сlassroom_teacher]
	WHERE
		[group_name] = (SELECT [d].[group_name] FROM deleted AS [d])
=======
		[departure_airport] = (SELECT [d].[departure_airport] FROM deleted AS d)
		AND [arrival_airport] = (SELECT [d].[arrival_airport] FROM deleted AS d)
>>>>>>> parent of 90c8c6e (added remarks into task 2)
=======
		[departure_airport] = (SELECT [d].[departure_airport] FROM deleted AS d)
		AND [arrival_airport] = (SELECT [d].[arrival_airport] FROM deleted AS d)
>>>>>>> parent of 90c8c6e (added remarks into task 2)
END
GO

DELETE FROM
	[FlightInfo]
WHERE
	[departure_airport] = 'SVX'
	AND [arrival_airport] = 'KEJ';
GO

SELECT * FROM [FlightInfo];
GO


----------------------------------------------------------------------------

----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS [FlightInfoDeleteTrig];
GO

DROP TRIGGER IF EXISTS [FlightInfoInsertTrig];
GO

DROP VIEW IF EXISTS [FlightInfo];
GO

DROP TRIGGER IF EXISTS [FlightInsertTrig];
GO

DROP TRIGGER IF EXISTS [FlightUpdateTrig];
GO

DROP TRIGGER IF EXISTS [FlightDeleteTrig];
GO

DROP TABLE IF EXISTS [Ticket];
GO

DROP TABLE IF EXISTS [Flight];
GO

USE master;
GO

DROP DATABASE [Lab9DB];
Go