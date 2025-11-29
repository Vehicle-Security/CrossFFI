# vms/Python/CMakeLists.txt

set(CPYTHON_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cpython-main")

# 查找Python库文件
file(GLOB PYTHON_LIBS 
    "${CPYTHON_PATH}/libpython*.a"
    "${CPYTHON_PATH}/lib/libpython*.so*"
    "${CPYTHON_PATH}/libpython*.so*"
)

if(NOT PYTHON_LIBS)
    message(STATUS "Python library not found, building from source...")
    
    # 配置为共享库
    execute_process(
        COMMAND ./configure --enable-shared --without-ensurepip
        WORKING_DIRECTORY ${CPYTHON_PATH}
        RESULT_VARIABLE CONFIG_RESULT
    )
    
    if(NOT CONFIG_RESULT EQUAL 0)
        message(WARNING "Python configure failed")
        return()
    endif()
    
    execute_process(
        COMMAND make -j4
        WORKING_DIRECTORY ${CPYTHON_PATH}
        RESULT_VARIABLE MAKE_RESULT
    )
    
    if(NOT MAKE_RESULT EQUAL 0)
        message(WARNING "Python build failed")
        return()
    endif()
    
    # 重新查找库文件
    file(GLOB PYTHON_LIBS 
        "${CPYTHON_PATH}/libpython*.a"
        "${CPYTHON_PATH}/lib/libpython*.so*"
        "${CPYTHON_PATH}/libpython*.so*"
    )
endif()

if(NOT PYTHON_LIBS)
    message(WARNING "No Python library found after build")
    return()
endif()

# 选择主要的库文件（优先选择 .so 文件）
list(GET PYTHON_LIBS 0 PYTHON_LIB)
foreach(lib ${PYTHON_LIBS})
    if(lib MATCHES "libpython[0-9.]+\\.[so|SO]")
        set(PYTHON_LIB ${lib})
        break()
    endif()
endforeach()

message(STATUS "Using Python library: ${PYTHON_LIB}")

# 创建Python目标
add_library(python_lib INTERFACE)
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

add_library(python::lib ALIAS python_lib)
message(STATUS "Python support enabled")