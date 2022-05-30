package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/microsoft/go-mssqldb"
	// "error"
)

var db *sql.DB

var (
	server   = "DESKTOP-TBDE4DB\\SQLEXPRESS;"
	port     = 1433
	user     = "DESKTOP-TBDE4DB\\Danya"
	password = ""
	database = "Airport"
)

func main() {

	var err error

	// Build connection string
	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s;",
		server, user, password, port, database)

	// open connect to db
	_, err = sql.Open("sqlserver", connString)

	// check error
	if err != nil {
		log.Fatal("Error creating connection pool: ", err.Error())
	}
}
