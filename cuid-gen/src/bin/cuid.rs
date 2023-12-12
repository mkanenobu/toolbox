use cuid;

fn main() {
    #[allow(deprecated)]
    let id = cuid::cuid().unwrap();
    println!("{}", id);
}
