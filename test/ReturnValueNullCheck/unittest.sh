#!/bin/bash


#############################
# settings
#############################
CLANG_TIDY_PLUGIN="../../build/lib/libclang-tidy-plugin-csupport.so"
CLANG_TIDY_CHECKS="-*,csupport-return-value-nullcheck"


#############################
# func definition
#############################
execute_test() {
    local test_name=$1
    local test_code=$2
    local expected_output=$3

    # remove '\n' which is at the end of string
    local expected_output="${expected_output%$'\n'}"

    # write test_code into ./test_src/main.c, and execute clang-tidy check
    echo "$test_code">./test_src/main.c
    result=$(clang-tidy -load=$CLANG_TIDY_PLUGIN -p=./compile_commands.json -checks=$CLANG_TIDY_CHECKS ./test_src/main.c 2>/dev/null)

    # check result
    if [[ "$expected_output" == "" && "$result" == "" ]]; then
        echo "OK" - $test_name
    elif [[ "$expected_output" != "" && $result == *"$expected_output"* ]]; then
        echo "OK" - $test_name
    else
        echo "NG" - $test_name
        echo "[EXPECTED]----------------------------"
        echo "$expected_output"
        echo "[RESULT]------------------------------"
        echo "$result"
        echo "--------------------------------------"
    fi
}


#############################
# testing
#############################
# check if clang-tidy-plugin exists
if [[ ! -e $CLANG_TIDY_PLUGIN ]]; then
    echo "Target plugin doesn't exist. Please compile before testing."
    echo ""
    echo " [ COMMAND ] "
    echo "$ cd clang-tidy-plugin-csupport"
    echo "$ mkdir build"
    echo "$ cd build"
    echo "$ cmake .."
    echo "$ make"
    exit
fi

# create compile_commands.json for clang-tidy
# (the folder `build` which path is set as `directory` in compile_commands.json is needed to exist for clang-tidy execution.)
if [[ ! -e "compile_commands.json" || ! -e "build" ]]; then
    rm -rf build; mkdir build
    cd build
    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
    cp ./compile_commands.json ../
    cd ..
fi

# load and execute tests
# (this must be after the func definition)
# malloc
source test_src/test_malloc_ok_without_casting.sh
source test_src/test_malloc_ok_with_casting.sh
source test_src/test_malloc_ng_without_casting.sh
source test_src/test_malloc_ng_with_casting.sh
# calloc
source test_src/test_calloc_ok_without_casting.sh
source test_src/test_calloc_ok_with_casting.sh
source test_src/test_calloc_ng_without_casting.sh
source test_src/test_calloc_ng_with_casting.sh
# realloc
source test_src/test_realloc_ok_without_casting.sh
source test_src/test_realloc_ok_with_casting.sh
source test_src/test_realloc_ng_without_casting.sh
source test_src/test_realloc_ng_with_casting.sh
# fopen
source test_src/test_fopen_ok_without_casting.sh
source test_src/test_fopen_ok_with_casting.sh
source test_src/test_fopen_ng_without_casting.sh
source test_src/test_fopen_ng_with_casting.sh
# stmt_in_cond
source test_src/test_stmt_in_cond_ok.sh
source test_src/test_stmt_in_cond_ng.sh
# other
source test_src/test_other_ok.sh
source test_src/test_other_ng.sh
