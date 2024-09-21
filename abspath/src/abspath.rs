use anyhow::Result;
use std::path;

pub fn get_abspath(cwd: path::PathBuf, subpath: &str, follow_symlink: bool) -> Result<String> {
    let mut p = path::PathBuf::from(subpath);
    if !p.is_absolute() {
        p = cwd.join(subpath);
    }

    if follow_symlink {
        // canonicalize reads link
        Ok(p.canonicalize()?.to_string_lossy().to_string())
    } else {
        Ok(normalize_path(&p).to_string_lossy().to_string())
    }
}

// ref: https://github.com/rust-lang/cargo/blob/fede83ccf973457de319ba6fa0e36ead454d2e20/src/cargo/util/paths.rs#L61
fn normalize_path(path: &path::Path) -> path::PathBuf {
    let mut components = path.components().peekable();
    let mut ret = if let Some(c @ path::Component::Prefix(..)) = components.peek().cloned() {
        components.next();
        path::PathBuf::from(c.as_os_str())
    } else {
        path::PathBuf::new()
    };

    for component in components {
        match component {
            path::Component::Prefix(..) => unreachable!(),
            path::Component::RootDir => {
                ret.push(component.as_os_str());
            }
            path::Component::CurDir => {}
            path::Component::ParentDir => {
                ret.pop();
            }
            path::Component::Normal(c) => {
                ret.push(c);
            }
        }
    }
    ret
}
