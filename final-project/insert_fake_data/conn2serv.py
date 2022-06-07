from typing import Tuple
import pyodbc
from  faker import Faker
import pandas as pd
from prettytable import PrettyTable


N_ROWS = 100

conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=DESKTOP-TBDE4DB\SQLEXPRESS;'
    'Database=Airport;'
    'Trusted_Connection=yes;'
)


def read_orders_info(conn: pyodbc.Connection) -> None:
    """ Show information about orders table """

    cursor = conn.cursor()

    cursor.execute('SELECT DISTINCT * FROM [Orders_info]')

    th  = [column[0] for column in cursor.description]

    table = PrettyTable(th)

    for row in cursor:
        table.add_row(row)

    print(table)

    cursor.close()

def read_tickets(conn: pyodbc.Connection, columns: Tuple = None) -> None:
    """ Show 'Ticket' table """

    cursor = conn.cursor()

    if columns is None:
        cursor.execute('SELECT * FROM [Ticket]')
    else:
        cursor.execute(f"SELECT [{'], ['.join(columns)}] FROM [Ticket]")

    th  = [column[0] for column in cursor.description]

    table = PrettyTable(th)

    for row in cursor:
        table.add_row(row)

    print(table)

    cursor.close()

def read_flight(conn: pyodbc.Connection, columns: Tuple = None) -> None:
    """ Show 'Flight' table """

    cursor = conn.cursor()

    if columns is None:
        cursor.execute('SELECT * FROM [Flight]')
    else:
        cursor.execute(f"SELECT [{'], ['.join(columns)}] FROM [Flight]")

    th  = [column[0] for column in cursor.description]

    table = PrettyTable(th)

    for row in cursor:
        table.add_row(row)

    print(table)

    cursor.close()

def read_customer(conn: pyodbc.Connection, columns: Tuple = None) -> None:
    """ Show 'Customer' table """

    cursor = conn.cursor()

    if columns is None:
        cursor.execute('SELECT * FROM [Customer]')
    else:
        cursor.execute(f"SELECT [{'], ['.join(columns)}] FROM [Customer]")

    th  = [column[0] for column in cursor.description]

    table = PrettyTable(th )

    for row in cursor:
        table.add_row(row)

    print(table)

    cursor.close()

def read_aircraft(conn: pyodbc.Connection, columns: Tuple = None) -> None:
    """ Show 'Aircraft' table """

    cursor = conn.cursor()

    if columns is None:
        cursor.execute('SELECT * FROM [Aircraft]')
    else:
        cursor.execute(f"SELECT [{'], ['.join(columns)}] FROM [Aircraft]")

    th = [column[0] for column in cursor.description]

    table = PrettyTable(th)

    for row in cursor:
        table.add_row(row)

    print(table)

    cursor.close()


def insert2customer(conn: pyodbc.Connection):
    """ Insert data to 'Customer' table """

    cursor = conn.cursor()

    cursor.execute(
        'INSERT INTO [Customer]([passport_customer], [email], [last_name], [first_name]) VALUES (?,?,?,?)',
        '1234567890', 'aa@mail.com', 'Semen', 'Slepakov',
    )

    conn.commit()
    cursor.close()


if __name__ == '__main__':

    read_orders_info(conn)

    conn.close()
