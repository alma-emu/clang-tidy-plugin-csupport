#include <stdlib.h>

void calloc_func_ok_with_cstylecast(void);
void calloc_func_ok_with_implicitcast(void);
void calloc_func_ng_with_cstylecast(void);
void calloc_func_ng_with_implicitcast(void);

void calloc_func_ok_with_cstylecast(void) {
  char *tmp1 = (char *)calloc(5, sizeof(char));
  if (tmp1 == NULL)
    return;
  free(tmp1);

  char *tmp2 = (char *)calloc(5, sizeof(char));
  if (NULL == tmp2)
    return;
  free(tmp2);

  char *tmp3 = (char *)calloc(5, sizeof(char));
  if (tmp3 == 0)
    return;
  free(tmp3);

  char *tmp4 = (char *)calloc(5, sizeof(char));
  if (0 == tmp4)
    return;
  free(tmp4);

  char *tmp5 = (char *)calloc(5, sizeof(char));
  if (!tmp5)
    return;
  free(tmp5);
}

void calloc_func_ok_with_implicitcast(void) {
  char *tmp1 = calloc(5, sizeof(char));
  if (tmp1 == NULL)
    return;
  free(tmp1);

  char *tmp2 = calloc(5, sizeof(char));
  if (NULL == tmp2)
    return;
  free(tmp2);

  char *tmp3 = calloc(5, sizeof(char));
  if (tmp3 == 0)
    return;
  free(tmp3);

  char *tmp4 = calloc(5, sizeof(char));
  if (0 == tmp4)
    return;
  free(tmp4);

  char *tmp5 = calloc(5, sizeof(char));
  if (!tmp5)
    return;
  free(tmp5);
}

void calloc_func_ng_with_cstylecast(void) {
  char *bad1 = (char *)calloc(5, sizeof(char));
  if (bad1 != NULL)
    return;

  char *bad2 = (char *)calloc(5, sizeof(char));
  if (NULL != bad2)
    return;

  char *bad3 = (char *)calloc(5, sizeof(char));
  if (bad3 != 0)
    return;

  char *bad4 = (char *)calloc(5, sizeof(char));
  if (0 != bad4)
    return;

  char *bad5 = (char *)calloc(5, sizeof(char));
  if (bad5)
    return;

  char *bad6 = (char *)calloc(5, sizeof(char));
  /* if (!bad6) */
  /*   return; */
  *bad6 = 'a';
}

void calloc_func_ng_with_implicitcast(void) {
  char *bad1 = (char *)calloc(5, sizeof(char));
  if (bad1 != NULL)
    return;

  char *bad2 = (char *)calloc(5, sizeof(char));
  if (NULL != bad2)
    return;

  char *bad3 = (char *)calloc(5, sizeof(char));
  if (bad3 != 0)
    return;

  char *bad4 = (char *)calloc(5, sizeof(char));
  if (0 != bad4)
    return;

  char *bad5 = (char *)calloc(5, sizeof(char));
  if (bad5)
    return;

  char *bad6 = (char *)calloc(5, sizeof(char));
  /* if (!bad6) */
  /*   return; */
  *bad6 = 'a';
}
