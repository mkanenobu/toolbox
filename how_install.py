#!/usr/bin/env python3

import os
import platform
import re
import subprocess
import sys

package_manager = {
    "centos": ["yum"],
    "ubuntu": ["apt", "apt-get", "snap"],
    "arch": ["pacman"],
    "ruby": ["gem"],
    "python": ["pip"],
    "perl": ["cpan"],
    "javascript": ["npm", "yarn"],
    "rust": ["cargo"],
    "ocaml": ["opam"],
}

if len(sys.argv) >= 2:
    dest_cmd = sys.argv[1]
else:
    # sys.exit(1)
    dest_cmd = "nvim"


def exec_cmd(cmd):
    return subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode().strip()


def which_cmd(cmd_name):
    return exec_cmd(["which", cmd_name])


platform = platform.platform()
if "Darwin" in platform:
    distribution = "osx"
elif "centos" in platform:
    distribution = "centos"
elif "ubuntu" in platform:
    distribution = "ubuntu"


type_result = exec_cmd(["type", dest_cmd])
if "shell builtin" in type_result:
    print(f"{dest_cmd} is shell builtin")
    sys.exit(0)
elif "is aliased" in type_result:
    print(type_result)
    sys.exit(0)

# OSX: *env, package manager, brew, macport, os built-in, build from source
if distribution == "osx":
    res = which_cmd(dest_cmd)
    fullpath = os.path.join(os.path.dirname(res), dest_cmd)

    # *env
    if "env" in fullpath:
        print(f"{dest_cmd} in installed with *env")
        sys.exit(0)

    if os.path.islink(fullpath):
        fullpath = os.readlink(fullpath)
        # brew
        if "Cellar" in fullpath:
            print(f"{dest_cmd} is installed with brew")
            sys.exit(0)
else:
    # Linux
    print("linux")
