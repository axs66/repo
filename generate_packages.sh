#!/bin/bash

set -e
set -x

cd "$(dirname "$0")"

DEB_DIR="./debs"

if [ ! -d "$DEB_DIR" ]; then
  echo "❌ Error: Directory $DEB_DIR does not exist."
  exit 1
fi

ls -lh "$DEB_DIR"

# 生成 Packages 文件
dpkg-scanpackages -m "$DEB_DIR" > Packages

# 压缩 Packages 文件为多种格式
bzip2 -fks Packages
gzip -fk Packages

# 安装 zstd 工具（本地测试或 CI 环境中需安装）
zstd -f -19 -k Packages -o Packages.zst

# 创建 Release 文件
cat <<EOF > Release
Origin: Axs Repo
Label: Axs Repo
Suite: stable
Version: 1.0
Codename: axs
Architectures: iphoneos-arm64 iphoneos-arm64e iphoneos-arm
Components: main
Description: 自用插件分享，有问题请卸载！！！
EOF

echo "✅ Repository metadata generated successfully."
