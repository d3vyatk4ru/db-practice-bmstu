
CREATE SCHEMA SalesSchema;
GO
ALTER SCHEMA SalesSchema TRANSFER Sales.Products;
GO
DROP TABLE SalesSchema.Products;
GO
DROP SCHEMA SalesSchema;
GO

DROP TABLE Sales.Customers
GO