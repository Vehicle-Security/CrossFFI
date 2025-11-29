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
bash $SCRIPT_DIR/Python/build.sh