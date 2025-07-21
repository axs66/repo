#!/bin/bash

set -e
set -x

# 切换到脚本所在目录，确保路径一致
cd "$(dirname "$0")"

# Define debs directory
DEB_DIR="./debs"

# 检查 debs 目录是否存在
if [ ! -d "$DEB_DIR" ]; then
  echo "❌ Error: Directory $DEB_DIR does not exist."
  exit 1
fi

# 列出 .deb 文件
ls -lh "$DEB_DIR"

# 生成 Packages 文件
dpkg-scanpackages -m "$DEB_DIR" > Packages

# 生成压缩版本
bzip2 -fks Packages
gzip -fk Packages

# 创建 Release 文件
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

echo "✅ Repository metadata generated successfully."
