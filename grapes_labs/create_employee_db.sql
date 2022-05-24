USE master;
GO

IF DB_ID(N'employee_db') IS NOT NULL
DROP DATABASE [employee_db];
GO

CREATE DATABASE [employee_db]
ON
	(NAME = employee_db_dat,
	 FILENAME = 'C:\Users\Danya\Desktop\db-practice-bmstu\grapes_labs\employee_db.mdf',
	 SIZE = 5MB,
	 MAXSIZE = UNLIMITED,
	 FILEGROWTH = 10%)
LOG ON
	(NAME = Lab10DB_log,
	 FILENAME = 'C:\Users\Danya\Desktop\db-practice-bmstu\grapes_labs\employee_db_log',
	 SIZE = 5MB,
	 MAXSIZE = 25MB,
	 FILEGROWTH = 5MB
	)
GO

USE [employee_db];
GO

DROP SEQUENCE
	IF EXISTS [client_seq];
GO

DROP SEQUENCE
	IF EXISTS [employee_seq];
GO

DROP TABLE
	IF EXISTS [EmployeeSkills];
GO

DROP TABLE
	IF EXISTS [ClientEmployeeConn];
GO

DROP TABLE
	IF EXISTS [Client];
GO

DROP TABLE
	IF EXISTS [Employee];
GO

DROP TABLE
	IF EXISTS [Department];
GO

----------------------------------------------------------------------------
-- table with departments
CREATE TABLE [Department]
	(
		[department_id] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
		[name] 		    VARCHAR(30)
	);
GO

SET IDENTITY_INSERT [Department] ON;
GO

----------------------------------------------------------------------------
-- table with employees
CREATE TABLE [Employee]
	(
		[employee_id]   INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
		[name] 			VARCHAR(30) NOT NULL,
		[position]  	VARCHAR(30),
		[department_id] INTEGER NOT NULL,
		FOREIGN KEY([department_id])
			REFERENCES Department([department_id])
			ON DELETE CASCADE
			ON UPDATE CASCADE
	);
GO

SET IDENTITY_INSERT [Employee].[employee_id] ON;
GO

-- table with employees skills
CREATE TABLE [EmployeeSkills]
	(
		[employee_id] INTEGER,
		[skill] 	  VARCHAR(15),
		FOREIGN KEY([employee_id])
			REFERENCES Employee([employee_id])
			ON UPDATE CASCADE
			ON DELETE CASCADE,
		PRIMARY KEY ([employee_id], [skill]) 	-- PK is compex value consist from employee_id and skill
	);
GO

CREATE TABLE [Client]
	(
		[client_id]     INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
		[name 	]		VARCHAR(40) NOT NULL,
		[address] 		VARCHAR(100) DEFAULT 'Unknow address',
		[contactPerson] VARCHAR(80) NOT NULL,
		[phone] 		VARCHAR(80) NOT NULL
	);
GO

CREATE TABLE [ClientEmployeeConn]
	(
		[client_id] 	INTEGER NOT NULL,
		[employee_id]	INTEGER NOT NULL,
		[start_date] 	DATE NOT NULL DEFAULT GETDATE(),
		[time_order] 	FLOAT DEFAULT NULL,
		FOREIGN KEY ([client_id])
			REFERENCES Client([client_id])
			ON UPDATE CASCADE
			ON DELETE CASCADE,
		FOREIGN KEY ([employee_id])
			REFERENCES Employee([employee_id])
			ON UPDATE CASCADE
			ON DELETE CASCADE
	);
GO
-- Заполняем таблицу для проверки корректности создания таблиц
-- и чтобы БД была инициализирована некоторыми значениями

-- Таблица с отделами
INSERT INTO
	[Department]([name])
VALUES
	('Dep_analit'),
	('Dep_prog'),
	('Dep_admin');

-- Таблица с сотрудниками
-- Псоледовательность для заполнения id сотрудника
CREATE SEQUENCE [employee_seq]
    START WITH 100  
    INCREMENT BY 1;
GO

INSERT INTO
	[Employee]([employee_id], [name], [position], [department_id])
VALUES
	(NEXT VALUE FOR employee_seq, 'Smit N.', 'Programmer', 2),
	(NEXT VALUE FOR employee_seq, 'Stone J.', 'Manager', 3),
	(NEXT VALUE FOR employee_seq, 'Asser M', 'Analyst', 1),
	(NEXT VALUE FOR employee_seq, 'Wood N.', 'Programmer', 2),
	(NEXT VALUE FOR employee_seq, 'Thomson L.', 'Programmer', 2);
GO

-- Таблица с навыками сотрудников
INSERT INTO
	[EmployeeSkills]([employee_id], [skill])
VALUES
	(101, 'Basic'),
	(103, 'Python'),
	(102, 'SQL'),
	(100, 'C++'),
	(100, 'Pascal'),
	(104, 'Delphi');
GO

-- Таблица с клиентами
CREATE SEQUENCE [client_seq]
	START WITH 100
	INCREMENT BY 1;
GO

INSERT INTO
	[Client]([client_id], [name], [address], [contactPerson], [phone])
VALUES
	(NEXT VALUE FOR client_seq, 'ACER', 'M. 12 st.', 'Nora', '112233445566'),
	(NEXT VALUE FOR client_seq, 'MTS', 'S.P.11 st', 'Lena', '665544332211'),
	(NEXT VALUE FOR client_seq, 'Dog', 'N.N 13 st.', 'Ivan', '123456123456'),
	(NEXT VALUE FOR client_seq, 'Cat', 'K. 14 st.', 'Petr', '654321123456');
GO

-- Таблица с взаимодействием клиента и работника
INSERT INTO
	[ClientEmployeeConn]([client_id], [employee_id], [start_date], [time_order])
VALUES
	(1100, 100,'2009-01-10', 120),
	(1101, 101, '2008-11-01', 10),
	(1102, 102, '2009-12-10', 70),
	(1103, 102, '2009-02-01', 100);
GO
	