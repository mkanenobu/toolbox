package main

import (
	"fmt"
	"io"
	"os"

	"encoding/json"
	"gopkg.in/yaml.v3"
)

func main() {
	buf, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}

	d, err := YamlToJSON(buf)
	if err != nil {
		panic(err)
	}

	fmt.Printf("%s", d)
}

func YamlToJSON(input []byte) ([]byte, error) {
	m := make(map[string]interface{})
	err := yaml.Unmarshal(input, &m)
	if err != nil {
		return nil, err
	}

	d, err := json.MarshalIndent(&m, "", "  ")
	if err != nil {
		return nil, err
	}

	return d, nil
}
