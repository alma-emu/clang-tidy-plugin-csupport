cmake_minimum_required(VERSION 3.20)
project(clang-tidy-plugin-csupport VERSION 0.1.0)

# cpp std
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# output directory
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# compile options
if(NOT (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"))
	add_compile_options(-Wall)
	add_compile_options(-Wextra)
	add_compile_options(-Werror)
	add_compile_options(-Wno-unused-parameter)
endif()

# check if package is installed
find_package(Clang REQUIRED CONFIG)

# compile
file(GLOB SRCS src/*.cpp)
add_library(clang-tidy-plugin-csupport MODULE ${SRCS})
# include only for this target
target_include_directories(clang-tidy-plugin-csupport PRIVATE
	${CLANG_INCLUDE_DIRS})
