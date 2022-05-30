import pyodbc
from  faker import Faker
import pandas as pd

fak

N_ROWS = 100

conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=DESKTOP-TBDE4DB\SQLEXPRESS;'
    'Database=Airport;'
    'Trusted_Connection=yes;'
)


def show_customer(conn: pyodbc.Connection) -> None:
    """ Show 'Customer' table """

    cursor = conn.cursor()

    cursor.execute('SELECT * FROM [Customer]')

    columns = [column[0] for column in cursor.description]

    print(columns)

    for row in cursor:
        print(row)

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

    # insert2customer(conn)

    # show_customer(conn)

    # conn.close()

    for _ in 
