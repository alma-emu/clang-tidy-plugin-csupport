# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_CALLOC_NG_WITHOUT_CASTING__Without_IfStmt"
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


#
TEST_NAME="TEST_CALLOC_NG_WITHOUT_CASTING__Without_IfStmt_Var_Eq_Null"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = calloc(5, sizeof(char));
    if (p != NULL)
        return 0;
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


#
TEST_NAME="TEST_CALLOC_NG_WITHOUT_CASTING__Without_IfStmt_Null_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = calloc(5, sizeof(char));
    if (NULL != p)
        return 0;
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


#
TEST_NAME="TEST_CALLOC_NG_WITHOUT_CASTING__Without_IfStmt_Var_Eq_0"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = calloc(5, sizeof(char));
    if (p != 0)
        return 0;
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


#
TEST_NAME="TEST_CALLOC_NG_WITHOUT_CASTING__Without_IfStmt_0_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = calloc(5, sizeof(char));
    if (0 != p)
        return 0;
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


#
TEST_NAME="TEST_CALLOC_NG_WITHOUT_CASTING__Without_IfStmt_Not_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = calloc(5, sizeof(char));
    if (p)
        return 0;
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
