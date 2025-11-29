# vms/Python/CMakeLists.txt

# 设置自定义Python路径（相对于当前CMakeLists.txt所在目录）
get_filename_component(PYTHON_VM_DIR ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
set(CPYTHON_PATH "${PYTHON_VM_DIR}/cpython-main" CACHE PATH "Path to custom Python build")

# 检查Python路径
if(NOT EXISTS ${CPYTHON_PATH})
    message(WARNING "CPython path not found: ${CPYTHON_PATH}. Python support will be disabled.")
    return()
endif()

# 查找Python库文件
file(GLOB PYTHON_LIBS 
    ${CPYTHON_PATH}/libpython*.a
    ${CPYTHON_PATH}/libpython*.dylib
    ${CPYTHON_PATH}/libpython*.so
)

# 如果找不到库文件，禁用Python支持
if(NOT PYTHON_LIBS)
    message(WARNING "No Python library found in ${CPYTHON_PATH}. Python support will be disabled.")
    return()
endif()

list(GET PYTHON_LIBS 0 PYTHON_LIB)
message(STATUS "Using Python library: ${PYTHON_LIB}")

# 创建接口库
add_library(python_lib INTERFACE)

# 设置包含目录和链接库
target_include_directories(python_lib INTERFACE
    ${CPYTHON_PATH}
    ${CPYTHON_PATH}/Include
)

target_link_libraries(python_lib INTERFACE
    ${PYTHON_LIB}
    dl
    pthread
    util
)

# 创建别名
add_library(python::lib ALIAS python_lib)

message(STATUS "Python support enabled")