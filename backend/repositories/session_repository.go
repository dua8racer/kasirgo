package repositories

import (
	"kasirgo-backend/config"
	"kasirgo-backend/models"
	"time"
)

type SessionRepository struct{}

func NewSessionRepository() *SessionRepository {
	return &SessionRepository{}
}

func (r *SessionRepository) Create(session *models.Session) error {
	return config.DB.Create(session).Error
}

func (r *SessionRepository) FindByID(id string) (*models.Session, error) {
	var session models.Session
	err := config.DB.Preload("User").Preload("Transactions").First(&session, "id = ?", id).Error
	return &session, err
}

func (r *SessionRepository) FindActiveByUserID(userID string) (*models.Session, error) {
	var session models.Session
	err := config.DB.Where("user_id = ? AND status = ?", userID, "active").First(&session).Error
	return &session, err
}

func (r *SessionRepository) FindByStoreID(storeID string, limit int) ([]models.Session, error) {
	var sessions []models.Session
	err := config.DB.Preload("User").Where("store_id = ?", storeID).
		Order("created_at DESC").Limit(limit).Find(&sessions).Error
	return sessions, err
}

func (r *SessionRepository) Update(session *models.Session) error {
	return config.DB.Save(session).Error
}

func (r *SessionRepository) CloseSession(sessionID string, endCash float64, notes string) error {
	now := time.Now()
	return config.DB.Model(&models.Session{}).Where("id = ?", sessionID).
		Updates(map[string]interface{}{
			"status":    "closed",
			"end_cash":  endCash,
			"closed_at": &now,
		}).Error
}
