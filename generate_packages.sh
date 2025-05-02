#!/bin/bash
set -e
set -x

DEB_DIR="./debs"

# 确保debs目录存在
if [ ! -d "$DEB_DIR" ]; then
  echo "Directory $DEB_DIR does not exist."
  exit 1
fi

# 生成元数据（直接在根目录）
dpkg-scanpackages -m "$DEB_DIR" > Packages
bzip2 -fks Packages
gzip -fk Packages

# 创建Release文件
cat <<EOF > Release
Origin: Axs Repo
Label: Axs Repo
Suite: stable
Version: 1.0
Codename: Axs Repo
Architectures: iphoneos-arm64 iphoneos-arm64e  iphoneos-arm
Components: main
Description: 自用插件分享，有问题请卸载！！！
EOF

# 确保网页文件存在（保护机制）
if [ ! -f index.html ]; then
  cat <<EOF > index.html
<!doctype html>
<html>
<head>
    <title>Axs Repo</title>
</head>
<body>
    <h1>Axs软件源运行中</h1>
    <p>请使用Sileo添加本仓库</p>
</body>
</html>
EOF
fi
