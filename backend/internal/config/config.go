package config

import (
	"log"
)

type Config struct {
	ServerAddress string
}

func Load() Config {
	serverAddress := ":8080" 

	log.Printf("Config loaded with ServerAddress: %s", serverAddress)
	return Config{ServerAddress: serverAddress}
}

