package services

import (
	"encoding/json"
	"fmt"
	"kasirgo-backend/config"
	"kasirgo-backend/models"
	"kasirgo-backend/repositories"
	"strconv"
	"time"
)

type TransactionService struct {
	transRepo   *repositories.TransactionRepository
	productRepo *repositories.ProductRepository
	sessionRepo *repositories.SessionRepository
	paymentRepo *repositories.PaymentRepository
}

func NewTransactionService() *TransactionService {
	return &TransactionService{
		transRepo:   repositories.NewTransactionRepository(),
		productRepo: repositories.NewProductRepository(),
		sessionRepo: repositories.NewSessionRepository(),
		paymentRepo: repositories.NewPaymentRepository(),
	}
}

type CreateTransactionInput struct {
	SessionID      string                  `json:"session_id"`
	UserID         string                  `json:"user_id"`
	StoreID        string                  `json:"store_id"`
	CustomerName   string                  `json:"customer_name"`
	Items          []CreateTransactionItem `json:"items"`
	DiscountID     *string                 `json:"discount_id"`
	TaxID          *string                 `json:"tax_id"`
	PaymentMethod  string                  `json:"payment_method"`
	AmountReceived float64                 `json:"amount_received"`
	Notes          string                  `json:"notes"`
}

type CreateTransactionItem struct {
	ProductID string                   `json:"product_id"`
	Quantity  int                      `json:"quantity"`
	Modifiers []map[string]interface{} `json:"modifiers"`
	Notes     string                   `json:"notes"`
}

func (s *TransactionService) CreateTransaction(input CreateTransactionInput) (*models.Transaction, error) {
	// Generate queue number
	lastQueue, _ := s.transRepo.GetLastQueueNumber(input.StoreID, time.Now())
	lastNum, _ := strconv.Atoi(lastQueue)
	queueNumber := fmt.Sprintf("%04d", lastNum+1)

	// Calculate totals
	var subtotal float64
	var items []models.TransactionItem

	for _, item := range input.Items {
		product, err := s.productRepo.FindByID(item.ProductID)
		if err != nil {
			return nil, err
		}

		itemSubtotal := product.Price * float64(item.Quantity)

		// Add modifier prices
		for _, modifier := range item.Modifiers {
			if price, ok := modifier["price"].(float64); ok {
				itemSubtotal += price * float64(item.Quantity)
			}
		}

		modifiersJSON, _ := json.Marshal(item.Modifiers)

		items = append(items, models.TransactionItem{
			ProductID:   item.ProductID,
			ProductName: product.Name,
			Price:       product.Price,
			Quantity:    item.Quantity,
			Modifiers:   string(modifiersJSON),
			Notes:       item.Notes,
			Subtotal:    itemSubtotal,
		})

		subtotal += itemSubtotal

		// Update stock
		if product.Stock > 0 {
			newStock := product.Stock - item.Quantity
			s.productRepo.UpdateStock(product.ID, newStock)
		}
	}

	// Handle tax - IMPORTANT: Ensure nil handling
	var taxAmount float64
	var taxID *string = nil // Explicitly set to nil

	// Check if tax_id is provided and not empty
	if input.TaxID != nil && *input.TaxID != "" {
		// Verify the tax exists
		var tax models.Tax
		if err := config.DB.First(&tax, "id = ?", *input.TaxID).Error; err == nil {
			taxID = &tax.ID
			taxAmount = subtotal * (tax.Percentage / 100)
		} else {
			// Tax ID provided but not found - use default
			fmt.Printf("Warning: Tax ID %s not found, using default\n", *input.TaxID)
		}
	}

	// If no valid tax_id yet, try to find default active tax
	if taxID == nil {
		var tax models.Tax
		if err := config.DB.First(&tax, "is_active = ?", true).Error; err == nil {
			taxID = &tax.ID
			taxAmount = subtotal * (tax.Percentage / 100)
		}
		// If still no tax found, taxID remains nil
	}

	// Calculate discount
	var discountAmount float64
	var discountID *string = nil // Explicitly set to nil

	if input.DiscountID != nil && *input.DiscountID != "" {
		var discount models.Discount
		if err := config.DB.First(&discount, "id = ?", *input.DiscountID).Error; err == nil {
			discountID = &discount.ID
			if discount.Type == "percentage" {
				discountAmount = subtotal * (discount.Value / 100)
				if discount.MaxDiscount > 0 && discountAmount > discount.MaxDiscount {
					discountAmount = discount.MaxDiscount
				}
			} else if discount.Type == "fixed" {
				discountAmount = discount.Value
			}
		}
	}

	total := subtotal + taxAmount - discountAmount

	// Create transaction with explicit field setting
	transaction := &models.Transaction{
		StoreID:        input.StoreID,
		SessionID:      input.SessionID,
		UserID:         input.UserID,
		QueueNumber:    queueNumber,
		CustomerName:   input.CustomerName,
		Subtotal:       subtotal,
		DiscountAmount: discountAmount,
		TaxAmount:      taxAmount,
		Total:          total,
		Status:         "completed",
		Notes:          input.Notes,
		Items:          items,
	}

	// Only set IDs if they are not nil
	if discountID != nil {
		transaction.DiscountID = discountID
	}
	if taxID != nil {
		transaction.TaxID = taxID
	}

	// Create payment
	change := float64(0)
	if input.PaymentMethod == "cash" {
		change = input.AmountReceived - total
	}

	transaction.Payment = models.Payment{
		Method:         input.PaymentMethod,
		Amount:         total,
		AmountReceived: input.AmountReceived,
		Change:         change,
		Status:         "success",
	}

	// Debug log
	fmt.Printf("Creating transaction with TaxID: %v\n", transaction.TaxID)

	err := s.transRepo.Create(transaction)
	if err != nil {
		fmt.Printf("Error creating transaction: %v\n", err)
		return nil, err
	}

	// Update session totals
	session, _ := s.sessionRepo.FindByID(input.SessionID)
	session.TotalSales += total
	if input.PaymentMethod == "cash" {
		session.TotalCashSales += total
	} else {
		session.TotalNonCash += total
	}
	s.sessionRepo.Update(session)

	return transaction, nil
}

func (s *TransactionService) GetTransactionByID(id string) (*models.Transaction, error) {
	return s.transRepo.FindByID(id)
}

func (s *TransactionService) GetTransactionsBySession(sessionID string) ([]models.Transaction, error) {
	return s.transRepo.FindBySessionID(sessionID)
}

func (s *TransactionService) GetTransactionsByDateRange(storeID string, start, end time.Time) ([]models.Transaction, error) {
	return s.transRepo.FindByDateRange(storeID, start, end)
}
