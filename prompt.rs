#!/usr/bin/env cargo +nightly -Zscript

//! ```cargo
//! [package]
//! edition = "2021"
//! [dependencies]
//! nu-ansi-term = "0.49"
//! ```

use std::io::{self, Write};
use nu_ansi_term::Color;

fn main() {
    let datetime = Color::Green.bold().paint(format!("[{}]", "\\D{%F %T}"));
    let working_dir = Color::Blue.bold().paint(format!("\\W"));
    let first_half = format!("{}:{}", datetime, working_dir);
    let error_prompt = if_error();

    let prompt = format!("{first_half}\\[$({error_prompt}) ");
    let mut stdout = io::stdout();
    stdout.write(prompt.as_bytes()).unwrap();
    stdout.flush().unwrap();
}

fn if_error() -> String {
    let prompt = "$".to_string();
    let error = Color::Red.paint(prompt.clone()).to_string();

    format!(
        "if [ $? -eq 0 ]; then
  echo -en {prompt}
else
  echo -en {error}
fi"
    )
}

