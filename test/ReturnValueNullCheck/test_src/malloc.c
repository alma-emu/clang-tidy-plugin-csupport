#include <stdlib.h>

void malloc_func_ok_with_cstylecast(void);
void malloc_func_ok_with_implicitcast(void);
void malloc_func_ng_with_cstylecast(void);
void malloc_func_ng_with_implicitcast(void);

void malloc_func_ok_with_cstylecast(void) {
  char *tmp1 = (char *)malloc(5);
  if (tmp1 == NULL)
    return;
  free(tmp1);

  char *tmp2 = (char *)malloc(5);
  if (NULL == tmp2)
    return;
  free(tmp2);

  char *tmp3 = (char *)malloc(5);
  if (tmp3 == 0)
    return;
  free(tmp3);

  char *tmp4 = (char *)malloc(5);
  if (0 == tmp4)
    return;
  free(tmp4);

  char *tmp5 = (char *)malloc(5);
  if (!tmp5)
    return;
  free(tmp5);
}

void malloc_func_ok_with_implicitcast(void) {
  char *tmp1 = malloc(5);
  if (tmp1 == NULL)
    return;
  free(tmp1);

  char *tmp2 = malloc(5);
  if (NULL == tmp2)
    return;
  free(tmp2);

  char *tmp3 = malloc(5);
  if (tmp3 == 0)
    return;
  free(tmp3);

  char *tmp4 = malloc(5);
  if (0 == tmp4)
    return;
  free(tmp4);

  char *tmp5 = malloc(5);
  if (!tmp5)
    return;
  free(tmp5);
}

void malloc_func_ng_with_cstylecast(void) {
  char *bad1 = (char *)malloc(5);
  if (bad1 != NULL)
    return;

  char *bad2 = (char *)malloc(5);
  if (NULL != bad2)
    return;

  char *bad3 = (char *)malloc(5);
  if (bad3 != 0)
    return;

  char *bad4 = (char *)malloc(5);
  if (0 != bad4)
    return;

  char *bad5 = (char *)malloc(5);
  if (bad5)
    return;

  char *bad6 = (char *)malloc(5);
  /* if (!bad6) */
  /*   return; */
  *bad6 = 'a';
}

void malloc_func_ng_with_implicitcast(void) {
  char *bad1 = malloc(5);
  if (bad1 != NULL)
    return;

  char *bad2 = malloc(5);
  if (NULL != bad2)
    return;

  char *bad3 = malloc(5);
  if (bad3 != 0)
    return;

  char *bad4 = malloc(5);
  if (0 != bad4)
    return;

  char *bad5 = malloc(5);
  if (bad5)
    return;

  char *bad6 = malloc(5);
  /* if (!bad6) */
  /*   return; */
  *bad6 = 'a';
}
