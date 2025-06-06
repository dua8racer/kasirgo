// backend/simple_seed.go
package main

import (
	"fmt"
	"kasirgo-backend/config"
	"kasirgo-backend/models"
	"log"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

func main() {
	config.InitDB()

	fmt.Println("=== Simple Seeding (No Modifiers) ===")

	// Clean first
	fmt.Println("Cleaning database...")
	config.DB.Exec("SET FOREIGN_KEY_CHECKS = 0")
	config.DB.Exec("TRUNCATE TABLE product_modifiers")
	config.DB.Exec("TRUNCATE TABLE products")
	config.DB.Exec("TRUNCATE TABLE categories")
	config.DB.Exec("TRUNCATE TABLE users")
	config.DB.Exec("TRUNCATE TABLE stores")
	config.DB.Exec("TRUNCATE TABLE taxes")
	config.DB.Exec("SET FOREIGN_KEY_CHECKS = 1")

	// Create store
	store := models.Store{
		BaseModel: models.BaseModel{ID: uuid.New().String()},
		Name:      "KasirGo Demo Store",
		Address:   "Jl. Contoh No. 123, Jakarta",
		Phone:     "021-1234567",
	}
	if err := config.DB.Create(&store).Error; err != nil {
		log.Fatal("Failed to create store:", err)
	}
	fmt.Println("✓ Store created")

	// Create admin user
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte("admin123"), bcrypt.DefaultCost)
	admin := models.User{
		BaseModel: models.BaseModel{ID: uuid.New().String()},
		StoreID:   store.ID,
		Username:  "admin",
		Password:  string(hashedPassword),
		FullName:  "Administrator",
		Role:      "admin",
		IsActive:  true,
	}
	if err := config.DB.Create(&admin).Error; err != nil {
		log.Fatal("Failed to create admin:", err)
	}

	// Create kasir user
	hashedPassword, _ = bcrypt.GenerateFromPassword([]byte("kasir123"), bcrypt.DefaultCost)
	hashedPIN, _ := bcrypt.GenerateFromPassword([]byte("123456"), bcrypt.DefaultCost)
	kasir := models.User{
		BaseModel: models.BaseModel{ID: uuid.New().String()},
		StoreID:   store.ID,
		Username:  "kasir1",
		Password:  string(hashedPassword),
		PIN:       string(hashedPIN),
		FullName:  "Kasir 1",
		Role:      "cashier",
		IsActive:  true,
	}
	if err := config.DB.Create(&kasir).Error; err != nil {
		log.Fatal("Failed to create kasir:", err)
	}
	fmt.Println("✓ Users created")

	// Create tax
	tax := models.Tax{
		BaseModel:  models.BaseModel{ID: uuid.New().String()},
		Name:       "PPN",
		Percentage: 11,
		IsActive:   true,
	}
	if err := config.DB.Create(&tax).Error; err != nil {
		log.Fatal("Failed to create tax:", err)
	}
	fmt.Println("✓ Tax created")

	// Create categories
	cat1 := models.Category{
		BaseModel: models.BaseModel{ID: uuid.New().String()},
		StoreID:   store.ID,
		Name:      "Makanan",
		Order:     1,
		IsActive:  true,
	}
	cat2 := models.Category{
		BaseModel: models.BaseModel{ID: uuid.New().String()},
		StoreID:   store.ID,
		Name:      "Minuman",
		Order:     2,
		IsActive:  true,
	}

	config.DB.Create(&cat1)
	config.DB.Create(&cat2)
	fmt.Println("✓ Categories created")

	// Create products WITHOUT modifiers first
	products := []models.Product{
		{
			BaseModel:   models.BaseModel{ID: uuid.New().String()},
			StoreID:     store.ID,
			CategoryID:  cat1.ID,
			SKU:         "MKN001",
			Name:        "Nasi Goreng Spesial",
			Description: "Nasi goreng dengan telur, ayam, dan sayuran",
			Price:       25000,
			Stock:       100,
			MinStock:    10,
			IsActive:    true,
		},
		{
			BaseModel:   models.BaseModel{ID: uuid.New().String()},
			StoreID:     store.ID,
			CategoryID:  cat1.ID,
			SKU:         "MKN002",
			Name:        "Mie Ayam",
			Description: "Mie ayam dengan pangsit",
			Price:       20000,
			Stock:       100,
			MinStock:    10,
			IsActive:    true,
		},
		{
			BaseModel:   models.BaseModel{ID: uuid.New().String()},
			StoreID:     store.ID,
			CategoryID:  cat2.ID,
			SKU:         "MNM001",
			Name:        "Es Teh Manis",
			Description: "Teh manis dingin",
			Price:       5000,
			Stock:       200,
			MinStock:    20,
			IsActive:    true,
		},
		{
			BaseModel:   models.BaseModel{ID: uuid.New().String()},
			StoreID:     store.ID,
			CategoryID:  cat2.ID,
			SKU:         "MNM002",
			Name:        "Kopi Susu",
			Description: "Kopi dengan susu",
			Price:       15000,
			Stock:       150,
			MinStock:    15,
			IsActive:    true,
		},
	}

	for _, prod := range products {
		if err := config.DB.Create(&prod).Error; err != nil {
			log.Printf("Failed to create product %s: %v", prod.Name, err)
		}
	}
	fmt.Println("✓ Products created")

	fmt.Println("\n✅ Basic seeding completed successfully!")
	fmt.Println("\nYou can now login with:")
	fmt.Println("  Admin: admin / admin123")
	fmt.Println("  Kasir: kasir1 / kasir123 (PIN: 123456)")
	fmt.Println("\nNote: Product modifiers not included to avoid FK issues.")
	fmt.Println("You can add them manually through the admin panel.")
}
