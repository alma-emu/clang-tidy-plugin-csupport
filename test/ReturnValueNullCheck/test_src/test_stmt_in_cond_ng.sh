# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_STMT_IN_COND_NG__UnaryOperator_LNOT__With_Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (!(f = fopen("example.txt", "w"))) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=\
'main.c:5:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    5 |     if (!(f = fopen("example.txt", "w"))) {
      |           ^
'
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
