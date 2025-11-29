# vms/Python/CMakeLists.txt

# 设置自定义Python路径
set(CPYTHON_PATH "./cpython-main" CACHE PATH "Path to custom Python build")

# 检查Python路径
if(NOT EXISTS ${CPYTHON_PATH})
    message(WARNING "CPython path not found: ${CPYTHON_PATH}. Python support will be disabled.")
    return()
endif()

# 查找Python库
file(GLOB PYTHON_LIBS ${CPYTHON_PATH}/libpython*.a)
if(NOT PYTHON_LIBS)
    message(WARNING "No Python library found in ${CPYTHON_PATH}. Python support will be disabled.")
    return()
endif()

list(GET PYTHON_LIBS 0 PYTHON_LIB)
message(STATUS "Using Python library: ${PYTHON_LIB}")

# 创建接口库（推荐方式）
add_library(python_lib INTERFACE)

# 设置包含目录和链接库
target_include_directories(python_lib INTERFACE
    ${CPYTHON_PATH}
    ${CPYTHON_PATH}/Include
)

target_link_libraries(python_lib INTERFACE
    ${PYTHON_LIB}
    dl
    m
    pthread
    util
)

# 创建别名（确保与target_link_libraries中的名称一致）
add_library(python::lib ALIAS python_lib)

message(STATUS "Python support enabled")