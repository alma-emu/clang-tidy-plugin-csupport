# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
# CaseStmt's testcases
#   
# For CaseStmt's testcases, the point which is needed to know on Clang AST is 
# that case label's next statement is under CaseStmt, and case label's next next 
# statement is not under CaseStmt. And the same thing is on default label, 
# default label's next statement is under DefaultStmt, and default label's next next
# statement is not under DefaultStmt.
# 
# So, check these cases.
#     1. the FuncLineStmt is under CaseStmt, and has IfStmt with `Var eq NULL`
#     2. the FuncLineStmt is under CaseStmt, and has IfStmt with `Var eq 0`
#     3. the FuncLineStmt is under CaseStmt, and has IfStmt with `not Var`
#     4. the FuncLineStmt is not under CaseStmt, and has IfStmt
#     5. the FuncLineStmt is under DefaultStmt, and has IfStmt with `Var eq NULL`
#     6. the FuncLineStmt is under DefaultStmt, and has IfStmt with `Var eq 0`
#     7. the FuncLineStmt is under DefaultStmt, and has IfStmt with `not Var`
#     8. the FuncLineStmt is not under DefaultStmt, and has IfStmt
#
# Please read the comments about the CaseStmt case in the source code for more information.


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__1__CaseStmt_With_IfStmt_Var_Eq_Null"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            p = malloc(5);      // target_function is at the next line of the case 1:
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
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__2__CaseStmt_With_IfStmt_Var_Eq_0"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            p = malloc(5);      // target function is at the next line of the case 1:
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
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__3__CaseStmt_With_IfStmt_Not_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            p = malloc(5);      // target function is at the next line of the case 1:
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


# 
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__4__CaseStmt_With_Start_Of_OtherFunc"
TEST_CODE=\
'#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            printf("hello");
            p = malloc(5);      // target function is NOT at the next line of the case 1:
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


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__5__DefaultStmt_With_IfStmt_Var_Eq_Null"
TEST_CODE=\
'#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            break;
        default:
            p = malloc(5);      // target function is at the next line of the default:
            if (p == NULL)
                return 0;
            free(p);
            break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__6__DefaultStmt_With_IfStmt_Var_Eq_0"
TEST_CODE=\
'#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            break;
        default:
            p = malloc(5);      // target function is at the next line of the default:
            if (p == 0)
                return 0;
            free(p);
            break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__7__DefaultStmt_With_IfStmt_Not_Var"
TEST_CODE=\
'#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            break;
        default:
            p = malloc(5);      // target function is at the next line of the default:
            if (!p)
                return 0;
            free(p);
            break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_Switch__8__DefaultStmt_With_Start_Of_OtherFunc"
TEST_CODE=\
'#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int x = 1;
    char* p = NULL;
    switch (x) {
        case 1:
            break;
        default:
            printf("hello");
            p = malloc(5);      // target function is NOT at the next line of the default:
            if (p == 0)
                return 0;
            free(p);
            break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
