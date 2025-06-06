package routes

import (
	"kasirgo-backend/controllers"
	"kasirgo-backend/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	// Controllers
	authController := controllers.NewAuthController()
	productController := controllers.NewProductController()
	transactionController := controllers.NewTransactionController()
	sessionController := controllers.NewSessionController()

	// Public routes
	public := r.Group("/api/v1")
	{
		public.POST("/auth/login", authController.Login)
	}

	// Protected routes
	protected := r.Group("/api/v1")
	protected.Use(middleware.AuthMiddleware())
	{
		// Products
		protected.POST("/products", productController.CreateProduct)
		protected.GET("/products/:id", productController.GetProduct)
		protected.GET("/products", productController.GetProductsByStore)
		protected.GET("/products/sku", productController.GetProductsBySKU)
		protected.GET("/categories/:categoryId/products", productController.GetProductsByCategory)
		protected.PUT("/products/:id", productController.UpdateProduct)
		protected.DELETE("/products/:id", productController.DeleteProduct)

		// Transactions
		protected.POST("/transactions", transactionController.CreateTransaction)
		protected.GET("/transactions/:id", transactionController.GetTransaction)
		protected.GET("/sessions/:sessionId/transactions", transactionController.GetTransactionsBySession)
		protected.GET("/transactions", transactionController.GetTransactionsByDateRange)

		// Sessions
		protected.POST("/sessions/start", sessionController.StartSession)
		protected.GET("/sessions/active", sessionController.GetActiveSession)
		protected.POST("/sessions/:id/close", sessionController.CloseSession)
	}
}
