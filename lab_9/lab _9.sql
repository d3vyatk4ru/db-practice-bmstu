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
	( 'LPP', 'KDL', 'UNK', 5),
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
	FOR INSERT
AS

IF EXISTS (SELECT *
		   FROM inserted
		   WHERE [status] = 'POP')
		BEGIN
			PRINT 'Bad inserted status'
			ROLLBACK TRANSACTION
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
	[status] = 'AAA'
WHERE
	[status] = 'TIO'
GO

CREATE TRIGGER [FlightDeleteTrig] ON [Flight]
	FOR DELETE
AS
BEGIN
	IF EXISTS (SELECT *
			   FROM deleted
			   WHERE [status] = 'BBB')
		BEGIN
			RAISERROR( N'Calling RAISERROR when removed', 10, 1);
		END
END
GO

DELETE FROM 
	[Flight]
WHERE
	[status] = 'AAA'
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
	INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO
		[Сlassroom_teacher]([last_name], [group_name])
	SELECT
		[i].[last_name], [i].[group_name]
	FROM
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
END
GO

INSERT INTO
	[ClassRoomInfo]([last_name], [group_name], [n_students])
VALUES
	('Trenev', '22F', 2),
	('AAAAAAA', 'BA1', 100);
GO

SELECT * FROM [ClassRoomInfo];
GO

----------------------------------------------------------------------------

CREATE TRIGGER [ClassRoomInfoUpdateTrig] ON [ClassRoomInfo]
	INSTEAD OF UPDATE
AS
BEGIN
	UPDATE
		[Сlassroom_teacher]
	SET
		[last_name] = [i].[last_name]
	FROM
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
END
GO

UPDATE
	[ClassRoomInfo]
SET
	[last_name] = 'NewLastName',
	[n_students] = 0
WHERE
	[group_name] = '22F';
GO

SELECT * FROM [ClassRoomInfo];
GO

------------------------------------------------------------------------------

CREATE TRIGGER [ClassRoomInfoDeleteTrig] ON [ClassRoomInfo]
	INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM
		[Group]
	WHERE
		[TID] = (SELECT [c].[TID] FROM [Сlassroom_teacher] AS [c], deleted AS [d]
				 WHERE [d].[group_name] = [c].[group_name])

	DELETE FROM
		[Сlassroom_teacher]
	WHERE
		[group_name] = (SELECT [d].[group_name] FROM deleted AS [d])
END
GO

DELETE FROM
	[ClassRoomInfo]
WHERE
	[group_name] = 'BA1';
GO

SELECT * FROM [ClassRoomInfo];
GO

----------------------------------------------------------------------------

DROP TRIGGER IF EXISTS [ClassRoomInfoDeleteTrig];
GO

DROP TRIGGER IF EXISTS [ClassRoomInfoUpdateTrig];
GO

DROP TRIGGER IF EXISTS [ClassRoomInfoInsertTrig];
GO

DROP VIEW IF EXISTS [ClassRoomInfo];
GO

DROP TABLE IF EXISTS [Group];
GO

DROP TABLE IF EXISTS [Сlassroom_teacher];
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
GO