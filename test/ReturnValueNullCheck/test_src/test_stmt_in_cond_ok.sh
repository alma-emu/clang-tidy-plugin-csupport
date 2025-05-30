# This file is not executed directly from the command line.
# It is loaded from unittest.sh.


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_IfStmt__Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if ((f = fopen("example.txt", "w")) != NULL) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_IfStmt__Null_NotEq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (NULL != (f = fopen("example.txt", "w"))) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_IfStmt__Var_NotEq_0"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if ((f = fopen("example.txt", "w")) != 0) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_IfStmt__0_NotEq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (0 != (f = fopen("example.txt", "w"))) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_IfStmt__Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (f = fopen("example.txt", "w")) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_WhileStmt__Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    while ((f = fopen("example.txt", "w")) != NULL) {
        // do something
        fclose(f);
        break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_WhileStmt__Null_NotEq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    while (NULL != (f = fopen("example.txt", "w"))) {
        // do something
        fclose(f);
        break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_WhileStmt__Var_NotEq_0"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    while ((f = fopen("example.txt", "w")) != 0) {
        // do something
        fclose(f);
        break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_WhileStmt__0_NotEq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    while (0 != (f = fopen("example.txt", "w"))) {
        // do something
        fclose(f);
        break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_WhileStmt__Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    while (f = fopen("example.txt", "w")) {
        // do something
        fclose(f);
        break;
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_DoStmt__Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    do {
        // do something
    } while ((f = fopen("example.txt", "w")) != NULL);
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_DoStmt__Null_NotEq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    do {
        // do something
    } while (NULL != (f = fopen("example.txt", "w")));
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_DoStmt__Var_NotEq_0"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    do {
        // do something
    } while ((f = fopen("example.txt", "w")) != 0);
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_DoStmt__0_NotEq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    do {
        // do something
    } while (0 != (f = fopen("example.txt", "w")));
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__Set_Var_In_DoStmt__Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    do {
        // do something
    } while (f = fopen("example.txt", "w"));
    fclose(f);

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__MultiParenExpr__With_Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if ((((f = fopen("example.txt", "w")))) != NULL) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__BinaryOperator_AND__With_Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (((f = fopen("example.txt", "w")) != NULL) && 1 == 1) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__BinaryOperator_OR__With_Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (((f = fopen("example.txt", "w")) != NULL) || 1 == 1) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


# MEMO: the reason why this case is OK and isn't warned is written in comments in the source code.
TEST_NAME="TEST_STMT_IN_COND_OK__UnaryOperator_LNOT__With_Var_NotEq_Null"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if (!((f = fopen("example.txt", "w")) != NULL)) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__BinaryOperator_AND__With_Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if ((f = fopen("example.txt", "w")) && 1 == 1) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"


#
TEST_NAME="TEST_STMT_IN_COND_OK__BinaryOperator_OR__With_Eq_Var"
TEST_CODE=\
'#include <stdio.h>

int main(void) {
    FILE* f = NULL;
    if ((f = fopen("example.txt", "w")) || 1 == 1) {
        // do something
        fclose(f);
    }

    return 0;
}
'
EXPECTED_OUTPUT=""
execute_test "$TEST_NAME" "$TEST_CODE" "$EXPECTED_OUTPUT"
