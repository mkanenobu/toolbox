use std::fmt::Display;
use image::{ColorType};
use std::fs;
use anyhow::Error;
use crate::filesize::filesize_to_human;

#[derive(Debug)]
pub struct ImageInfo {
    pub width: u32,
    pub height: u32,
    pub filesize: u64,
    pub color_type: ColorType,
}

impl ImageInfo {
    pub fn from_path(file_path: &str) -> Result<Self, Error> {
        get_image_info(file_path)
    }
}

impl Display for ImageInfo {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "Size: {}x{}", self.width, self.height)?;
        write!(f, "\nFile Size: {}", filesize_to_human(self.filesize))?;
        write!(f, "\nColor Type: {}", color_type_to_string(self.color_type))?;
        Ok(())
    }
}

fn get_image_info(file_path: &str) -> Result<ImageInfo, Error> {
    let img = image::open(file_path)?;
    let width = img.width();
    let height = img.height();

    let filesize = fs::metadata(file_path)?.len();

    let color_type = img.color();

    Ok(ImageInfo {
        width,
        height,
        filesize,
        color_type,
    })
}

fn color_type_to_string(color_type: ColorType) -> String {
    match color_type {
        ColorType::L8 => "L8",
        ColorType::La8 => "LA8",
        ColorType::Rgb8 => "RGB8",
        ColorType::Rgba8 => "RGBA8",
        ColorType::L16 => "L16",
        ColorType::La16 => "LA16",
        ColorType::Rgba16 => "RGBA16",
        ColorType::Rgb32F => "RGB32F",
        ColorType::Rgba32F => "RGBA32F",
        _ => "Unknown",
    }.to_string()
}