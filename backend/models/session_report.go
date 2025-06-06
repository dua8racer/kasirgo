package models

type SessionReport struct {
	BaseModel
	SessionID     string  `gorm:"type:char(36);uniqueIndex" json:"session_id"`
	Session       Session `gorm:"foreignKey:SessionID" json:"session"`
	TotalTrans    int     `json:"total_transactions"`
	TotalItems    int     `json:"total_items"`
	CashTrans     int     `json:"cash_transactions"`
	NonCashTrans  int     `json:"non_cash_transactions"`
	TotalDiscount float64 `json:"total_discount"`
	TotalTax      float64 `json:"total_tax"`
	ExpectedCash  float64 `json:"expected_cash"`
	ActualCash    float64 `json:"actual_cash"`
	Difference    float64 `json:"difference"`
	Notes         string  `json:"notes"`
}
