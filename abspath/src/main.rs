mod abspath;
mod cli;

use abspath::get_abspath;
use anyhow::Result;
use cli::parse_args;
use std::env;

fn main() -> Result<()> {
    let args = parse_args();

    let cwd = env::current_dir()?;
    let abspath = get_abspath(cwd, &args.path, args.follow_symlink)?;
    println!("{}", abspath);

    Ok(())
}
