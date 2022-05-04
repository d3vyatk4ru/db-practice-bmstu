-- ���������� �� master
USE master;
GO

-- IF DATABASE IS EXISTING - DELETE IT
IF DB_ID(N'AirTicketsDB') IS NOT NULL
DROP DATABASE AirTicketsDB
GO

CREATE DATABASE AirTicketsDB
--  Saved data, table, indices...
	ON (NAME = AirTickets_dat,
		FILENAME = 'D:\Учеба\Магистр\db\lab_5\AirTicketsdat.mdf', -- abs. path to file with db
		SIZE = 10,											-- Initial size for all files in MB.
		MAXSIZE = UNLIMITED,								-- max. file size in MB, if size is not input - inf
		FILEGROWTH = 5%)									-- Upprer file size in persent.
-- Saved transactions logs for reconstruction db
	LOG ON (NAME = AirTickets_log,
			FILENAME = 'D:\Учеба\Магистр\db\lab_5\AirTickets_log', -- abs. path to file with db
			SIZE = 5MB,										 -- Initial size for all files in MB.
			MAXSIZE = 25MB,									 -- max. file size in MB, if size is not input - inf
			FILEGROWTH = 5MB);								 -- Upprer file size in MB.
GO

-- ���������� ������ ��� ��������� �� AirTicketsDB
USE AirTicketsDB;
GO

-- If table Ticket is existing - delete
IF OBJECT_ID(N'Ticket') IS NOT NULL
DROP TABLE Ticket;
GO

-- Create tables with columns ID, seat_id, first_name, last_name
CREATE TABLE Ticket (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	seat_id VARCHAR(3) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL);
GO

-- Input in the table Ticket
INSERT INTO Ticket
	(seat_id, first_name, last_name)
VALUES
	('01A', 'Ivan', 'Trenev'),
	('10B', 'Andrew', 'Tkachenko'),
	('11C', 'Nadya', 'Chaplinskaya'),
	('12D', 'Daniil', 'Devyatkin'),
	('13E', 'Petr', 'Petrov'),
	('14F', 'Irina', 'Vankina'),
	('07�', 'Kosha', 'Lemlev');
GO

-- _________________________ �������� �������� ������ � ���� ������. _______________________________

USE master;
GO

-- Create a new filegroup
ALTER DATABASE AirTicketsDB
	ADD FILEGROUP NewFileGroup;
GO

-- Adding in new filegroup AirTicketsdat_nFileGroup.ndf file with spec. settings
ALTER DATABASE AirTicketsDB
	ADD FILE 
		(NAME = AirTickets_nFileGroupdat,
		 FILENAME = 'D:\Учеба\Магистр\db\lab_5\AirTicketsdat_nFileGroup.ndf',
		 SIZE = 10,											-- Initial size for all files in MB.
		 MAXSIZE = UNLIMITED,								-- max. file size in MB, if size is not input - inf
		 FILEGROWTH = 5%)									-- Upprer file size in persent.

TO FILEGROUP NewFileGroup;
GO

-- Make new filegroup NewFileGroup default for db AirTicketsDB
ALTER DATABASE AirTicketsDB
	MODIFY FILEGROUP NewFileGroup DEFAULT;
GO

USE AirTicketsDB;
GO

-- If table NewTable is existing - delete
IF OBJECT_ID(N'NewTable') IS NOT NULL
DROP TABLE NewTable;
GO

-- Create new table with columns ID, fname, sname
CREATE TABLE NewTable (
	ID INT NOT NULL IDENTITY(1, 1),
	fname varchar(30) NOT NULL,
	sname varchar(30) NOT NULL);
GO

-- Input in the table Ticket
INSERT INTO NewTable
	(fname, sname)
VALUES
	('Ivan', 'Trenev'),
	('Andrew', 'Tkachenko'),
	('Nadya', 'Chaplinskaya'),
	('Daniil', 'Devyatkin'),
	('Petr', 'Petrov'),
	('Irina', 'Vankina'),
	('Kosha', 'Lemlev');
GO

USE AirTicketsDB;
GO

-- Changing file group to PRIMATY (main filegroup)
ALTER DATABASE AirTicketsDB
MODIFY FILEGROUP [PRIMARY] DEFAULT;
GO

-- Deleting table for delete .dat file and file group
DROP TABLE NewTable;
GO



-- Deleting .dat file for delete filegroup
ALTER DATABASE AirTicketsDB
REMOVE FILE AirTickets_nFileGroupdat
GO

-- Deleting filegroup
ALTER DATABASE AirTicketsDB
REMOVE FILEGROUP NewFileGroup;
GO

-- If schema NewSchema is existing - delete
IF SCHEMA_ID(N'NewSchema') IS NOT NULL
DROP SCHEMA NewSchema;
GO

-- Create new schema
CREATE SCHEMA NewSchema;
GO

-- Move table NewTable to NewSchema schema
ALTER SCHEMA NewSchema 
TRANSFER dbo.Ticket

DROP TABLE NewSchema.Ticket
GO

DROP SCHEMA NewSchema;
GO

USE master;
GO

DROP DATABASE AirTicketsDB;
GO
