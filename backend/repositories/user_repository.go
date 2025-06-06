package repositories

import (
	"kasirgo-backend/config"
	"kasirgo-backend/models"
)

type UserRepository struct{}

func NewUserRepository() *UserRepository {
	return &UserRepository{}
}

func (r *UserRepository) Create(user *models.User) error {
	return config.DB.Create(user).Error
}

func (r *UserRepository) FindByID(id string) (*models.User, error) {
	var user models.User
	err := config.DB.Preload("Store").First(&user, "id = ?", id).Error
	return &user, err
}

func (r *UserRepository) FindByUsername(username string) (*models.User, error) {
	var user models.User
	err := config.DB.Preload("Store").First(&user, "username = ?", username).Error
	return &user, err
}

func (r *UserRepository) FindByStoreID(storeID string) ([]models.User, error) {
	var users []models.User
	err := config.DB.Where("store_id = ?", storeID).Find(&users).Error
	return users, err
}

func (r *UserRepository) Update(user *models.User) error {
	return config.DB.Save(user).Error
}

func (r *UserRepository) Delete(id string) error {
	return config.DB.Delete(&models.User{}, "id = ?", id).Error
}
