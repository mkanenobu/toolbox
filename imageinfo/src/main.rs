mod cli;
mod image;
mod filesize;

fn main() {
    let args = cli::parse_args();

    let img_info = image::ImageInfo::from_path(&args.image_file).unwrap();
    println!("{}", img_info);
}
