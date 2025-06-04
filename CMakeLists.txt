cmake_minimum_required(VERSION 3.16)

project(touchstone VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

add_subdirectory(source)

if(CMAKE_BUILD_TYPE STREQUAL "DEBUG")
  enable_testing()
  add_subdirectory(test)
endif()
