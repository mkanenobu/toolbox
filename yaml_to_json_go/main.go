package main

import (
	"fmt"
	"io"
	"os"

	"encoding/json"
	"github.com/ghodss/yaml"
)

func main() {
	buf, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}

	m := make(map[string]interface{})
	err = yaml.Unmarshal(buf, &m)
	if err != nil {
		panic(err)
	}

	d, err := json.MarshalIndent(&m, "", "  ")
	if err != nil {
		panic(err)
	}
	fmt.Printf("%s", d)
}
