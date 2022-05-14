USE master;
GO

-- @@FETCH_STATUS отражает результаты последней инструкции FETCH,
-- выполненной в хранимой процедуре, а не результаты инструкции FETCH, 
-- выполненной до вызова хранимой процедуры.

IF DB_ID(N'Lab8DB') IS NOT NULL
DROP DATABASE [Lab8DB];
GO

CREATE DATABASE [Lab8DB]
	ON (NAME = Lab8DB_dat,
		FILENAME = 'D:\Учеба\Магистр\db\lab_8\Lab8DB.mdf',
		SIZE = 5MB,
		MAXSIZE = UNLIMITED,
		FILEGROWTH = 10%)

	LOG ON (NAME = Lab7DB_log,
			FILENAME = 'D:\Учеба\Магистр\db\lab_8\Lab8DB_log',
			SIZE = 5MB,
			MAXSIZE = 25MB,
			FILEGROWTH = 5MB);
GO

USE [Lab8DB];
GO

----------------------------------------------------------------------------

IF OBJECT_ID(N'Customer') IS NOT NULL
DROP TABLE [Customer];
GO

CREATE TABLE [Customer]
	([passport_customer] CHAR(10) NOT NULL
						 PRIMARY KEY 
						 CHECK (LEN([passport_customer]) = 10),
	 [email] VARCHAR(60) NOT NULL CHECK ([email] LIKE '%@%.%'),
	 [last_name] VARCHAR(30) NOT NULL, 
	 [first_name] VARCHAR(15) NOT NULL,
	);
GO

INSERT INTO
	[Customer]([passport_customer], [email], [last_name], [first_name])
VALUES
	('4820123456', 'kek@mail.ru', 'Ivan', 'Trenev'),
	('4917654321', 'cheburek@gmail.com', 'Andrew', 'Tkachenko'),
	('7822098890', 'hope@bk.ru', 'Nadya', 'Chaplinskya'),
	('4510567489', 'smile@hotmail.com', 'Daniil', 'Devyatkin');
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
	 FOREIGN KEY([passport_customer])
		REFERENCES [Customer]([passport_customer])
		ON DELETE CASCADE
	);
GO

INSERT INTO
	[Ticket]([seat_id], [passport_ticket], [last_name], [first_name], [passport_customer])
VALUES
	('03A', '4820123456', 'Trenev', 'Ivan', '4820123456'),
	('03B', '5420123456', 'Irkutina', 'Daria', '4820123456'),
	('25F', '4917654321', 'Tkachenko', 'Andrew', '4917654321'),
	('25E', '5320654321', 'Tkachenko', 'Maria', '4917654321'),
	('13B', '7822098890', 'Chaplinskya', 'Nadya', '7822098890'),
	('13C', '6719098890', 'Kupcov', 'Nikita', '7822098890'),
	('99D', '4510567489', 'Devyatkin', 'Daniil', '4510567489')
GO

----------------------------------------------------------------------------
 --Task [1] Создать хранимую процедуру, производящую выборку из некоторой таблицы 
 --и возвращающую результат выборки в виде курсора.

CREATE PROCEDURE [get_cursor_procedure_task1]
	@lprocedure_cursor CURSOR VARYING OUTPUT
AS
	SET @lprocedure_cursor = CURSOR FOR
		SELECT
			[seat_id], [last_name], [first_name]
		FROM
			[Ticket];
	OPEN @lprocedure_cursor;
GO

DECLARE @cursor_for_procedure CURSOR;
DECLARE @seat CHAR(3);
DECLARE @name VARCHAR(15);
DECLARE @lastname VARCHAR(30);

EXECUTE [get_cursor_procedure_task1]
	@lprocedure_cursor = @cursor_for_procedure OUTPUT;

FETCH NEXT FROM 
	@cursor_for_procedure 
INTO 
	@seat, @name, @lastname;

WHILE (@@FETCH_STATUS = 0)
BEGIN
	
	PRINT @seat + ' ' + @name + ' ' + @lastname

	FETCH NEXT FROM 
		@cursor_for_procedure 
	INTO 
		@seat, @name, @lastname;
END

PRINT ''
PRINT '############################'
PRINT ''

CLOSE @cursor_for_procedure;
DEALLOCATE @cursor_for_procedure;
GO

----------------------------------------------------------------------------
-- Task [2] Модифицировать хранимую процедуру п.1. таким образом, чтобы выборка 
-- осуществлялась с формированием столбца, значение которого формируется пользовательской функцией.

CREATE FUNCTION
	[full_name_function](@name VARCHAR(15), @lastname VARCHAR(30))
RETURNS 
	VARCHAR(45)
AS
	BEGIN
		RETURN @name + ' /-|-\ ' + @lastname
	END;
GO

CREATE PROCEDURE [get_cursor_procedure_task2]
	@lprocedure_cursor CURSOR VARYING OUTPUT
AS
	SET @lprocedure_cursor = CURSOR FOR
		SELECT
			[email], dbo.[full_name_function]([last_name], [first_name]) as fn
		FROM
			[Customer]
	OPEN @lprocedure_cursor;
GO

DECLARE @cursor CURSOR
DECLARE @email VARCHAR(60)
DECLARE @fullname VARCHAR(45)

EXECUTE [get_cursor_procedure_task2]
	@lprocedure_cursor = @cursor OUTPUT;

FETCH NEXT FROM
	@cursor
INTO
	@email, @fullname

WHILE (@@FETCH_STATUS = 0)
BEGIN
	
	PRINT @email + ' ' + @fullname

	FETCH NEXT FROM
		@cursor
	INTO
		@email, @fullname

END

CLOSE @cursor;
DEALLOCATE @cursor;
GO

PRINT ''
PRINT '############################'
PRINT ''
GO

----------------------------------------------------------------------------
-- Task [3] Создать хранимую процедуру, вызывающую процедуру п.1., осуществляющую прокрутку 
-- возвращаемого курсора и выводящую сообщения, сформированные из записей при 
-- выполнении условия, заданного еще одной пользовательской функцией.

CREATE FUNCTION [check_cond](@name VARCHAR(15))
RETURNS
	INT
AS
BEGIN
	DECLARE @result INT;
	IF @name = 'Ivan' OR @name = 'Andrew'
		SET @result = 1;
	ELSE
		SET @result = 0;

	RETURN @result;
END;
GO

CREATE PROCEDURE [procedure_call_procedure_task1]
AS
	DECLARE @cursor CURSOR
	DECLARE @seat CHAR(3);
	DECLARE @name VARCHAR(15);
	DECLARE @lastname VARCHAR(30);

	EXECUTE [get_cursor_procedure_task1]
		@lprocedure_cursor = @cursor OUTPUT;

	FETCH NEXT FROM
		@cursor
	INTO
		@seat, @lastname, @name

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		
		IF dbo.[check_cond](@name) = 1
			PRINT '_______________'

		PRINT @seat + ' ' + @lastname + ' ' +  @name

		FETCH NEXT FROM
			@cursor
		INTO
			@seat, @lastname, @name
	END

	CLOSE @cursor;
	DEALLOCATE @cursor;
GO

EXECUTE [procedure_call_procedure_task1];
GO

PRINT ''
PRINT '############################'
PRINT ''
GO

------------------------------------------------------------------------------
-- Task [4] Модифицировать хранимую процедуру п.2. таким образом, 
-- чтобы выборка формировалась с помощью табличной функции.

ALTER PROCEDURE [get_cursor_procedure_task2]
	@lprocedure_cursor CURSOR VARYING OUTPUT
AS
	SET @lprocedure_cursor = CURSOR FOR
		SELECT
			[passport_customer], COUNT([passport_customer])
		FROM
			[Ticket]
		GROUP BY
			[passport_customer]

	OPEN @lprocedure_cursor;		
GO

DECLARE @cursor CURSOR;
DECLARE @pass VARCHAR(10);
DECLARE @cnt INT;

EXECUTE [get_cursor_procedure_task2]
	@lprocedure_cursor = @cursor OUTPUT;

FETCH NEXT FROM
	@cursor
INTO
	@pass, @cnt;

WHILE (@@FETCH_STATUS = 0)
BEGIN
	
	PRINT @pass + ' <-> ' + CAST(@cnt AS CHAR(3))

	FETCH NEXT FROM
		@cursor
	INTO
		@pass, @cnt;
END

CLOSE @cursor;
DEALLOCATE @cursor;
------------------------------------------------------------------------------

DROP PROCEDURE [procedure_call_procedure_task1];
GO

DROP FUNCTION [check_cond];
GO

DROP FUNCTION [full_name_function];
GO

DROP PROCEDURE [get_cursor_procedure_task2];
GO

DROP PROCEDURE [get_cursor_procedure_task1];
GO

DROP TABLE [Ticket];
GO

DROP TABLE [Customer];
GO

USE master;
GO

DROP DATABASE [Lab8DB];
GO