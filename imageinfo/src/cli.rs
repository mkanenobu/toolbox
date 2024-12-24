use clap::Parser;

#[derive(Parser, Debug)]
#[command(version, about)]
pub struct Cli {
    #[arg()]
    pub image_file: String,
}

pub fn parse_args() -> Cli {
    Cli::parse()
}
