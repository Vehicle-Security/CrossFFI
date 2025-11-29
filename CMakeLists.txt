cmake_minimum_required(VERSION 3.20)

project(CrossFFI LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_subdirectory(vms/Lua/)
add_subdirectory(vms/QuickJS)
add_subdirectory(vms/Python)

add_executable(crossffi
    src/main.c
)

target_link_libraries(crossffi
    PRIVATE
        lua::lib
        quickjs::lib
        python::lib
        m
)