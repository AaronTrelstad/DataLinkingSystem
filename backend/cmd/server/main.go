package main

import (
	"backend/internal/config"
	"backend/internal/handlers"
	"backend/internal/models"
	"log"
	"net/http"
)

func main() {
	cfg := config.Load()

	db := models.NewDatabase("Testing")
	group := models.NewGroup("Testing");

	http.HandleFunc("/api/document", func(w http.ResponseWriter, r *http.Request) {
		handlers.DocumentHandler(w, r, group)
	})
	http.HandleFunc("/api/database", func(w http.ResponseWriter, r *http.Request) {
		handlers.DatabaseHandler(w, r, db) 
	})

	log.Printf("Server running at %s", cfg.ServerAddress)
	log.Fatal(http.ListenAndServe(cfg.ServerAddress, nil))
}

