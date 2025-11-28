#!/bin/bash

# 设置CPython路径
CPYTHON_PATH="./cpython-main"

echo "检查CPython目录..."
if [ ! -d "$CPYTHON_PATH" ]; then
    echo "错误: 找不到CPython目录: $CPYTHON_PATH"
    exit 1
fi

# 检查是否需要构建Python
echo "检查Python是否已构建..."
PYTHON_LIB=$(find "$CPYTHON_PATH" \( -name "libpython*.so" -o -name "libpython*.dylib" -o -name "libpython*.a" \) | head -1)
PYTHOH_OUT="$CPYTHON_PATH/build_output"

build_python() {
    cd "$CPYTHON_PATH"
    
    if [ ! -f "Makefile" ]; then
        echo "运行configure..."
        mkdir -p $PYTHOH_OUT
        ./configure --enable-shared --prefix=$(pwd)/$CPYTHON_PATH
    fi
    
    echo "编译Python..."
    make -j$(sysctl -n hw.ncpu 2>/dev/null || echo 4)
    
    if [ $? -ne 0 ]; then
        echo "错误: Python构建失败"
        exit 1
    fi
    
    cd - > /dev/null
    echo "Python构建完成"
}

echo $PYTHON_LIB

if [ -z "$PYTHON_LIB" ]; then
    echo "Python库未找到，开始构建CPython..."
    build_python
fi

echo "查找Python库文件..."
# 优先查找动态库（支持 .so 和 .dylib）
PYTHON_LIB=$(find "$CPYTHON_PATH/" \( -name "libpython*.so" -o -name "libpython*.dylib" \) | head -1)

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

# 提取版本号（去掉文件扩展名，只保留数字和点）
LIB_BASENAME=$(basename "$PYTHON_LIB")
VERSION=$(echo "$LIB_BASENAME" | sed -E 's/libpython([0-9.]+)\..*/\1/')
echo "检测到Python版本: $VERSION"

LIB_DIR=$(dirname "$PYTHON_LIB")
# 转换为绝对路径，避免相对路径问题
LIB_DIR=$(cd "$LIB_DIR" && pwd)
PYTHON_LIB_ABS=$(cd "$(dirname "$PYTHON_LIB")" && pwd)/$(basename "$PYTHON_LIB")

echo "编译测试程序..."


if [ $STATIC_LINK -eq 1 ]; then
    echo "使用静态链接..."
    $CC -I"$CPYTHON_PATH" -I"$CPYTHON_PATH/Include" \
        test_python.c \
        "$PYTHON_LIB_ABS" \
        -ldl -lutil -lm -lcrypt -lpthread -lz -lnsl -lrt \
        -o test_python
else
    echo "使用动态链接..." $LIB_DIR
    # 对于 macOS，直接使用库文件路径更可靠
    if [[ "$PYTHON_LIB" == *.dylib ]]; then
        $CC -I"$CPYTHON_PATH" -I"$CPYTHON_PATH/Include" \
            test_python.c \
            "$PYTHON_LIB_ABS" \
            -o test_python \
            -Wl,-rpath,"$LIB_DIR"
    else
        # 对于 .so 文件，使用 -L 和 -l
        $CC -I"$CPYTHON_PATH" -I"$CPYTHON_PATH/Include" \
            test_python.c \
            -L"$LIB_DIR" -lpython$VERSION \
            -o test_python \
            -Wl,-rpath,"$LIB_DIR"
    fi
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