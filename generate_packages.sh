#!/bin/bash

set -e
set -x

DEB_DIR="./debs"

# 确保 debs 目录存在
if [ ! -d "$DEB_DIR" ]; then
  echo "Directory $DEB_DIR does not exist."
  exit 1
fi

# 调试：列出 debs 目录内容
ls -l "$DEB_DIR"

# 在根目录生成 Packages 文件
dpkg-scanpackages -m "$DEB_DIR" > Packages

# 在根目录压缩 Packages 文件
bzip2 -fks Packages
gzip -fk Packages

# 在根目录创建 Release 文件
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

# 同时为 GitHub Pages 准备 public 目录（仅包含必要文件）
mkdir -p public
cp -r Packages* Release public/ 2>/dev/null || true
