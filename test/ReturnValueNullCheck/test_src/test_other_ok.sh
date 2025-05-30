# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_OTHER_OK__CASE0__Stmt_Is_In_No_Conditional_Stmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = malloc(5);
    if (p == NULL)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE1__Stmt_Is_In_IfStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    if (1) {
        char* p = malloc(5);
        if (p == NULL)
            return 0;
        free(p);
    }

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE2__Stmt_Is_In_WhileStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    while (1) {
        char* p = malloc(5);
        if (p == NULL)
            return 0;
        free(p);
    }

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE3__Stmt_Is_In_DoWhileStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    do {
        char* p = malloc(5);
        if (p == NULL)
            return 0;
        free(p);
        break;
    } while(1);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE4__Stmt_Is_In_ForStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    for (int i = 0; i < 10; i++) {
        char* p = malloc(5);
        if (p == NULL)
            return 0;
        free(p);
    }

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE5-1__Stmt_Is_In_CaseStmt_With_Var_Eq_Null"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            p = malloc(5);
            if (p == NULL)
                return 0;
            free(p);
            break;
        default:
            break;
    }

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE5-2__Stmt_Is_In_CaseStmt_With_Var_Eq_0"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            p = malloc(5);
            if (p == 0)
                return 0;
            free(p);
            break;
        default:
            break;
    }

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_OK__CASE5-3__Stmt_Is_In_CaseStmt_With_Not_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            p = malloc(5);
            if (!p)
                return 0;
            free(p);
            break;
        default:
            break;
    }

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


# MEMO: To understand the difference of 5-1,5-2,5-3 and 5-4, which are test cases for CaseStmt,
#       please read the comments for CaseStmt in the source code.
TEST_NAME="TEST_OTHER_OK__CASE5-4__Stmt_Is_In_CaseStmt_With_Start_Of_OtherFunc"
TEST_CODE=\
'#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            printf("hello");
            p = malloc(5);
            if (p == 0)
                return 0;
            free(p);
            break;
        default:
            break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


# MEMO: This case is covered by other clang-tidy check.
TEST_NAME="TEST_OTHER_OK__CASE6__NoReturn"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    malloc(5);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
