package main

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"path/filepath"

	_ "github.com/microsoft/go-mssqldb"
	// "error"
)

var db *sql.DB

var (
	server   = filepath.Join("DESKTOP-TBDE4DB", "SQLEXPRESS")
	port     = 1433
	user     = filepath.Join("DESKTOP-TBDE4DB", "Danya")
	password = ""
	database = "Airport"
)

func main() {

	var err error

	// Build connection string
	cfg := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s;",
		server, user, password, port, database)

	// open connect to db
	_, err = sql.Open("sqlserver", cfg)

	// check error
	if err != nil {
		log.Fatal("Error creating connection pool: ", err.Error())
	}

	ctx := context.Background()
	err = db.PingContext(ctx)

	if err != nil {
		log.Fatal(err.Error())
	}

	fmt.Printf("Connected!\n")

	ReadAirCraft()
}

// Insert data to AirCraft table
func InsertIntoAircraft(model string) (int64, error) {

	ctx := context.Background()
	var err error

	// check db on exist
	if db == nil {
		err = errors.New("CreateAircraft: db is nil!")
		return -1, err
	}

	err = db.PingContext(ctx)

	// Check if database is alive.
	if err == nil {
		return -1, err
	}

	// Create query
	query := `
		INSERT INTO
			[Aircraft](model)
		VALUES
			(@model);
	`

	stmt, err := db.Prepare(query)

	if err != nil {
		return -1, err
	}

	defer stmt.Close()

	row := stmt.QueryRowContext(
		ctx,
		sql.Named("model", model))

	var aircraft_id int64

	err = row.Scan(&aircraft_id)

	if err != nil {
		return -1, err
	}

	return aircraft_id, nil
}

// Read data from AirCraft table
func ReadAirCraft() (int, error) {

	ctx := context.Background()

	err := db.PingContext(ctx)

	if err != nil {
		return -1, err
	}

	query := fmt.Sprintf("SELECT [model] FROM [Aircraft]")

	// execute query
	rows, err := db.QueryContext(ctx, query)

	if err != nil {
		return -1, err
	}

	var count int

	for rows.Next() {

		var model string

		err := rows.Scan(&model)

		if err != nil {
			return -1, err
		}

		fmt.Printf("model: %s", model)
		count++
	}

	return count, err
}

func ReadOrdersInfo() (int, error) {

	ctx := context.Background()

	err := db.PingContext(ctx)

	if err == nil {
		return -1, err
	}

	query := fmt.Sprintf("SELECT DISTINCT * FROM [Orders_info]")

	// execute query
	rows, err := db.QueryContext(ctx, query)

	if err != nil {
		return -1, err
	}

	defer rows.Close()

	var count int

	for rows.Next() {

		var rowQuery string

		// Get values from row.
		err := rows.Scan(&rowQuery)

		if err != nil {
			return -1, err
		}

		fmt.Printf(rowQuery)
		count++
	}

	return count, nil
}
