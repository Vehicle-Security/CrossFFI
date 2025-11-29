SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LUA_DIR="$SCRIPT_DIR/Lua"

download_lua() {
	cd $LUA_DIR
	curl -L -o lua-5.4.8.tar.gz https://www.lua.org/ftp/lua-5.4.8.tar.gz
	tar -xzf lua-5.4.8.tar.gz
	mv lua-5.4.8 lua-master
	rm -rf lua-5.4.8.tar.gz
}

if [ ! -d "$LUA_DIR/lua-master" ]; then
	download_lua
fi


# build Python
# bash $SCRIPT_DIR/Python/build.sh

PYTHON_DIR="$SCRIPT_DIR/Python"

download_python() {
    cd "$PYTHON_DIR"
    PY_VERSION="3.12.7"
    PY_TARBALL="Python-$PY_VERSION.tgz"
    PY_URL="https://www.python.org/ftp/python/$PY_VERSION/$PY_TARBALL"

    curl -L -o "$PY_TARBALL" "$PY_URL"
    tar -xzf "$PY_TARBALL"
    mv "Python-$PY_VERSION" "cpython-main"
    rm -rf "$PY_TARBALL"
}

if [ ! -d "$PYTHON_DIR/cpython-main" ]; then
    download_python
fi
