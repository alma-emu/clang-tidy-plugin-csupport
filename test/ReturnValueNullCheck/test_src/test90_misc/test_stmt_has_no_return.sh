# This file is not executed directly from the command line.
# It is loaded from test.sh.


# MEMO: This case is covered by other clang-tidy check.
TEST_NAME="TEST90_MISC__Stmt_Has_NoReturn"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    malloc(5);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
