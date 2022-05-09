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
		name VARCHAR(30)
	);

-- table with employees
CREATE TABLE
	IF NOT EXISTS Employee
	(
		employee_id SERIAL PRIMARY KEY,
		name VARCHAR(30) NOT NULL,
		position VARCHAR(30),
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
		skill VARCHAR(150),
		FOREIGN KEY(employee_id)
			REFERENCES Employee(employee_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
	);
	
CREATE TABLE
	IF NOT EXISTS Client
	(
		client_id SERIAL PRIMARY KEY,
		name VARCHAR(30) NOT NULL,
		address VARCHAR(70) DEFAULT 'Unknow address',
		employee_id INTEGER NOT NULL,
		phone VARCHAR(11) NOT NULL,
		FOREIGN KEY (employee_id)
			REFERENCES Employee(employee_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
	);
	
CREATE TABLE
	IF NOT EXISTS ClientEmployeeConn
	(
		client_id INTEGER NOT NULL,
		employee_id INTEGER NOT NULL,
		start_date DATE NOT NULL DEFAULT current_date,
		time_order TIME DEFAULT NULL,
		FOREIGN KEY (client_id)
			REFERENCES Client(client_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
		FOREIGN KEY (employee_id)
			REFERENCES Employee(employee_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
	);
