package models;

type Database struct {
	Title  string   `json:"title"`
	Data []*Value `json:"values"`
}

type Value struct {
	Title string  `json:"title"`
	Value float32 `json:"value"`
}

func NewDatabase(title string) *Database {
	return &Database{
		Title:  title,
		Data: []*Value{},
	}
}

func NewValue(title string, value float32) *Value {
	return &Value{
		Title: title,
		Value: value,
	}
}

func (db *Database) AddValue(value *Value) {
	db.Data = append(db.Data, value)
}

func (db *Database) DeleteValue(title string) {
	for i, existingValue := range db.Data {
		if existingValue.Title == title {
			db.Data = append(db.Data[:i], db.Data[i+1:]...);
			break;
		}
	}
}

func (db *Database) EditValue(title string, value float32) {
	for _, existingValue := range db.Data {
		if existingValue.Title == title {
			existingValue.Value = value;
			break;
		}
	}
}



