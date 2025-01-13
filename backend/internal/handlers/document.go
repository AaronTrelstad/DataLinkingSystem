package handlers

import (
	"backend/internal/models"
	"net/http"
)

func DocumentHandler(w http.ResponseWriter, r *http.Request, group *models.DocumentGroup) {
	switch r.Method {
	case http.MethodGet:
	case http.MethodPost:
	case http.MethodDelete:
	}
}
