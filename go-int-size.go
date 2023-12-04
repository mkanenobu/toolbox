package main

import "fmt"

const intSize = 32 << (^uint(0) >> 63)

func main() {
  fmt.Println(intSize)
}

