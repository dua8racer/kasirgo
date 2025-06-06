package models

import "time"

type Session struct {
	BaseModel
	StoreID        string         `gorm:"type:char(36)" json:"store_id"`
	Store          Store          `gorm:"foreignKey:StoreID" json:"store"`
	UserID         string         `gorm:"type:char(36)" json:"user_id"`
	User           User           `gorm:"foreignKey:UserID" json:"user"`
	StartCash      float64        `json:"start_cash"`
	EndCash        float64        `json:"end_cash"`
	TotalSales     float64        `json:"total_sales"`
	TotalCashSales float64        `json:"total_cash_sales"`
	TotalNonCash   float64        `json:"total_non_cash"`
	Status         string         `gorm:"default:active" json:"status"` // active, closed
	StartedAt      time.Time      `json:"started_at"`
	ClosedAt       *time.Time     `json:"closed_at"`
	Transactions   []Transaction  `gorm:"foreignKey:SessionID" json:"transactions"`
	Report         *SessionReport `gorm:"foreignKey:SessionID" json:"report"`
}
