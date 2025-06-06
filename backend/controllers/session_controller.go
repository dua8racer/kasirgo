package controllers

import (
	"kasirgo-backend/models"
	"kasirgo-backend/services"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type SessionController struct {
	sessionService *services.SessionService
}

func NewSessionController() *SessionController {
	return &SessionController{
		sessionService: services.NewSessionService(),
	}
}

type StartSessionRequest struct {
	StartCash float64 `json:"start_cash" binding:"required"`
}

type CloseSessionRequest struct {
	EndCash float64 `json:"end_cash" binding:"required"`
	Notes   string  `json:"notes"`
}

func (c *SessionController) StartSession(ctx *gin.Context) {
	var req StartSessionRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := ctx.GetString("user_id")
	storeID := ctx.GetString("store_id")

	session := &models.Session{
		StoreID:   storeID,
		UserID:    userID,
		StartCash: req.StartCash,
		Status:    "active",
		StartedAt: time.Now(),
	}

	createdSession, err := c.sessionService.StartSession(session)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusCreated, createdSession)
}

func (c *SessionController) GetActiveSession(ctx *gin.Context) {
	userID := ctx.GetString("user_id")
	session, err := c.sessionService.GetActiveSession(userID)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "No active session found"})
		return
	}

	ctx.JSON(http.StatusOK, session)
}

func (c *SessionController) CloseSession(ctx *gin.Context) {
	id := ctx.Param("id")
	var req CloseSessionRequest

	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	report, err := c.sessionService.CloseSession(id, req.EndCash, req.Notes)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, report)
}
