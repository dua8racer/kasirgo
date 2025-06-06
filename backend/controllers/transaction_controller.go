package controllers

import (
	"kasirgo-backend/services"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type TransactionController struct {
	transactionService *services.TransactionService
}

func NewTransactionController() *TransactionController {
	return &TransactionController{
		transactionService: services.NewTransactionService(),
	}
}

func (c *TransactionController) CreateTransaction(ctx *gin.Context) {
	var input services.CreateTransactionInput
	if err := ctx.ShouldBindJSON(&input); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	input.UserID = ctx.GetString("user_id")
	input.StoreID = ctx.GetString("store_id")

	transaction, err := c.transactionService.CreateTransaction(input)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusCreated, transaction)
}

func (c *TransactionController) GetTransaction(ctx *gin.Context) {
	id := ctx.Param("id")
	transaction, err := c.transactionService.GetTransactionByID(id)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Transaction not found"})
		return
	}

	ctx.JSON(http.StatusOK, transaction)
}

func (c *TransactionController) GetTransactionsBySession(ctx *gin.Context) {
	sessionID := ctx.Param("sessionId")
	transactions, err := c.transactionService.GetTransactionsBySession(sessionID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, transactions)
}

func (c *TransactionController) GetTransactionsByDateRange(ctx *gin.Context) {
	storeID := ctx.GetString("store_id")
	startDate := ctx.Query("start_date")
	endDate := ctx.Query("end_date")

	start, err := time.Parse("2006-01-02", startDate)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid start date"})
		return
	}

	end, err := time.Parse("2006-01-02", endDate)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid end date"})
		return
	}

	transactions, err := c.transactionService.GetTransactionsByDateRange(storeID, start, end)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, transactions)
}
