package models

type Store struct {
	BaseModel
	Name          string `gorm:"not null" json:"name"`
	Address       string `json:"address"`
	Phone         string `json:"phone"`
	Logo          string `json:"logo"`
	ReceiptHeader string `json:"receipt_header"`
	ReceiptFooter string `json:"receipt_footer"`
	Users         []User `gorm:"foreignKey:StoreID" json:"users"`
}
