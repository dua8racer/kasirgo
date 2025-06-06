package models

type Tax struct {
	BaseModel
	Name       string  `json:"name"`
	Percentage float64 `json:"percentage"`
	IsActive   bool    `gorm:"default:true" json:"is_active"`
}
