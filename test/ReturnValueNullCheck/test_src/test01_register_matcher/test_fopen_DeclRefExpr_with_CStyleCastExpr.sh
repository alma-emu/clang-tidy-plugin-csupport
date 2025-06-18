# This file is not executed directly from the command line.
# It is loaded from test.sh.


#
TEST_NAME="TEST01_REGISTER_MATCHER__fopen__DeclRefExpr__with_CStyleCastExpr"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f;
    f = (FILE*)fopen("sample.txt", "w");
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=\
'main.c:5:5: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    5 |     f = (FILE*)fopen("sample.txt", "w");
      |     ^
'
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
