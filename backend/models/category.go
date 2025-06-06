package models

type Category struct {
	BaseModel
	StoreID  string    `gorm:"type:char(36)" json:"store_id"`
	Store    Store     `gorm:"foreignKey:StoreID" json:"store"`
	Name     string    `gorm:"not null" json:"name"`
	Icon     string    `json:"icon"`
	Order    int       `gorm:"default:0" json:"order"`
	IsActive bool      `gorm:"default:true" json:"is_active"`
	Products []Product `gorm:"foreignKey:CategoryID" json:"products"`
}
