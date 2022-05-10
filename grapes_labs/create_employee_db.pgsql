DROP SEQUENCE
	IF EXISTS client_seq;

DROP SEQUENCE
	IF EXISTS employee_seq;

DROP TABLE
	IF EXISTS EmployeeSkills;

DROP TABLE
	IF EXISTS ClientEmployeeConn;

DROP TABLE
	IF EXISTS Client;
	
DROP TABLE
	IF EXISTS Employee;
	
DROP TABLE
	IF EXISTS Department;

-- table with departments
CREATE TABLE
	IF NOT EXISTS Department
	(
		department_id SERIAL PRIMARY KEY,
		name 		  VARCHAR(30)
	);

-- table with employees

CREATE TABLE
	IF NOT EXISTS Employee
	(
		employee_id   SERIAL PRIMARY KEY,
		name 		  VARCHAR(30) NOT NULL,
		position  	  VARCHAR(30),
		department_id INTEGER NOT NULL,
		FOREIGN KEY(department_id)
			REFERENCES Department(department_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
	);

-- table with employees skills

CREATE TABLE
	IF NOT EXISTS EmployeeSkills
	(
		employee_id INTEGER,
		skill 		VARCHAR(15),
		FOREIGN KEY(employee_id)
			REFERENCES Employee(employee_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
		PRIMARY KEY (employee_id, skill) 	-- PK is compex value consist from employee_id and skill
	);
	
CREATE TABLE
	IF NOT EXISTS Client
	(
		client_id     SERIAL PRIMARY KEY,
		name 		  VARCHAR(40) NOT NULL,
		address 	  VARCHAR(100) DEFAULT 'Unknow address',
		contactPerson VARCHAR(80) NOT NULL,
		phone 		  VARCHAR(80) NOT NULL
	);
	
CREATE TABLE
	IF NOT EXISTS ClientEmployeeConn
	(
		client_id 	INTEGER NOT NULL,
		employee_id INTEGER NOT NULL,
		start_date 	DATE NOT NULL DEFAULT current_date,
		time_order 	FLOAT DEFAULT NULL,
		FOREIGN KEY (client_id)
			REFERENCES Client(client_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
		FOREIGN KEY (employee_id)
			REFERENCES Employee(employee_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
	);
	
-- Заполняем таблицу для проверки корректности создания таблиц
-- и чтобы БД была инициализирована некоторыми значениями

-- Таблица с отделами
INSERT INTO
	Department(name)
VALUES
	('Dep_analit'),
	('Dep_prog'),
	('Dep_admin');

-- Таблица с сотрудниками
-- Псоледовательность для заполнения id сотрудника
CREATE SEQUENCE employee_seq
  start 100
  increment 1;

INSERT INTO
	Employee(employee_id, name, position, department_id)
VALUES
	(nextval('employee_seq'), 'Smit N.', 'Programmer', 2),
	(nextval('employee_seq'), 'Stone J.', 'Manager', 3),
	(nextval('employee_seq'), 'Asser M', 'Analyst', 1),
	(nextval('employee_seq'), 'Wood N.', 'Programmer', 2),
	(nextval('employee_seq'), 'Thomson L.', 'Programmer', 2);

-- Таблица с навыками сотрудников
INSERT INTO
	EmployeeSkills(employee_id, skill)
VALUES
	(101, 'Basic'),
	(103, 'Python'),
	(102, 'SQL'),
	(100, 'C++'),
	(100, 'Pascal'),
	(104, 'Delphi');
	
-- Таблица с клиентами
CREATE SEQUENCE client_seq
	start 1100
	increment 1;

INSERT INTO
	Client(client_id, name, address, contactPerson, phone)
VALUES
	(nextval('client_seq'), 'ACER', 'M. 12 st.', 'Nora', '112233445566'),
	(nextval('client_seq'), 'MTS', 'S.P.11 st', 'Lena', '665544332211'),
	(nextval('client_seq'), 'Dog', 'N.N 13 st.', 'Ivan', '123456123456'),
	(nextval('client_seq'), 'Cat', 'K. 14 st.', 'Petr', '654321123456');
	
-- Таблица с взаимодействием клиента и работника
INSERT INTO
	ClientEmployeeConn(client_id, employee_id, start_date, time_order)
VALUES
	(1100, 100, DATE('2009-01-10'), 120),
	(1101, 101, DATE('2008-11-01'), 10),
	(1102, 102, DATE('2009-12-10'), 70),
	(1103, 102, DATE('2009-02-01'), 100);

	