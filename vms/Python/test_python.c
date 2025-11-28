#include <Python.h>

void test_python(void);

int main(void) {
    test_python();
    return 0;
}

void test_python(void) {
    // 初始化Python解释器
    Py_Initialize();
    
    // 执行Python代码字符串
    PyRun_SimpleString("print('Hello, World from Python!')");
    
    // 关闭Python解释器
    Py_Finalize();
}