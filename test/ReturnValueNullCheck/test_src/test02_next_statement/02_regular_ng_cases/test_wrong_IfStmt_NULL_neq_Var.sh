# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST02_NEXT_STATEMENT__NG__Without_IfStmt_Null_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (NULL != p)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:4:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    4 |     char* p = (char*)malloc(5);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
