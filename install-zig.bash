#!/usr/bin/env bash

#
# Install zig and zls
# Usage: ./install-master-zig.bash [version]
#   version: specific version (e.g., 0.13.0) or 'master' (default)
#

set -Ceu

function show_help() {
  echo "Usage: $0 [version]"
  echo "  version: specific version (e.g., 0.13.0) or 'master' (default)"
  echo "  Examples:"
  echo "    $0          # Install latest master"
  echo "    $0 master   # Install latest master"
  echo "    $0 0.13.0   # Install version 0.13.0"
}

version="${1:-master}"

if [[ "$version" == "-h" || "$version" == "--help" ]]; then
  show_help
  exit 0
fi

os="macos"
arch="aarch64"

if [[ "${version}" == "master" ]]; then
  download_info="$(curl --silent https://ziglang.org/download/index.json | jq -r '.master')"
  version_string="$(echo "${download_info}" | jq -r '.version')"
  platform_info="$(echo "${download_info}" | jq -r ".[\"${arch}-${os}\"]")"
else
  download_info="$(curl --silent https://ziglang.org/download/index.json | jq -r ".[\"$version\"]")"
  if [[ "${download_info}" == "null" ]]; then
    echo "Error: Version ${version} not found"
    echo "Available versions:"
    curl --silent https://ziglang.org/download/index.json | jq -r 'keys[]' | grep -v master | sort -V
    exit 1
  fi
  version_string="${version}"
  platform_info="$(echo "${download_info}" | jq -r ".[\"${arch}-${os}\"]")"
fi

tarball_url="$(echo "${platform_info}" | jq -r '.tarball')"
archive_filename="$(echo "${tarball_url}" | awk -F'/' '{print $NF}')"
filename="$(echo "${archive_filename}" | sed 's/.tar.xz//')"
tmpdir="/tmp"
install_dir="${HOME}/.zig"
zig_install_dir="${install_dir}/zig"
zls_install_dir="${install_dir}/zls"
zig_symlink_path="${HOME}/.local/bin/zig"
zls_symlink_path="${HOME}/.local/bin/zls"

function install_zig() {
  echo "Installing zig ${version_string}..."

  if [ -e "${zig_install_dir}/${version_string}/zig" ]; then
    echo "Zig ${version_string} is already installed"
    return
  fi

  rm -rf "${tmpdir}/${filename}"
  echo "Downloading $tarball_url"
  curl -L "$tarball_url" | tar xz -C "${tmpdir}"

  mkdir -p "${zig_install_dir}"

  mv "${tmpdir}/${filename}" "${zig_install_dir}/${version_string}"
  if [ -e "${zig_symlink_path}" ]; then
    unlink "${zig_symlink_path}"
  fi
  ln -s "${zig_install_dir}/${version_string}/zig" "${zig_symlink_path}"
  echo "Installed ${version_string} -> ${zig_symlink_path}"

  rm -rf "${tmpdir}/${filename}"
}

# Install zls
function install_zls() {
  echo "Install zls..."

  rm -rf "${tmpdir}/zls"
  git clone https://github.com/zigtools/zls "${tmpdir}/zls"
  cd "${tmpdir}/zls"
  commit_hash="$(git rev-parse HEAD)"

  if [ -e "${zls_install_dir}/${commit_hash}/zls" ]; then
    echo "Latest zls is already installed"
    rm -rf "${tmpdir}/zls"
    return
  fi

  eval "${zig_install_dir}/${version_string}/zig build -Doptimize=ReleaseSafe"

  mkdir -p "${zls_install_dir}/${commit_hash}"
  mv "${tmpdir}/zls/zig-out/bin/zls" "${zls_install_dir}/${commit_hash}/zls"
  if [ -e "${zls_symlink_path}" ]; then
    unlink "${zls_symlink_path}"
  fi
  ln -s "${zls_install_dir}/${commit_hash}/zls" "${zls_symlink_path}"
  echo "Installed zls ${commit_hash} -> ${zls_symlink_path}"

  rm -rf "${tmpdir}/zls"
}

install_zig
install_zls
