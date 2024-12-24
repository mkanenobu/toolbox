pub fn filesize_to_human(filesize: u64) -> String {
    let units = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    let mut size = filesize as f64;
    let mut unit = 0;
    while size >= 1024.0 {
        size /= 1024.0;
        unit += 1;
    }
    format!("{:.2} {}", size, units[unit])
}