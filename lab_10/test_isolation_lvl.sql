USE Lab10DB;
GO

----------------------------------------------------------------------------
-- READ UNCOMMITTED LEVEL

SET TRANSACTION ISOLATION LEVEL
  READ UNCOMMITTED;
  --READ COMMITTED;
  --REPEATABLE READ;
  --SERIALIZABLE;
GO

BEGIN TRANSACTION
SELECT * FROM [Aircraft];
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
COMMIT TRANSACTION
GO