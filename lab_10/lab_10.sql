USE [Lab10DB];
GO

----------------------------------------------------------------------------
-- READ UNCOMMITTED LEVEL

BEGIN TRANSACTION
	INSERT INTO
		[Aircraft]
	VALUES
		('CHECK ISOLATION LEVEL �1'),
		('CHECK ISOLATION LEVEL �2'),
		('CHECK ISOLATION LEVEL �3'),
		('CHECK ISOLATION LEVEL �4');

	WAITFOR 
		DELAY '00:00:05'
ROLLBACK TRANSACTION
GO

----------------------------------------------------------------------------
-- READ COMMITTED LEVEL

BEGIN TRANSACTION
	WAITFOR 
		DELAY '00:00:05'
	UPDATE
		[Aircraft]
	SET
		[model] = 'UPDATE READ COMMITTED'
	WHERE 
		[aircraft_id] IN (1)
COMMIT TRANSACTION
GO

----------------------------------------------------------------------------
-- REPEATABLE READ LEVEL

BEGIN TRANSACTION
	WAITFOR
		DELAY '00:00:05'
	INSERT INTO
		[Aircraft]
	VALUES
		('REPEATABLE READ LEVEL')
COMMIT TRANSACTION
GO
----------------------------------------------------------------------------
-- SERIALIZABLE LEVEL

BEGIN TRANSACTION
	WAITFOR
		DELAY '00:00:05'
	INSERT INTO
		[Aircraft]
	VALUES
		('SERIALIZABLE LEVEL')
COMMIT TRANSACTION