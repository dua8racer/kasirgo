package models

type TransactionItem struct {
	BaseModel
	TransactionID string      `gorm:"type:char(36)" json:"transaction_id"`
	Transaction   Transaction `gorm:"foreignKey:TransactionID" json:"transaction"`
	ProductID     string      `gorm:"type:char(36)" json:"product_id"`
	Product       Product     `gorm:"foreignKey:ProductID" json:"product"`
	ProductName   string      `json:"product_name"`
	Price         float64     `json:"price"`
	Quantity      int         `json:"quantity"`
	Modifiers     string      `gorm:"type:text" json:"modifiers"` // JSON string
	Notes         string      `json:"notes"`
	Subtotal      float64     `json:"subtotal"`
}
