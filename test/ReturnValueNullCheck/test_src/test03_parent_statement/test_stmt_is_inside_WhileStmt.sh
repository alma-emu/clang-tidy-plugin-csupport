# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_WhileStmt__1__Normal"
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
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_WhileStmt__2__Continue_Before_IfStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    while (1) {
        char* p = malloc(5);
        continue;
        if (p == NULL)
            return 0;
        free(p);
    }

    return 0;
}
"
EXPECTED_OUTPUT=\
'main.c:5:15: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    5 |         char* p = malloc(5);
      |               ^
'

execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST03_PARENT_STATEMENT__Stmt_Is_Inside_WhileStmt__3__Break_Before_IfStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    while (1) {
        char* p = malloc(5);
        break;
        if (p == NULL)
            return 0;
        free(p);
    }

    return 0;
}
"
EXPECTED_OUTPUT=\
'main.c:5:15: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    5 |         char* p = malloc(5);
      |               ^
'
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
