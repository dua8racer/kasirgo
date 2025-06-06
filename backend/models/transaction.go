package models

type Transaction struct {
	BaseModel
	StoreID        string            `gorm:"type:char(36)" json:"store_id"`
	Store          Store             `gorm:"foreignKey:StoreID" json:"store"`
	SessionID      string            `gorm:"type:char(36)" json:"session_id"`
	Session        Session           `gorm:"foreignKey:SessionID" json:"session"`
	UserID         string            `gorm:"type:char(36)" json:"user_id"`
	User           User              `gorm:"foreignKey:UserID" json:"user"`
	QueueNumber    string            `json:"queue_number"`
	CustomerName   string            `json:"customer_name"`
	Subtotal       float64           `json:"subtotal"`
	DiscountID     *string           `gorm:"type:char(36)" json:"discount_id"`
	Discount       *Discount         `gorm:"foreignKey:DiscountID" json:"discount"`
	DiscountAmount float64           `json:"discount_amount"`
	TaxID          *string           `gorm:"type:char(36)" json:"tax_id"`
	Tax            *Tax              `gorm:"foreignKey:TaxID" json:"tax"`
	TaxAmount      float64           `json:"tax_amount"`
	Total          float64           `json:"total"`
	Status         string            `gorm:"default:completed" json:"status"` // pending, completed, cancelled
	Notes          string            `json:"notes"`
	Items          []TransactionItem `gorm:"foreignKey:TransactionID" json:"items"`
	Payment        Payment           `gorm:"foreignKey:TransactionID" json:"payment"`
}
