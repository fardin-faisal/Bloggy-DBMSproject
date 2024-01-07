import psycopg2

HOST = "localhost"
DB_NAME = "Bloggy"
USER = "postgres"
PASSWORD = "MyPG005"
PORT = 5432

con = psycopg2.connect(
    host=HOST,
    database=DB_NAME,
    user=USER,
    password=PASSWORD,
    port=PORT
)

cur = con.cursor()

Error = psycopg2.Error