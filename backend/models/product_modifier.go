package models

type ProductModifier struct {
	BaseModel
	ProductID  string  `gorm:"type:char(36);not null" json:"product_id"`
	Product    Product `gorm:"foreignKey:ProductID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;" json:"product"`
	Name       string  `gorm:"not null" json:"name"`
	Options    string  `gorm:"type:text" json:"options"` // JSON array of {name: string, price: float}
	IsRequired bool    `gorm:"default:false" json:"is_required"`
	MaxSelect  int     `gorm:"default:1" json:"max_select"`
}
