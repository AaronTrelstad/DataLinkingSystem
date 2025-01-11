package services;

import (
	"backend/internal/models"
	"fmt"
)

func AddValue(db *models.Database, title string, value float32) (*models.Database, error) {
	for _, existingValue := range db.Data {
		if existingValue.Title == title {
			return db, fmt.Errorf("Title '%s' already used.", title);
		}
	}

	newValue := models.NewValue(title, value)
	db.AddValue(newValue)

	return db, nil
}


func DeleteValue(db *models.Database, title string) {
	db.DeleteValue(title);
}

func EditValue(db *models.Database, title string, value float32) {
	db.EditValue(title, value);
}
