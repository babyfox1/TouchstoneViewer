find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

add_library(core OBJECT
    measurementdata.h
    fileparser.h
    fileparser.cpp
    dataprocessor.h
    dataprocessor.cpp
)

target_include_directories(
    core ${warning_guard}
    PUBLIC 
    "\$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source/core>"
)

target_link_libraries(core
    PUBLIC Qt6::Quick Qt6::QuickControls2
)

target_compile_features(core PUBLIC cxx_std_20)
