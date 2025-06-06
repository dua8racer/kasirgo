package repositories

import (
	"kasirgo-backend/config"
	"kasirgo-backend/models"
)

type ProductRepository struct{}

func NewProductRepository() *ProductRepository {
	return &ProductRepository{}
}

func (r *ProductRepository) Create(product *models.Product) error {
	return config.DB.Create(product).Error
}

func (r *ProductRepository) FindByID(id string) (*models.Product, error) {
	var product models.Product
	err := config.DB.Preload("Category").Preload("Modifiers").First(&product, "id = ?", id).Error
	return &product, err
}

func (r *ProductRepository) FindBySKU(sku string) (*models.Product, error) {
	var product models.Product
	err := config.DB.Preload("Category").Preload("Modifiers").First(&product, "sku = ?", sku).Error
	return &product, err
}

func (r *ProductRepository) FindByStoreID(storeID string, active bool) ([]models.Product, error) {
	var products []models.Product
	query := config.DB.Preload("Category").Preload("Modifiers").Where("store_id = ?", storeID)
	if active {
		query = query.Where("is_active = ?", true)
	}
	err := query.Find(&products).Error
	return products, err
}

func (r *ProductRepository) FindByCategoryID(categoryID string) ([]models.Product, error) {
	var products []models.Product
	err := config.DB.Preload("Modifiers").Where("category_id = ? AND is_active = ?", categoryID, true).Find(&products).Error
	return products, err
}

func (r *ProductRepository) Update(product *models.Product) error {
	return config.DB.Save(product).Error
}

func (r *ProductRepository) UpdateStock(productID string, quantity int) error {
	return config.DB.Model(&models.Product{}).Where("id = ?", productID).Update("stock", quantity).Error
}

func (r *ProductRepository) Delete(id string) error {
	return config.DB.Delete(&models.Product{}, "id = ?", id).Error
}
