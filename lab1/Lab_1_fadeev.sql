USE master;
GO

IF DB_ID (N'Sales') IS NOT NULL
ALTER DATABASE Sales SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE Sales;
GO

CREATE DATABASE Sales
ON
( NAME = Sales_dat,
    FILENAME = '/home/victor/Documents/study/5sem/sql_database/lab1/saledat.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
LOG ON
( NAME = Sales_log,
    FILENAME = '/home/victor/Documents/study/5sem/sql_database/lab1/salelog.ldf',
    SIZE = 5MB,
    MAXSIZE = 25MB,
    FILEGROWTH = 5MB ) ;
GO

USE Sales;
GO

IF OBJECT_ID('Sales.Customers', 'U') IS NOT NULL
DROP TABLE Sales.Customers
GO
IF SCHEMA_ID (N'Sales') IS NOT NULL 
DROP SCHEMA Sales
GO

CREATE SCHEMA Sales
GO

-- Create the table in the specified schema
CREATE TABLE Sales.Customers
(
   CustomerId        INT    NOT NULL   PRIMARY KEY, -- primary key column
   Name      [NVARCHAR](50)  NOT NULL,
   Location  [NVARCHAR](50)  NOT NULL,
   Email     [NVARCHAR](50)  NOT NULL
);
GO

INSERT INTO Sales.Customers
   ([CustomerId],[Name],[Location],[Email])
VALUES
   ( 1, N'Orlando', N'Australia', N''),
   ( 2, N'Keith', N'India', N'keith0@adventure-works.com'),
   ( 3, N'Donna', N'Germany', N'donna0@adventure-works.com'),
   ( 4, N'Janet', N'United States', N'janet1@adventure-works.com')
GO


USE master;
GO

IF FILEGROUP_ID (N'SalesFG') IS NULL
ALTER DATABASE Sales
ADD FILEGROUP SalesFG;
GO

IF FILE_ID (N'sales1dat') IS NULL
ALTER DATABASE Sales
ADD FILE
(
    NAME = sales1dat,
    FILENAME = '/home/victor/Documents/study/5sem/sql_database/lab1/salesdat.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
) 
TO FILEGROUP SalesFG;
GO

ALTER DATABASE Sales
MODIFY FILEGROUP SalesFG DEFAULT;
GO


USE Sales;
GO

CREATE TABLE Products
(
     ID INT NOT NULL IDENTITY (1,1),
     name VARCHAR (100) NOT NULL,
     price int NOT NULL,
);
GO

ALTER DATABASE Sales
MODIFY FILEGROUP [PRIMARY] DEFAULT;
GO

CREATE UNIQUE CLUSTERED INDEX Products_ID ON dbo.Products(ID) ON [PRIMARY]
GO

ALTER DATABASE Sales
REMOVE FILE sales1dat;
GO
ALTER DATABASE Sales
REMOVE FILEGROUP SalesFG;
GO

CREATE SCHEMA SalesSchema;
GO
ALTER SCHEMA SalesSchema TRANSFER dbo.Products;
GO
DROP TABLE SalesSchema.Products;
GO
DROP SCHEMA SalesSchema;
GO

DROP TABLE Sales.Customers
GO