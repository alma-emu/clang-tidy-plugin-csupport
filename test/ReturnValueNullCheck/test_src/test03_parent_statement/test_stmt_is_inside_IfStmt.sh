# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_IfStmt__1__If"
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
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_IfStmt__2__Else"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    if (1) {
    } else {
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
