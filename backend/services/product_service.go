package services

import (
	"kasirgo-backend/models"
	"kasirgo-backend/repositories"
)

type ProductService struct {
	productRepo  *repositories.ProductRepository
	categoryRepo *repositories.CategoryRepository
}

func NewProductService() *ProductService {
	return &ProductService{
		productRepo:  repositories.NewProductRepository(),
		categoryRepo: repositories.NewCategoryRepository(),
	}
}

func (s *ProductService) CreateProduct(product *models.Product) error {
	return s.productRepo.Create(product)
}

func (s *ProductService) GetProductByID(id string) (*models.Product, error) {
	return s.productRepo.FindByID(id)
}

func (s *ProductService) GetProductsBySKU(sku string) (*models.Product, error) {
	return s.productRepo.FindBySKU(sku)
}

func (s *ProductService) GetProductsByStore(storeID string, activeOnly bool) ([]models.Product, error) {
	return s.productRepo.FindByStoreID(storeID, activeOnly)
}

func (s *ProductService) GetProductsByCategory(categoryID string) ([]models.Product, error) {
	return s.productRepo.FindByCategoryID(categoryID)
}

func (s *ProductService) UpdateProduct(product *models.Product) error {
	return s.productRepo.Update(product)
}

func (s *ProductService) DeleteProduct(id string) error {
	return s.productRepo.Delete(id)
}
