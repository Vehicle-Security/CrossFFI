#!/bin/bash
# get script dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR/cpython-main"

build_python() {
    ./configure --enable-shared --prefix=$PWD
    make -j4
	make install
}

# dylib
PYTHON_LIB_EXIST=$(find "$SCRIPT_DIR/cpython-main/" \( -name "libpython*.a" -o -name "libpython*.dylib" -o -name "libpython*.so" \) 2>/dev/null | head -n 1)
if [ -z "$PYTHON_LIB_EXIST" ]; then
    echo "Python library not found, building..."
    build_python
else 
    echo "Python library Exist: $PYTHON_LIB_EXIST"
fi
