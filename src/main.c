#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>


void test_lua(void);

int main(void) {
    test_lua();
    return 0;
}

void test_lua(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_dostring(L, "print('Hello, World!')");
    lua_close(L);
}
