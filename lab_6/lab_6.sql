USE master;
GO

-- if db is existing - delete
IF DB_ID(N'Lab6DB') IS NOT NULL
DROP DATABASE Lab6DB;
GO

CREATE DATABASE Lab6DB
--  Saved data, table, indices...
	ON (NAME = Lab6DB_dat,
		FILENAME = 'D:\Учеба\Магистр\db\lab_6\Lab6DB.mdf',
		SIZE = 5MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 5%)
-- Saved transactions logs for reconstruction db
	LOG ON (NAME = Lab6DB_log,
			FILENAME = 'D:\Учеба\Магистр\db\lab_6\Lab6DB_log',
			SIZE = 5MB,
			MAXSIZE = 25MB,
			FILEGROWTH = 5MB);
GO

-- Use db Lab6DB
USE Lab6DB;
GO

-- if table is existing - delete
IF OBJECT_ID(N'Lab6Table1') IS NOT NULL
DROP TABLE Lab6Table1;
GO

-- Create tables with columns ID, identify with check value and title, now_date with default value
CREATE TABLE Lab6Table1
	(ID INT NOT NULL IDENTITY(0, 1) PRIMARY KEY,
	 n_user VARCHAR(10) NOT NULL,
	 identify INT CHECK (identify > 0),
	 title VARCHAR(50) DEFAULT 'Title is None',
	 TIME_NOW TIME NOT NULL DEFAULT GETDATE());
GO

-- create and init var 'i'
DECLARE @i INTEGER;
SET @i = 100;

-- create and init var '@bound'
DECLARE @bound INTEGER;
SET @bound = 110;

-- loop for filling table [bound - i] iter.
WHILE @i < @bound
BEGIN

	IF (@i < 106)
		BEGIN
		INSERT INTO Lab6Table1
			(n_user, identify)
		VALUES
			(CONCAT ('user #', @i), @bound - @i);
		END
	ELSE
		BEGIN
		INSERT INTO Lab6Table1
			(n_user, identify, title)
		VALUES
			(CONCAT ('user #', @i), @bound - @i, 'ABCDEFG');
		END

	SET @i = @i + 1;
END;
GO

SELECT * FROM Lab6Table1;
GO

DROP TABLE Lab6Table1;
GO

IF OBJECT_ID(N'Lab6Table2') IS NOT NULL
DROP TABLE Lab6Table2;
GO

-- create table with GUID as PRIMARY KEY
-- read about GUID https://info-comp.ru/guid-in-microsoft-sql-server

CREATE TABLE Lab6Table2
	(ID UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
	 NameCustomer VARCHAR(30) DEFAULT NULL);
GO

INSERT INTO Lab6Table2
	(NameCustomer)
VALUES
	('Oleg'),
	('Daniil'),
	('Sonya'),
	(DEFAULT);
GO

SELECT * FROM Lab6Table2;
GO

DROP TABLE Lab6Table2;
GO

-- create SEQUENCE SEQUENCE with BIGINT type, which start from 0 with step 1 ans caching
CREATE SEQUENCE seqForPK
	AS INT
	START WITH 0
	INCREMENT BY 1
	CACHE;
GO

IF OBJECT_ID(N'Lab6Table3') IS NOT NULL
DROP TABLE Lab6Table3;
GO

-- create table with SEQUENCE as PRIMARY KEY
CREATE TABLE Lab6Table3
	(ID INT NOT NULL PRIMARY KEY DEFAULT NEXT VALUE FOR seqForPK,
	 FNAME VARCHAR(30) DEFAULT 'Oleg',
	 DATE_NOW DATE NOT NULL DEFAULT GETDATE());
GO

INSERT INTO Lab6Table3
	(FNAME)
VALUES
	('DARIA'), ('Mihail'), ('Stepan'), (DEFAULT), ('Ivan'), (DEFAULT);
GO

SELECT * FROM Lab6Table3;
GO