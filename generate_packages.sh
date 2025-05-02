#!/bin/bash
set -e
set -x

DEB_DIR="./debs"

# 调试：列出debs目录内容
echo "[DEBUG] 检查debs目录内容："
ls -l "$DEB_DIR" || echo "警告：debs目录未找到"

# 确保debs目录存在
if [ ! -d "$DEB_DIR" ]; then
  echo "错误：目录 $DEB_DIR 不存在"
  exit 1
fi

# 生成元数据
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
Architectures: iphoneos-arm64 iphoneos-arm64e iphoneos-arm
Components: main
Description: 自用插件分享，有问题请卸载！！！
EOF

# 网页文件保护（兼容已有文件）
if [ ! -f index.html ]; then
  echo "初始化默认网页文件..."
  cat <<EOF > index.html
<!doctype html>
<html>
<head>
    <title>Axs Repo</title>
    <meta charset="utf-8">
</head>
<body>
    <h1>Axs软件源运行中</h1>
    <p>仓库地址：<code>https://axs66.github.io/repo/</code></p>
</body>
</html>
EOF
else
  echo "检测到现有网页文件，跳过生成"
fi
