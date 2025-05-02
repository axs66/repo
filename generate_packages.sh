#!/bin/bash

set -e
set -x  # Debug mode

DEB_DIR="./debs"

if [ ! -d "$DEB_DIR" ]; then
  echo "Directory $DEB_DIR does not exist."
  exit 1
fi

ls -l "$DEB_DIR"

dpkg-scanpackages -m "$DEB_DIR" > Packages
bzip2 -fks Packages
gzip -fk Packages

cat <<EOF > Release
Origin: Axs Repo
Label: Axs Repo
Suite: stable
Version: 1.0
Codename: Axs Repo
Architectures: iphoneos-arm64 iphoneos-arm64e iphoneos-arm
Components: main
Description: 自用插件分享，有问题请卸载！！！
EOF
