use clap::Parser;

#[derive(Parser)]
#[command(version, about)]
pub struct Cli {
    #[arg(short = 'f', long = "follow-symlink")]
    pub follow_symlink: bool,

    #[arg()]
    pub path: String,
}

pub fn parse_args() -> Cli {
    Cli::parse()
}
