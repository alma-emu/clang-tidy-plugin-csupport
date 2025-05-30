# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_OTHER_NG__CASE0__IfStmt_Is_In_OtherScope"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = malloc(5);
    {
        if (p == NULL)
            return 0;
    }

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:4:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    4 |     char* p = malloc(5);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_NG__CASE1__IfStmt_Is_After_AnotherStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = malloc(5);
    int x = 5;
    if (p == NULL)
        return 0;

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:4:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    4 |     char* p = malloc(5);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_OTHER_NG__CASE2__End_Of_CodeBlock"
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
