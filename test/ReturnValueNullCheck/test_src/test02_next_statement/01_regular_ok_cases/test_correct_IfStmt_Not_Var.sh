# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST02_NEXT_STATEMENT__OK__with_IfStmt_Not_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (!p)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
