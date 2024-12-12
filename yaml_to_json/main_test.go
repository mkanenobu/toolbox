package main

import (
	"testing"
)

func TestYamlToJSON(t *testing.T) {
	in := `a: String
b: 2
c:
  - 1
  - 2
  - 3
d:
  key1: value1
  key2: value2
  key3: value3`

	expected := `{
  "a": "String",
  "b": 2,
  "c": [
    1,
    2,
    3
  ],
  "d": {
    "key1": "value1",
    "key2": "value2",
    "key3": "value3"
  }
}`
	r, _ := YamlToJSON([]byte(in))

	if string(r) != expected {
		t.Error("Expected and actual results did not matched")
	}
}
