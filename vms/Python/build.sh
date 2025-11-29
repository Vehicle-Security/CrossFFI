#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CPY="$SCRIPT_DIR/cpython-main"
INSTALL_DIR="$CPY/install"

cd "$CPY"

# 创建安装目录
mkdir -p "$INSTALL_DIR"

build_python() {
    ./configure --enable-shared --prefix="$INSTALL_DIR"
    make -j"$(nproc)"
    make install
}

build_python

# 设置环境变量
export PYTHONHOME="$INSTALL_DIR"
export PYTHONPATH="$INSTALL_DIR/lib/python3.12"
export LD_LIBRARY_PATH="$INSTALL_DIR/lib:$LD_LIBRARY_PATH"

echo "PYTHONHOME=$PYTHONHOME"
echo "PYTHONPATH=$PYTHONPATH"
