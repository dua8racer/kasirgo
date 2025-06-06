package models

import (
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type User struct {
	BaseModel
	StoreID  string    `gorm:"type:char(36)" json:"store_id"`
	Store    Store     `gorm:"foreignKey:StoreID" json:"store"`
	Username string    `gorm:"uniqueIndex;not null" json:"username"`
	Password string    `gorm:"not null" json:"-"`
	PIN      string    `json:"-"`
	FullName string    `gorm:"not null" json:"full_name"`
	Role     string    `gorm:"not null" json:"role"` // admin, manager, cashier
	IsActive bool      `gorm:"default:true" json:"is_active"`
	Sessions []Session `gorm:"foreignKey:UserID" json:"sessions"`
}

func (u *User) BeforeCreate(tx *gorm.DB) error {
	u.BaseModel.BeforeCreate(tx)
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	u.Password = string(hashedPassword)

	if u.PIN != "" {
		hashedPIN, err := bcrypt.GenerateFromPassword([]byte(u.PIN), bcrypt.DefaultCost)
		if err != nil {
			return err
		}
		u.PIN = string(hashedPIN)
	}
	return nil
}

func (u *User) CheckPassword(password string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(password))
	return err == nil
}

func (u *User) CheckPIN(pin string) bool {
	if u.PIN == "" {
		return false
	}
	err := bcrypt.CompareHashAndPassword([]byte(u.PIN), []byte(pin))
	return err == nil
}
