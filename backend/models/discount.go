package models

import "time"

type Discount struct {
	BaseModel
	StoreID     string    `gorm:"type:char(36)" json:"store_id"`
	Store       Store     `gorm:"foreignKey:StoreID" json:"store"`
	Code        string    `gorm:"uniqueIndex" json:"code"`
	Name        string    `json:"name"`
	Type        string    `json:"type"` // percentage, fixed
	Value       float64   `json:"value"`
	MinPurchase float64   `json:"min_purchase"`
	MaxDiscount float64   `json:"max_discount"`
	StartDate   time.Time `json:"start_date"`
	EndDate     time.Time `json:"end_date"`
	IsActive    bool      `gorm:"default:true" json:"is_active"`
}
