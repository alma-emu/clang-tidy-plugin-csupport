# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_MALLOC_OK_WITH_CASTING__IfStmt_Var_Eq_Null"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_MALLOC_OK_WITH_CASTING__IfStmt_Null_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (NULL == p)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_MALLOC_OK_WITH_CASTING__IfStmt_Var_Eq_0"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == 0)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_MALLOC_OK_WITH_CASTING__IfStmt_0_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (0 == p)
        return 0;
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_MALLOC_OK_WITH_CASTING__IfStmt_Not_Var"
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
