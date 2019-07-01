#!/usr/bin/env node

let str = process.argv.splice(2).join(' ')
if (str.length === 0) {
  str = require('fs').readFileSync('/dev/stdin', 'utf-8')
}

console.log(encodeURIComponent(str))

