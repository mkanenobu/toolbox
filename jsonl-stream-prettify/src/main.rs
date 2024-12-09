use std::io::{self, BufRead};
use sonic_rs;
use colored_json::prelude::*;

fn main() {
    let stdin = io::stdin();
    let handle = stdin.lock();

    for line in handle.lines() {
        match line {
            Ok(log_line) => {
                match sonic_rs::from_str::<sonic_rs::Value>(&log_line) {
                    Ok(json_value) => {
                        match sonic_rs::to_string_pretty(&json_value) {
                            Ok(pretty_json) => println!("{}", pretty_json.to_colored_json_auto().unwrap()),
                            Err(err) => println!("Failed to pretty print JSON: {}", err),
                        }
                    }
                    Err(_) => println!("{}", &log_line),
                }
            }
            Err(e) => eprintln!("Error reading line: {}", e),
        }
    }
}
