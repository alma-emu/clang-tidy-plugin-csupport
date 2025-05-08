cmake_minimum_required(VERSION 3.20)
project(test-clang-tidy-plugin-csupport)

# c std
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED YES)

# compile options
add_compile_options(-Wall)
add_compile_options(-Wextra)
add_compile_options(-Werror)
add_compile_options(-Wno-unused-parameter)

# check if package is installed
find_package(Clang REQUIRED CONFIG)

# compile
file(GLOB SRCS test_src/*.c)
add_executable(test-clang-tidy-plugin-csupport ${SRCS})
# include only for this target
target_include_directories(test-clang-tidy-plugin-csupport PRIVATE
	${CLANG_INCLUDE_DIRS})
