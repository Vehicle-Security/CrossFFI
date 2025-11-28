#!/bin/bash

# 设置CPython路径
CPYTHON_PATH="./cpython-main"

echo "检查CPython目录..."
if [ ! -d "$CPYTHON_PATH" ]; then
    echo "错误: 找不到CPython目录: $CPYTHON_PATH"
    exit 1
fi

echo "查找Python库文件..."
# 优先查找动态库
PYTHON_LIB=$(find "$CPYTHON_PATH" -name "libpython*.so" | head -1)

if [ -z "$PYTHON_LIB" ]; then
    # 如果没有动态库，使用静态库
    PYTHON_LIB=$(find "$CPYTHON_PATH" -name "libpython*.a" | head -1)
    STATIC_LINK=1
else
    STATIC_LINK=0
fi

if [ -z "$PYTHON_LIB" ]; then
    echo "错误: 找不到Python库文件"
    exit 1
fi

echo "找到Python库: $PYTHON_LIB"

# 提取版本号
VERSION=$(echo "$PYTHON_LIB" | grep -o 'libpython[0-9.]*' | sed 's/libpython//')
echo "检测到Python版本: $VERSION"

LIB_DIR=$(dirname "$PYTHON_LIB")

echo "编译测试程序..."

if [ $STATIC_LINK -eq 1 ]; then
    echo "使用静态链接..."
    gcc -I"$CPYTHON_PATH" -I"$CPYTHON_PATH/Include" \
        test_python.c \
        "$PYTHON_LIB" \
        -ldl -lutil -lm -lcrypt -lpthread -lz -lnsl -lrt \
        -o test_python
else
    echo "使用动态链接..."
    gcc -I"$CPYTHON_PATH" -I"$CPYTHON_PATH/Include" \
        test_python.c \
        -L"$LIB_DIR" -lpython$VERSION \
        -o test_python \
        -Wl,-rpath,"$LIB_DIR"
fi

if [ $? -eq 0 ]; then
    echo "编译成功！"
    echo "运行程序: ./test_python"
else
    echo "编译失败！"
    echo "尝试备用链接方式..."
    
    # 备用方案：尝试不同的库组合
    gcc -I"$CPYTHON_PATH" -I"$CPYTHON_PATH/Include" \
        test_python.c \
        "$PYTHON_LIB" \
        -ldl -lm -lpthread -lutil -lcrypt -lz \
        -o test_python
fi