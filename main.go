package main

import (
	"log"
)

func main() {
	msg, err := someFunc()
	if err != nil {
		return
	}
	log.Print(msg)
}

func someFunc() (string, error) {
	return "dummy", nil
}
