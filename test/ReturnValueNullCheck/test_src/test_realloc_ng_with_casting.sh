# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_REALLOC_NG_WITH_CASTING__Without_IfStmt"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;

    char* tmp = (char*)realloc(p, 10);
    (void)tmp;
    p = tmp;

end:
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_REALLOC_NG_WITH_CASTING__Without_IfStmt_Var_Eq_Null"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;

    char* tmp = (char*)realloc(p, 10);
    if (tmp != NULL) {
        goto end;
    } else {
        p = tmp;
    }

end:
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_REALLOC_NG_WITH_CASTING__Without_IfStmt_Null_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;

    char* tmp = (char*)realloc(p, 10);
    if (NULL != tmp) {
        goto end;
    } else {
        p = tmp;
    }

end:
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_REALLOC_NG_WITH_CASTING__Without_IfStmt_Var_Eq_0"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;

    char* tmp = (char*)realloc(p, 10);
    if (tmp != 0) {
        goto end;
    } else {
        p = tmp;
    }

end:
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_REALLOC_NG_WITH_CASTING__Without_IfStmt_0_Eq_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;

    char* tmp = (char*)realloc(p, 10);
    if (0 != tmp) {
        goto end;
    } else {
        p = tmp;
    }

end:
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_REALLOC_NG_WITH_CASTING__Without_IfStmt_Not_Var"
TEST_CODE=\
"#include <stdlib.h>

int main(void) {
    char* p = (char*)malloc(5);
    if (p == NULL)
        return 0;

    char* tmp = (char*)realloc(p, 10);
    if (tmp) {
        goto end;
    } else {
        p = tmp;
    }

end:
    free(p);

    return 0;
}
"
EXPECTED_OUTPUT=\
"main.c:8:11: warning: Need null check. The return value may be NULL. [csupport-return-value-nullcheck]
    8 |     char* tmp = (char*)realloc(p, 10);
      |           ^
"
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
