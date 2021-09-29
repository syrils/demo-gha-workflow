package main

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestSomeFunc(t *testing.T) {
	_, err := someFunc()
	require.NoError(t, err)
}
