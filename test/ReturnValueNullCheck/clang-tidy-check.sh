#!/bin/sh

##############################################################################
# create compile_commands.json
##############################################################################
rm -rf build; mkdir build
cd build
cmake ..
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
cp ./compile_commands.json ../
cd ..

##############################################################################
# MEMO: clang-tidy options
##############################################################################
# -checks="-*,csupport-*"
#       specify check items as comma-separeted items. a `-` before a check name disables it.
#       wildcards can also be specified with an asterisk.
#           -*                   ... disable all checks.
#           csupport-*           ... enable only `clang-tidy plugin csupport` checks
# -load=/path/to/libclang-tidy-plugin-csupport.so
#       path to plugin
# -p=/path/to/commpile_commands.json
#       path to compile_commands.json for your c project
# xxxx.c
#       c source

##############################################################################
# test
##############################################################################
# malloc.c
clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/malloc.c
# realloc.c
clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/realloc.c
# calloc.c
clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/calloc.c
# fopen.c
clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/fopen.c
# 
clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/other.c

##############################################################################
# valgrind test
##############################################################################
# malloc.c
#valgrind clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/malloc.c
# realloc.c
#valgrind clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/realloc.c
# calloc.c
#valgrind clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/calloc.c
# fopen.c
#valgrind clang-tidy -checks="-*,csupport-return-value-nullcheck" -load=../../build/lib/libclang-tidy-plugin-csupport.so -p=./compile_commands.json ./test_src/fopen.c

# clang-tidy without plugins
#valgrind --leak-check=full --show-leak-kinds=all clang-tidy -checks="-*" -p=./compile_commands.json malloc.c
