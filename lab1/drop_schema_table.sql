USE Sales;
GO

IF OBJECT_ID('TestSH.Customers', 'U') IS NOT NULL
DROP TABLE Testsh.Customers
GO

IF SCHEMA_ID(N'TestSH') IS NOT NULL
DROP SCHEMA TestSH
GO

