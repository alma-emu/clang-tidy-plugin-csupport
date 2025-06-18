# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST01_REGISTER_MATCHER__calloc__VarDecl__without_CStyleCastExpr"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = calloc(5, sizeof(char));
    (void)p;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:4:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    4 |     char* p = calloc(5, sizeof(char));
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
