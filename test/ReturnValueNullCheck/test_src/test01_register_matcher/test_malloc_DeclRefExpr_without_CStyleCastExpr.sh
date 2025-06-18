# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST01_REGISTER_MATCHER__malloc__DeclRefExpr__without_CStyleCastExpr"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p;
    p = malloc(5);
    (void)p;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:5:5: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    5 |     p = malloc(5);
      |     ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
