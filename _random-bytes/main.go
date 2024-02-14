package main

import (
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"flag"
	"fmt"
)

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

type Options struct {
	Length int
	Format Format
}

func parseFormat(format string) Format {
	switch format {
	case "hex":
		return Hex
	case "base64":
		return Base64
	default:
		panic("invalid format")
	}
}

func main() {
	var (
		length = flag.Int("length", 32, "length of the random bytes")
		format = flag.String("format", "hex", "format of the random bytes")
	)
	flag.Parse()

	bytes := generateRandomBytes(*length)

	switch parseFormat(*format) {
	case Hex:
		fmt.Printf("%s\n", hex.EncodeToString(bytes))
	case Base64:
		fmt.Printf("%s\n", base64.StdEncoding.EncodeToString(bytes))
	}
}
