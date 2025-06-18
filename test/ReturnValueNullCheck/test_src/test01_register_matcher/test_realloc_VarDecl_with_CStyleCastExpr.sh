# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST01_REGISTER_MATCHER__realloc__VarDecl__with_CStyleCastExpr"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return -1;

    char* tmp = (char*)realloc(p, 10);
    p = tmp;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
