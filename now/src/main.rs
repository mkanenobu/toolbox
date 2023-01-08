use chrono::prelude::*;

fn main() {
    let local: DateTime<Local> = Local::now();
    println!("{}", local.to_rfc3339());
}
