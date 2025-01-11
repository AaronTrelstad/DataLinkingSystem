package models;

type Documents struct {
	documents []*Document `json:"documents"`
}

type Document struct {
	title string `json:"title"`
	placeholders []*Placeholder `json:"placeholders"`
}

type Placeholder struct {
	title string `json:"title"`
	value float32 `json:"value"`
}
