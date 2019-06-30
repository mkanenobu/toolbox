#!/usr/bin/env node

const args = process.argv.splice(2)

args.forEach(arg => {
  console.log(encodeURIComponent(arg))
})
