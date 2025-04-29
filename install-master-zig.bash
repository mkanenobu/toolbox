#!/usr/bin/env bash

#
# Install latest master version zig and zls
#

set -Ceu

os="macos"
arch="aarch64"

master="$(curl --silent https://ziglang.org/download/index.json | jq -r '.master')"
macos="$(echo "${master}" | jq -r ".[\"${arch}-${os}\"]")"
master_version="$(echo "${master}" | jq -r '.version')"
tarball_url="$(echo "${macos}" | jq -r '.tarball')"
archive_filename="$(echo "${tarball_url}" | awk -F'/' '{print $NF}')"
filename="$(echo "${archive_filename}" | sed 's/.tar.xz//')"
tmpdir="/tmp"
install_dir="${HOME}/.zig"
zig_install_dir="${install_dir}/zig"
zls_install_dir="${install_dir}/zls"
zig_symlink_path="${HOME}/.local/bin/zig"
zls_symlink_path="${HOME}/.local/bin/zls"

function install_zig() {
  echo "Installing zig..."

  if [ -e "${zig_install_dir}/${master_version}/zig" ]; then
    echo "Latest zig compiler is already installed"
    return
  fi

  rm -rf "${tmpdir}/${filename}"
  echo "Downloading $tarball_url"
  curl -L "$tarball_url" | tar xz -C "${tmpdir}"

  mkdir -p "${zig_install_dir}"

  mv "${tmpdir}/${filename}" "${zig_install_dir}/${master_version}"
  if [ -e "${zig_symlink_path}" ]; then
    unlink "${zig_symlink_path}"
  fi
  ln -s "${zig_install_dir}/${master_version}/zig" "${zig_symlink_path}"
  echo "Installed ${master_version} -> ${zig_symlink_path}"

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

  eval "${zig_install_dir}/${master_version}/zig build -Doptimize=ReleaseSafe"

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
