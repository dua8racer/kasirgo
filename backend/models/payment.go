package models

type Payment struct {
	BaseModel
	TransactionID  string       `gorm:"type:char(36);uniqueIndex" json:"transaction_id"`
	Transaction    *Transaction `gorm:"foreignKey:TransactionID" json:"transaction"`
	Method         string       `json:"method"` // cash, qris, card, ewallet
	Amount         float64      `json:"amount"`
	AmountReceived float64      `json:"amount_received"`
	Change         float64      `json:"change"`
	Reference      string       `json:"reference"`                     // External payment reference
	Status         string       `gorm:"default:success" json:"status"` // pending, success, failed
}
