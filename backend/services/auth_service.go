package services

import (
	"errors"
	"kasirgo-backend/models"
	"kasirgo-backend/repositories"
	"kasirgo-backend/utils"
)

type AuthService struct {
	userRepo *repositories.UserRepository
}

func NewAuthService() *AuthService {
	return &AuthService{
		userRepo: repositories.NewUserRepository(),
	}
}

func (s *AuthService) Login(username, password string) (*models.User, string, error) {
	user, err := s.userRepo.FindByUsername(username)
	if err != nil {
		return nil, "", errors.New("invalid credentials")
	}

	if !user.CheckPassword(password) {
		return nil, "", errors.New("invalid credentials")
	}

	if !user.IsActive {
		return nil, "", errors.New("user is inactive")
	}

	token, err := utils.GenerateJWT(user.ID, user.Role)
	if err != nil {
		return nil, "", err
	}

	return user, token, nil
}

func (s *AuthService) LoginWithPIN(username, pin string) (*models.User, string, error) {
	user, err := s.userRepo.FindByUsername(username)
	if err != nil {
		return nil, "", errors.New("invalid credentials")
	}

	if !user.CheckPIN(pin) {
		return nil, "", errors.New("invalid PIN")
	}

	if !user.IsActive {
		return nil, "", errors.New("user is inactive")
	}

	token, err := utils.GenerateJWT(user.ID, user.Role)
	if err != nil {
		return nil, "", err
	}

	return user, token, nil
}
