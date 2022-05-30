USE [Airport];
GO

----------------------------------------------------------------------------
-- Insert data to [Aircraft] table

INSERT INTO
	[Aircraft]
VALUES
	('Airbus A318'),
	('Boeing 727'),
	('Airbus A320'),
	('“уполев “у-204'),
	('Saab'),
	('»л-86')
GO

----------------------------------------------------------------------------
-- Insert data to [Aircraft] table

INSERT INTO [Flight]
	([flight_id], [departure_airport], [arrival_airport], [status], [amount], [aircraft_id], [date])
VALUES
	(999, 'ARH', 'KWG', 'DEP', 5, 1, '2022-13-05 10:15'),
	(998, 'VOG', 'BQS', 'DEP', 8, 1, '2022-15-05 20:00'),
	(997, 'KEJ', 'SVX', 'ARR', 2, 5, '2022-09-05 17:35'),
	(996, 'LPP', 'KDL', 'ARR', 5, 2, '2022-01-06 05:20'),
	(995, 'GYG', 'DEE', 'DEP', 7, 3, '2022-01-06 22:40')
GO

INSERT INTO [Flight]
	([flight_id])
VALUES
	(888),
	(777)
GO

INSERT INTO
	[Flight]([aircraft_id], [amount], [status], [arrival_airport], [departure_airport], [date], [flight_id])
SELECT
	[aircraft_id], 5, 'ARR', 'SVX', 'ARH', '2022-02-02 10:15:00.000', 994
FROM
	[Aircraft]
WHERE
	[aircraft_id] = 4;

SELECT * FROM [Flight];
GO

UPDATE [Flight]
SET
	[amount] = 10
WHERE
	[aircraft_id] = 4;
GO

DELETE FROM [Flight]
WHERE
	[aircraft_id] = 4;
GO

----------------------------------------------------------------------------
-- Insert data to [Customer] table
INSERT INTO
	[Customer]([passport_customer], [email], [last_name], [first_name])
VALUES
	('4820123456', 'kek@mail.ru', 'Ivan', 'Trenev'),
	('4917654321', 'cheburek@gmail.com', 'Andrew', 'Tkachenko'),
	('7822098890', 'hope@bk.ru', 'Nadya', 'Chaplinskya'),
	('4510567489', 'smile@hotmail.com', 'Daniil', 'Devyatkin');
GO

----------------------------------------------------------------------------
-- Insert data to [Ticket] table
INSERT INTO
	[Ticket]([seat_id], [passport_ticket], [last_name], [first_name], [passport_customer], [FID])
VALUES
	('03A', '4820123456', 'Trenev', 'Ivan', '4820123456', 1),
	('03B', '5420123456', 'Irkutina', 'Daria', '4820123456', 1),
	('25F', '4917654321', 'Tkachenko', 'Andrew', '4917654321', 2),
	('25E', '5320654321', 'Tkachenko', 'Maria', '4917654321', 2),
	('13B', '7822098890', 'Chaplinskya', 'Nadya', '7822098890', 3),
	('13C', '6719098890', 'Kupcov', 'Nikita', '7822098890', 3),
	('99D', '4510567489', 'Devyatkin', 'Daniil', '4510567489', 4),
	('00A', '0000000000', 'NoLastName', 'NoName', '4510567489', 7)
GO

SELECT * FROM [Flight];
GO

SELECT * FROM [Aircraft];
GO

SELECT * FROM [Customer];
GO

SELECT * FROM [Ticket];
GO