USE master;
GO
IF DB_ID (N'Sales') IS NOT NULL
DROP DATABASE [Sales];
GO
CREATE DATABASE [Sales]
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