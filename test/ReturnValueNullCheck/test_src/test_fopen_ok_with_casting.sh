# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_FOPEN_OK_WITH_CASTING__IfStmt_Var_Eq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    const char *filename = "example.txt";
    FILE *f = (FILE *)fopen(filename, "w");
    if (f == NULL)
        return 0;
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_FOPEN_OK_WITH_CASTING__IfStmt_Null_Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    const char *filename = "example.txt";
    FILE *f = (FILE *)fopen(filename, "w");
    if (NULL == f)
        return 0;
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_FOPEN_OK_WITH_CASTING__IfStmt_Var_Eq_0"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    const char *filename = "example.txt";
    FILE *f = (FILE *)fopen(filename, "w");
    if (f == 0)
        return 0;
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_FOPEN_OK_WITH_CASTING__IfStmt_0_Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    const char *filename = "example.txt";
    FILE *f = (FILE *)fopen(filename, "w");
    if (0 == f)
        return 0;
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_FOPEN_OK_WITH_CASTING__IfStmt_Not_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    const char *filename = "example.txt";
    FILE *f = (FILE *)fopen(filename, "w");
    if (!f)
        return 0;
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
