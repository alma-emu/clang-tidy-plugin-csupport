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
    local result=""

    # remove '\n' which is at the end of string
    expected_output="${expected_output%$'\n'}"

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
# test01_register_matcher
source ./test_src/test01_register_matcher/test_malloc_VarDecl_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_malloc_VarDecl_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_malloc_DeclRefExpr_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_malloc_DeclRefExpr_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_calloc_VarDecl_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_calloc_VarDecl_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_calloc_DeclRefExpr_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_calloc_DeclRefExpr_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_realloc_VarDecl_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_realloc_VarDecl_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_realloc_DeclRefExpr_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_realloc_DeclRefExpr_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_fopen_VarDecl_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_fopen_VarDecl_without_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_fopen_DeclRefExpr_with_CStyleCastExpr.sh
source ./test_src/test01_register_matcher/test_fopen_DeclRefExpr_without_CStyleCastExpr.sh
# test02_next_statement
#   - 01_regular_ok_cases
source ./test_src/test02_next_statement/01_regular_ok_cases/test_correct_IfStmt_Var_eq_NULL.sh
source ./test_src/test02_next_statement/01_regular_ok_cases/test_correct_IfStmt_NULL_eq_Var.sh
source ./test_src/test02_next_statement/01_regular_ok_cases/test_correct_IfStmt_Var_eq_0.sh
source ./test_src/test02_next_statement/01_regular_ok_cases/test_correct_IfStmt_0_eq_Var.sh
source ./test_src/test02_next_statement/01_regular_ok_cases/test_correct_IfStmt_Not_Var.sh
#   - 02_regular_ng_cases
source ./test_src/test02_next_statement/02_regular_ng_cases/test_no_IfStmt.sh
source ./test_src/test02_next_statement/02_regular_ng_cases/test_wrong_IfStmt_Var_neq_NULL.sh
source ./test_src/test02_next_statement/02_regular_ng_cases/test_wrong_IfStmt_NULL_neq_Var.sh
source ./test_src/test02_next_statement/02_regular_ng_cases/test_wrong_IfStmt_Var_neq_0.sh
source ./test_src/test02_next_statement/02_regular_ng_cases/test_wrong_IfStmt_0_neq_Var.sh
source ./test_src/test02_next_statement/02_regular_ng_cases/test_wrong_IfStmt_Var.sh
#   - 03_edge_cases
source ./test_src/test02_next_statement/03_edge_cases/test_IfStmt_is_after_another_stmt.sh
source ./test_src/test02_next_statement/03_edge_cases/test_IfStmt_is_after_empty_line.sh
source ./test_src/test02_next_statement/03_edge_cases/test_IfStmt_is_after_label.sh
source ./test_src/test02_next_statement/03_edge_cases/test_IfStmt_is_in_other_scope.sh
source ./test_src/test02_next_statement/03_edge_cases/test_WhileStmt_instead_of_IfStmt.sh
source ./test_src/test02_next_statement/03_edge_cases/test_stmt_is_at_end_of_code_block.sh
# test03_parent_statement
source ./test_src/test03_parent_statement/test_stmt_is_not_inside_any.sh
source ./test_src/test03_parent_statement/test_stmt_is_inside_IfStmt.sh
source ./test_src/test03_parent_statement/test_stmt_is_inside_ForStmt.sh
source ./test_src/test03_parent_statement/test_stmt_is_inside_WhileStmt.sh
source ./test_src/test03_parent_statement/test_stmt_is_inside_DoWhileStmt.sh
source ./test_src/test03_parent_statement/test_stmt_is_inside_Switch.sh
source ./test_src/test03_parent_statement/test_stmt_is_inside_new_scope.sh
# test10_case_function_statement_in_condtion
source ./test_src/test10_case_function_statement_in_condition/test_stmt_in_cond_ok.sh
source ./test_src/test10_case_function_statement_in_condition/test_stmt_in_cond_ng.sh
# test90_misc
source ./test_src/test90_misc/test_stmt_has_no_return.sh
