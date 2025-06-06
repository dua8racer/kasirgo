package config

import (
	"fmt"
	"kasirgo-backend/models"
	"log"
	"os"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

func InitDB() {
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		getEnv("DB_USER", "root"),
		getEnv("DB_PASSWORD", ""),
		getEnv("DB_HOST", "localhost"),
		getEnv("DB_PORT", "3306"),
		getEnv("DB_NAME", "kasirgo_db"),
	)

	var err error
	DB, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	// Auto migrate models
	err = DB.AutoMigrate(
		&models.User{},
		&models.Store{},
		&models.Category{},
		&models.Product{},
		&models.ProductModifier{},
		&models.Transaction{},
		&models.TransactionItem{},
		&models.Payment{},
		&models.Session{},
		&models.SessionReport{},
		&models.Discount{},
		&models.Tax{},
	)

	if err != nil {
		log.Fatal("Failed to migrate database:", err)
	}

	log.Println("Database connected and migrated successfully")

	// Seed initial data
	seedInitialData()
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func seedInitialData() {
	// Seed default tax
	var taxCount int64
	DB.Model(&models.Tax{}).Count(&taxCount)
	if taxCount == 0 {
		tax := models.Tax{
			Name:       "PPN",
			Percentage: 11,
			IsActive:   true,
		}
		DB.Create(&tax)
	}
}
