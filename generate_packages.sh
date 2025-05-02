#!/bin/bash

set -e
set -x

DEB_DIR="./debs"
OUT_DIR="./public"

# Ensure the debs directory exists
if [ ! -d "$DEB_DIR" ]; then
  echo "Directory $DEB_DIR does not exist."
  exit 1
fi

# Create output directory structure
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/debs"

# Copy .deb files (only newer ones)
cp -u "$DEB_DIR"/*.deb "$OUT_DIR/debs/" || true

# Generate the Packages file
dpkg-scanpackages -m "$OUT_DIR/debs" > "$OUT_DIR/Packages"

# Compress Packages file
bzip2 -fks "$OUT_DIR/Packages"
gzip -fk "$OUT_DIR/Packages"

# Create the Release file
cat <<EOF > "$OUT_DIR/Release"
Origin: Axs Repo
Label: Axs Repo
Suite: stable
Version: 1.0
Codename: Axs Repo
Architectures: iphoneos-arm64 iphoneos-arm64e
Components: main
Description: 自用插件分享，有问题请卸载！！！
EOF
