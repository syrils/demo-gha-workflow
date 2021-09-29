package main

import (
	"github.com/rs/zerolog/log"
)

func main() {
	msg, err := someFunc()
	if err != nil {
		return
	}
	log.Info().Msg(msg)
}

func someFunc() (string, error) {
	log.Info().Msg("Inside some func")
	return "dummy", nil
}
