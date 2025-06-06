package repositories

import (
	"kasirgo-backend/config"
	"kasirgo-backend/models"
)

type CategoryRepository struct{}

func NewCategoryRepository() *CategoryRepository {
	return &CategoryRepository{}
}

func (r *CategoryRepository) Create(category *models.Category) error {
	return config.DB.Create(category).Error
}

func (r *CategoryRepository) FindByID(id string) (*models.Category, error) {
	var category models.Category
	err := config.DB.First(&category, "id = ?", id).Error
	return &category, err
}

func (r *CategoryRepository) FindByStoreID(storeID string) ([]models.Category, error) {
	var categories []models.Category
	err := config.DB.Where("store_id = ? AND is_active = ?", storeID, true).
		Order("`order` ASC").Find(&categories).Error
	return categories, err
}

func (r *CategoryRepository) Update(category *models.Category) error {
	return config.DB.Save(category).Error
}

func (r *CategoryRepository) Delete(id string) error {
	return config.DB.Delete(&models.Category{}, "id = ?", id).Error
}
