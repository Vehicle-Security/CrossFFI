#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "quickjs.h"

void test_lua(void);
void test_quickjs(void);

int main(void) {
    test_lua();
    
    printf("\n=== QuickJS test ===\n");
    test_quickjs();

    return 0;
}

void test_lua(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_dostring(L, "print('Hello, World!')");
    lua_close(L);
}

void test_quickjs(void) {
    JSRuntime *rt = JS_NewRuntime();
    JSContext *ctx = JS_NewContext(rt);

    JSValue val = JS_Eval(ctx,
                          "1 + 2",
                          strlen("1 + 2"),
                          "<input>",
                          JS_EVAL_TYPE_GLOBAL);

    int32_t result = 0;
    JS_ToInt32(ctx, &result, val);
    printf("QuickJS: 1 + 2 = %d\n", result);

    JS_FreeValue(ctx, val);
    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);
}