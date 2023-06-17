#!/usr/bin/env cargo +nightly -Zscript

//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! chrono = "0.4"
//! ```

use chrono::{DateTime, Local};

fn main() {
    let local: DateTime<Local> = Local::now();
    println!("{}", local.to_rfc3339());
}
