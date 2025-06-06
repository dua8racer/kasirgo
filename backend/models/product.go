package models

type Product struct {
	BaseModel
	StoreID     string            `gorm:"type:char(36)" json:"store_id"`
	Store       Store             `gorm:"foreignKey:StoreID" json:"store"`
	CategoryID  string            `gorm:"type:char(36)" json:"category_id"`
	Category    Category          `gorm:"foreignKey:CategoryID" json:"category"`
	SKU         string            `gorm:"uniqueIndex" json:"sku"`
	Name        string            `gorm:"not null" json:"name"`
	Description string            `json:"description"`
	Price       float64           `gorm:"not null" json:"price"`
	Image       string            `json:"image"`
	Stock       int               `json:"stock"`
	MinStock    int               `json:"min_stock"`
	IsActive    bool              `gorm:"default:true" json:"is_active"`
	Modifiers   []ProductModifier `gorm:"foreignKey:ProductID" json:"modifiers"`
}
