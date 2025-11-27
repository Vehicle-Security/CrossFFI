# vms/QuickJS/CMakeLists.txt

set(srcDir ${CMAKE_CURRENT_SOURCE_DIR}/quickjs)

set(srcFiles
    ${srcDir}/quickjs.c
    ${srcDir}/libregexp.c
    ${srcDir}/libunicode.c
    ${srcDir}/cutils.c
)

foreach(opt_src libbf.c dtoa.c)
    if(EXISTS "${srcDir}/${opt_src}")
        list(APPEND srcFiles "${srcDir}/${opt_src}")
    endif()
endforeach()

add_library(quickjs STATIC
    ${srcFiles}
)

target_include_directories(quickjs
    PUBLIC
    ${srcDir}
)

target_compile_definitions(quickjs
    PRIVATE
        _GNU_SOURCE
        CONFIG_VERSION=\"2025-11-27\"
)

add_library(quickjs::lib ALIAS quickjs)