USE master;
GO

IF DB_ID(N'Lab10DB') IS NOT NULL
DROP DATABASE [Lab10DB];
GO

CREATE DATABASE [Lab10DB]
ON
	(NAME = Lab10DB_dat,
	 FILENAME = 'D:\Study\Master\db\lab_10\Lab10BD.mdf',
	 SIZE = 5MB,
	 MAXSIZE = UNLIMITED,
	 FILEGROWTH = 10%)
LOG ON
	(NAME = Lab10DB_log,
	 FILENAME = 'D:\Study\Master\db\lab_10\Lab10BD_log',
	 SIZE = 5MB,
	 MAXSIZE = 25MB,
	 FILEGROWTH = 5MB
	)
GO

USE [Lab10DB];
GO

----------------------------------------------------------------------------
IF OBJECT_ID(N'Aircraft') IS NOT NULL
DROP TABLE [Aircraft];
GO

CREATE TABLE [Aircraft]
	([aircraft_id] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [model] VARCHAR(30) NOT NULL)

INSERT INTO [Aircraft]
VALUES
	('Airbus A318'),
	('Boeing 727'),
	('Airbus A320'),
	('“уполев “у-204'),
	('Saab'),
	('»л-86');
GO
