# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST02_NEXT_STATEMENT__EDGE__IfStmt_Is_After_Empty_Line"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = malloc(5);

    if (p == NULL)
        return 0;

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
