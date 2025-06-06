package services

import (
	"errors"
	"kasirgo-backend/models"
	"kasirgo-backend/repositories"
)

type SessionService struct {
	sessionRepo     *repositories.SessionRepository
	transactionRepo *repositories.TransactionRepository
}

func NewSessionService() *SessionService {
	return &SessionService{
		sessionRepo:     repositories.NewSessionRepository(),
		transactionRepo: repositories.NewTransactionRepository(),
	}
}

func (s *SessionService) StartSession(session *models.Session) (*models.Session, error) {
	// Check if user already has active session
	activeSession, _ := s.sessionRepo.FindActiveByUserID(session.UserID)
	if activeSession != nil && activeSession.ID != "" {
		return nil, errors.New("user already has an active session")
	}

	err := s.sessionRepo.Create(session)
	if err != nil {
		return nil, err
	}

	return session, nil
}

func (s *SessionService) GetActiveSession(userID string) (*models.Session, error) {
	return s.sessionRepo.FindActiveByUserID(userID)
}

func (s *SessionService) CloseSession(sessionID string, endCash float64, notes string) (*models.SessionReport, error) {
	session, err := s.sessionRepo.FindByID(sessionID)
	if err != nil {
		return nil, err
	}

	if session.Status != "active" {
		return nil, errors.New("session is already closed")
	}

	// Get all transactions for this session
	transactions, err := s.transactionRepo.FindBySessionID(sessionID)
	if err != nil {
		return nil, err
	}

	// Calculate report data
	var totalTransactions, totalItems, cashTransactions, nonCashTransactions int
	var totalDiscount, totalTax float64

	for _, trans := range transactions {
		totalTransactions++
		totalItems += len(trans.Items)
		totalDiscount += trans.DiscountAmount
		totalTax += trans.TaxAmount

		if trans.Payment.Method == "cash" {
			cashTransactions++
		} else {
			nonCashTransactions++
		}
	}

	expectedCash := session.StartCash + session.TotalCashSales
	difference := endCash - expectedCash

	// Create session report
	report := &models.SessionReport{
		SessionID:     sessionID,
		TotalTrans:    totalTransactions,
		TotalItems:    totalItems,
		CashTrans:     cashTransactions,
		NonCashTrans:  nonCashTransactions,
		TotalDiscount: totalDiscount,
		TotalTax:      totalTax,
		ExpectedCash:  expectedCash,
		ActualCash:    endCash,
		Difference:    difference,
		Notes:         notes,
	}

	// Close session
	err = s.sessionRepo.CloseSession(sessionID, endCash, notes)
	if err != nil {
		return nil, err
	}

	return report, nil
}
