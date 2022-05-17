USE master;
GO

IF DB_ID(N'Airport') IS NOT NULL
ALTER DATABASE [Airport] 
	SET SINGLE_USER 
	WITH ROLLBACK IMMEDIATE;
DROP DATABASE [Airport];
GO

CREATE DATABASE [Airport]
ON
	(NAME = airport_db_dat,
	 FILENAME = 'D:\Study\Master\db\final-project\airport_db.mdf',
	 SIZE = 10MB, 
	 MAXSIZE = UNLIMITED,
	 FILEGROWTH = 10%)
LOG ON
	(NAME = airport_db_log,
	 FILENAME = 'D:\Study\Master\db\final-project\airport_log',
	 SIZE = 5MB, 
	 MAXSIZE = UNLIMITED,
	 FILEGROWTH = 10%);
GO

IF DB_ID(N'Airport') IS NOT NULL
PRINT 'База данных [Airport] создана!'
GO

USE [Airport];
GO

----------------------------------------------------------------------------
-- Delete Table from db
IF OBJECT_ID(N'Ticket') IS NOT NULL
DROP TABLE [Ticket];
GO

IF OBJECT_ID(N'Customer') IS NOT NULL
DROP TABLE [Customer];
GO

IF OBJECT_ID(N'Flight') IS NOT NULL
DROP TABLE [Flight];
GO

IF OBJECT_ID(N'Aircraft') IS NOT NULL
DROP TABLE [Aircraft];
GO

----------------------------------------------------------------------------
--- Table with aircrafts and their ID 

CREATE TABLE [Aircraft]
	([aircraft_id] [INT] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [model] [VARCHAR](30) NOT NULL
	);
GO

IF OBJECT_ID(N'Aircraft') IS NOT NULL
PRINT 'Table with aircrafts [Aircraft] was created!'
GO

----------------------------------------------------------------------------
-- Table with Flight. It's departure and arrival airport, date of flight, 
-- flight's status and other info

CREATE TABLE [Flight]
	([FID] [INT] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [flight_id] [INT] NOT NULL UNIQUE DEFAULT -1,
	 [date] [DATETIME] NOT NULL DEFAULT CAST(GETDATE() AS TIME(0)),
	 [departure_airport] [CHAR](3) NOT NULL CHECK (LEN([departure_airport]) = 3 AND departure_airport LIKE '[A-Z]%') DEFAULT 'UNK',
	 [arrival_airport] [CHAR](3) NOT NULL CHECK (LEN([arrival_airport]) = 3 AND arrival_airport LIKE '[A-Z]%') DEFAULT 'UNK',
	 [status] [CHAR](3) CHECK(LEN([status]) = 3 AND [status] LIKE '[A-Z]%') DEFAULT 'UNK',
	 [amount] [INT] DEFAULT NULL,
	 [aircraft_id] [INT] FOREIGN KEY ([aircraft_id]) 
				   REFERENCES [Aircraft]([aircraft_id])
				   ON DELETE SET NULL
				   ON UPDATE CASCADE
	);
GO

IF OBJECT_ID(N'Flight') IS NOT NULL
PRINT 'Table with flight [Flight] was created!'
GO

----------------------------------------------------------------------------
--- Table with ticket's customer. Customer has unique email and unique
-- passport customer, first name and last name.

CREATE TABLE [Customer]
	([passport_customer] [CHAR](10) NOT NULL
						 PRIMARY KEY 
						 CHECK (LEN([passport_customer]) = 10),
	 [email] [VARCHAR](60) NOT NULL CHECK ([email] LIKE '%@%.%'),
	 [last_name] [VARCHAR](30) NOT NULL, 
	 [first_name] [VARCHAR](15) NOT NULL,
	);
GO

IF OBJECT_ID(N'Customer') IS NOT NULL
PRINT 'Table with customers [Customer] was create!'
GO

----------------------------------------------------------------------------
--- Table with ticket's customer. Customer has unique email and unique
-- passport customer, first name and last name.

CREATE TABLE [Ticket]
	([ticket_id] [INT] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	 [seat_id] [CHAR](3) NOT NULL CHECK (LEN([seat_id]) = 3 AND [seat_id] LIKE '[0-9][0-9][A-I]'),
	 [passport_ticket] [CHAR](10) NOT NULL CHECK(LEN([passport_ticket]) = 10),
	 [last_name] [VARCHAR](30) NOT NULL, 
	 [first_name] [VARCHAR](15) NOT NULL,
	 [passport_customer] [CHAR](10) NOT NULL 
						 FOREIGN KEY ([passport_customer]) 
							REFERENCES [Customer]([passport_customer])
						 ON UPDATE CASCADE
						 ON DELETE CASCADE,
	 [FID] [INT] NOT NULL FOREIGN KEY ([FID])
		   REFERENCES [Flight]([FID])
		   ON UPDATE CASCADE
		   ON DELETE CASCADE
	);
GO

IF OBJECT_ID(N'Ticket') IS NOT NULL
PRINT 'Table with tickets [Ticket] was created!'
GO

PRINT 'All table in db [Airport] was created!'
GO
