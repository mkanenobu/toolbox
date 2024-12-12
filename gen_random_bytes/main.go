package main

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"flag"
	"fmt"
)

func main() {
	var (
		length = flag.Int("length", 32, "length of the random bytes")
		format = flag.String("format", "hex", "format of the random bytes, hex or base64")
	)
	flag.Parse()

	bytes := generateRandomBytes(*length)

	f, err := parseFormat(*format)
	if err != nil {
		panic(err)
	}

	switch f {
	case Hex:
		fmt.Printf("%s\n", hex.EncodeToString(bytes))
	case Base64:
		fmt.Printf("%s\n", base64.StdEncoding.EncodeToString(bytes))
	}
}

func generateRandomBytes(length int) []byte {
	buf := make([]byte, length)
	_, err := rand.Read(buf)
	if err != nil {
		panic(err)
	}
	return buf
}

type Format string

const (
	Hex    Format = "hex"
	Base64 Format = "base64"
)

func parseFormat(format string) (Format, error) {
	switch format {
	case "hex":
		return Hex, nil
	case "base64":
		return Base64, nil
	default:
		return "", errors.New("invalid format")
	}
}
