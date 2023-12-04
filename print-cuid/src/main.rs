use cuid2;

fn main() {
    let id = cuid2::create_id();
    println!("{}", id);
}
