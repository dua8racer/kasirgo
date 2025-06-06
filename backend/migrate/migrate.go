package main

import (
	"fmt"
	"kasirgo-backend/config"
	"kasirgo-backend/models"
	"log"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("Usage: go run migrate.go [up|down]")
	}

	config.InitDB()

	switch os.Args[1] {
	case "up":
		migrate()
	case "down":
		rollback()
	default:
		log.Fatal("Invalid command. Use 'up' or 'down'")
	}
}

func migrate() {
	fmt.Println("Running migrations...")

	err := config.DB.AutoMigrate(
		&models.Store{},
		&models.User{},
		&models.Category{},
		&models.Product{},
		&models.ProductModifier{},
		&models.Tax{},
		&models.Discount{},
		&models.Session{},
		&models.Transaction{},
		&models.TransactionItem{},
		&models.Payment{},
		&models.SessionReport{},
	)

	if err != nil {
		log.Fatal("Migration failed:", err)
	}

	fmt.Println("✅ Migrations completed successfully!")
}

func rollback() {
	fmt.Println("Rolling back migrations...")

	// Drop tables in reverse order to handle foreign key constraints
	tables := []interface{}{
		&models.SessionReport{},
		&models.Payment{},
		&models.TransactionItem{},
		&models.Transaction{},
		&models.Session{},
		&models.Discount{},
		&models.Tax{},
		&models.ProductModifier{},
		&models.Product{},
		&models.Category{},
		&models.User{},
		&models.Store{},
	}

	for _, table := range tables {
		if err := config.DB.Migrator().DropTable(table); err != nil {
			log.Printf("Failed to drop table: %v", err)
		}
	}

	fmt.Println("✅ Rollback completed!")
}
