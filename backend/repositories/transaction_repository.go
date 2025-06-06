package repositories

import (
	"kasirgo-backend/config"
	"kasirgo-backend/models"
	"time"
)

type TransactionRepository struct{}

func NewTransactionRepository() *TransactionRepository {
	return &TransactionRepository{}
}

func (r *TransactionRepository) Create(transaction *models.Transaction) error {
	return config.DB.Create(transaction).Error
}

func (r *TransactionRepository) FindByID(id string) (*models.Transaction, error) {
	var transaction models.Transaction
	err := config.DB.Preload("User").Preload("Items.Product").Preload("Payment").
		Preload("Discount").Preload("Tax").First(&transaction, "id = ?", id).Error
	return &transaction, err
}

func (r *TransactionRepository) FindBySessionID(sessionID string) ([]models.Transaction, error) {
	var transactions []models.Transaction
	err := config.DB.Preload("Items").Preload("Payment").
		Where("session_id = ?", sessionID).Find(&transactions).Error
	return transactions, err
}

func (r *TransactionRepository) FindByDateRange(storeID string, start, end time.Time) ([]models.Transaction, error) {
	var transactions []models.Transaction
	err := config.DB.Preload("User").Preload("Items").Preload("Payment").
		Where("store_id = ? AND created_at BETWEEN ? AND ?", storeID, start, end).
		Find(&transactions).Error
	return transactions, err
}

func (r *TransactionRepository) GetLastQueueNumber(storeID string, date time.Time) (string, error) {
	var transaction models.Transaction
	startOfDay := time.Date(date.Year(), date.Month(), date.Day(), 0, 0, 0, 0, date.Location())
	endOfDay := startOfDay.Add(24 * time.Hour)

	err := config.DB.Where("store_id = ? AND created_at BETWEEN ? AND ?", storeID, startOfDay, endOfDay).
		Order("created_at DESC").First(&transaction).Error

	if err != nil {
		return "0", nil
	}
	return transaction.QueueNumber, nil
}

func (r *TransactionRepository) Update(transaction *models.Transaction) error {
	return config.DB.Save(transaction).Error
}
