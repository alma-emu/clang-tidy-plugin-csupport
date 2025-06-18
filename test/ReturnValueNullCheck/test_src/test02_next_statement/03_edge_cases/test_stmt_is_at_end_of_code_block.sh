# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST02_NEXT_STATEMENT__EDGE__End_Of_CodeBlock"
TEST_CODE=\
"#include <stdlib.h>

void func(void) {
    char* p = malloc(5);
}
"
EXPECTED_OUTPUT=\
"main.c:4:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    4 |     char* p = malloc(5);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
