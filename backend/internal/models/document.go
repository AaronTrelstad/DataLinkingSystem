package models

import (
	"github.com/google/uuid"
)

type DocumentGroup struct {
	Id        string      `json:"id"`
	Group     string      `json:"group"`
	Documents []*Document `json:"documents"`
}

type Document struct {
	Id           string         `json:"id"`
	Title        string         `json:"title"`
	Placeholders []*Placeholder `json:"placeholders"`
}

type Placeholder struct {
	Id    string  `json:"id"`
	Title string  `json:"title"`
	Value float32 `json:"value"`
}

func NewGroup(group string) *DocumentGroup {
	return &DocumentGroup{
		Id:        uuid.New().String(),
		Group:     group,
		Documents: []*Document{},
	}
}

func (group *DocumentGroup) NewDocument(title string, numPlaceholders int) *Document {
	placeholders := make([]*Placeholder, numPlaceholders)
	for i := 0; i < numPlaceholders; i++ {
		placeholders[i] = &Placeholder{
			Id:    uuid.New().String(),
			Title: "",
			Value: 0.0,
		}
	}

	doc := &Document{
		Id:           uuid.New().String(),
		Title:        title,
		Placeholders: placeholders,
	}

	group.Documents = append(group.Documents, doc)
	return doc
}

func (group *DocumentGroup) GetDocument(docId string) *Document {
	for _, doc := range group.Documents {
		if doc.Id == docId {
			return doc
		}
	}
	return nil
}

func (doc *Document) SetPlaceholder(title string, value float32) {
	for _, placeholder := range doc.Placeholders {
		if placeholder.Title == title {
			placeholder.Value = value
			return
		}
	}

	newPlaceholder := &Placeholder{
		Id:    uuid.New().String(),
		Title: title,
		Value: value,
	}
	doc.Placeholders = append(doc.Placeholders, newPlaceholder)
}
