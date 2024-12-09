use colored_json::prelude::*;
use sonic_rs;
use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let handle = stdin.lock();

    for line in handle.lines() {
        match line {
            Ok(log_line) => {
                if let Ok(json_value) = sonic_rs::from_str::<sonic_rs::Value>(&log_line) {
                    sonic_rs::to_string_pretty(&json_value)
                        .map(|pretty_json| {
                            println!(
                                "{}",
                                pretty_json.to_colored_json_auto().unwrap_or(pretty_json)
                            )
                        })
                        .unwrap_or_else(|err| println!("Failed to pretty print JSON: {}", err));
                } else {
                    println!("{}", &log_line)
                }
            }
            Err(e) => eprintln!("Error reading line: {}", e),
        }
    }
}
