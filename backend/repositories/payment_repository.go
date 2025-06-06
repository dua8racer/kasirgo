package repositories

import (
	"kasirgo-backend/config"
	"kasirgo-backend/models"
)

type PaymentRepository struct{}

func NewPaymentRepository() *PaymentRepository {
	return &PaymentRepository{}
}

func (r *PaymentRepository) Create(payment *models.Payment) error {
	return config.DB.Create(payment).Error
}

func (r *PaymentRepository) FindByTransactionID(transactionID string) (*models.Payment, error) {
	var payment models.Payment
	err := config.DB.First(&payment, "transaction_id = ?", transactionID).Error
	return &payment, err
}

func (r *PaymentRepository) Update(payment *models.Payment) error {
	return config.DB.Save(payment).Error
}
