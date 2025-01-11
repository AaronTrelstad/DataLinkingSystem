package handlers

import (
	"backend/internal/models"
	"backend/internal/services"
	"encoding/json"
	"fmt"
	"net/http"
)

func DatabaseHandler(w http.ResponseWriter, r *http.Request, db *models.Database) {
	enableCORS(w, r);

	switch r.Method {
	case http.MethodGet:
		if err := json.NewEncoder(w).Encode(db); err != nil {
			http.Error(w, fmt.Sprintf("Error encoding response: %v", err), http.StatusInternalServerError)
		}
	case http.MethodPost:
		var requestData struct {
			Title string  `json:"title"`
			Value float32 `json:"value"`
		}

		if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
			http.Error(w, fmt.Sprintf("Error decoding request body: %v", err), http.StatusBadRequest)
			return
		}

		db, err := services.AddValue(db, requestData.Title, requestData.Value)
		if err != nil {
			http.Error(w, fmt.Sprintf("Error: %v", err.Error()), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(db); err != nil {
			http.Error(w, fmt.Sprintf("Error: %v", err.Error()), http.StatusInternalServerError)
		}
	case http.MethodPut:
		var requestData struct {
			Title string `json:"title"`
			Value float32 `json:"value"`
		}

		if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
			http.Error(w, fmt.Sprintf("Error decoding request body: %v", err), http.StatusBadRequest)
			return
		}

		services.EditValue(db, requestData.Title, requestData.Value);

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(db); err != nil {
			http.Error(w, fmt.Sprintf("Error: %v", err.Error()), http.StatusInternalServerError)
		}
	case http.MethodDelete:
		var requestData struct {
			Title string `json:"title"`
		}

		if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
			http.Error(w, fmt.Sprintf("Error decoding request body: %v", err), http.StatusBadRequest)
			return
		}

		services.DeleteValue(db, requestData.Title);

		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(db); err != nil {
			http.Error(w, fmt.Sprintf("Error: %v", err.Error()), http.StatusInternalServerError)
		}
	}
}
