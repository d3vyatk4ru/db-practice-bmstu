USE Lab10DB;
GO

DROP PROCEDURE IF EXISTS [GET_INFO];
GO

CREATE PROCEDURE [GET_INFO]
AS
BEGIN
	SELECT 
	[resource_type],		-- тип ресурса {DATABASE, FILE, OBJECT, PAGE, KEY, EXTENT, RID, APPLICATION, ALLOCATION_UNIT}
	[resource_database_id], -- идентификатор базы данных.
	CASE [request_mode]
		WHEN 
			N'S' THEN 'Shared lock (S)'
		WHEN
			N'X' THEN 'Exclusive lock (X)'
		WHEN
			N'U' THEN 'Update lock (U)'
		WHEN
			N'I' THEN 'Intent locks (I)'
		WHEN
			N'IX' THEN 'Intent exclusive (IX)'
		WHEN
			N'IS' THEN 'Intent shared (IS)'
		WHEN
			N'IU' THEN 'Intent update (IU) '
		ELSE N'Unknown'
	END AS [request_mode]			-- тип блокировки
FROM
	sys.dm_tran_locks;
END
GO

----------------------------------------------------------------------------
-- READ UNCOMMITTED LEVEL
-- ƒоступно: гр€зное чтение, невоспроизводимое чтение, фантомное чтение

SET TRANSACTION ISOLATION LEVEL
  READ UNCOMMITTED;
GO

BEGIN TRANSACTION
	SELECT * FROM [Aircraft];
	EXECUTE [GET_INFO];
COMMIT TRANSACTION
GO

----------------------------------------------------------------------------
-- READ COMMITTED LEVEL
-- ƒоступно: невоспроизводимое чтение, фантомное чтение

SET TRANSACTION ISOLATION LEVEL
  READ COMMITTED;
GO

BEGIN TRANSACTION
	SELECT * FROM [Aircraft];
	EXECUTE [GET_INFO];
COMMIT TRANSACTION
GO

----------------------------------------------------------------------------
-- REPEATABLE READ LEVEL
-- ƒоступно: фантомное чтение

SET TRANSACTION ISOLATION LEVEL
	REPEATABLE READ;
GO

BEGIN TRANSACTION
	SELECT * FROM [Aircraft];
	EXECUTE [GET_INFO];
COMMIT TRANSACTION

----------------------------------------------------------------------------
-- SERIALIZABLE LEVEL
-- ƒоступно: None

SET TRANSACTION ISOLATION LEVEL
	SERIALIZABLE;
GO

BEGIN TRANSACTION
	SELECT * FROM [Aircraft];
	EXECUTE [GET_INFO];
COMMIT TRANSACTION
