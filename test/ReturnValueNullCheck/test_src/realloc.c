#include <stdlib.h>

void realloc_func_ok_with_cstylecast(void);
void realloc_func_ok_with_implicitcast(void);
void realloc_func_ng_with_cstylecast(void);
void realloc_func_ng_with_implicitcast(void);

void realloc_func_ok_with_cstylecast(void) {
  char *buf = (char *)malloc(5);
  if (buf == NULL)
    return;

  char *tmp1 = (char *)realloc(buf, 10);
  if (tmp1 == NULL) {
    goto end;
  } else {
    buf = tmp1;
  }

  char *tmp2 = (char *)realloc(buf, 15);
  if (NULL == tmp2) {
    goto end;
  } else {
    buf = tmp2;
  }

  char *tmp3 = (char *)realloc(buf, 20);
  if (tmp3 == 0) {
    goto end;
  } else {
    buf = tmp3;
  }

  char *tmp4 = (char *)realloc(buf, 25);
  if (0 == tmp4) {
    goto end;
  } else {
    buf = tmp4;
  }

  char *tmp5 = (char *)realloc(buf, 30);
  if (!tmp5) {
    goto end;
  } else {
    buf = tmp5;
  }

end:
  free(buf);
}

void realloc_func_ok_with_implicitcast(void) {
  char *buf = (char *)malloc(5);
  if (buf == NULL)
    return;

  char *tmp1 = realloc(buf, 10);
  if (tmp1 == NULL) {
    goto end;
  } else {
    buf = tmp1;
  }

  char *tmp2 = realloc(buf, 15);
  if (NULL == tmp2) {
    goto end;
  } else {
    buf = tmp2;
  }

  char *tmp3 = realloc(buf, 20);
  if (tmp3 == 0) {
    goto end;
  } else {
    buf = tmp3;
  }

  char *tmp4 = realloc(buf, 25);
  if (0 == tmp4) {
    goto end;
  } else {
    buf = tmp4;
  }

  char *tmp5 = realloc(buf, 30);
  if (!tmp5) {
    goto end;
  } else {
    buf = tmp5;
  }

end:
  free(buf);
}

void realloc_func_ng_with_cstylecast(void) {
  char *buf = (char *)malloc(5);
  if (buf == NULL)
    return;

  char *bad1 = (char *)realloc(buf, 10);
  if (bad1 != NULL) {
    goto end;
  } else {
    buf = bad1;
  }

  char *bad2 = (char *)realloc(buf, 15);
  if (NULL != bad2) {
    goto end;
  } else {
    buf = bad2;
  }

  char *bad3 = (char *)realloc(buf, 20);
  if (bad3 != 0) {
    goto end;
  } else {
    buf = bad3;
  }

  char *bad4 = (char *)realloc(buf, 25);
  if (0 != bad4) {
    goto end;
  } else {
    buf = bad4;
  }

  char *bad5 = (char *)realloc(buf, 30);
  if (bad5) {
    goto end;
  } else {
    buf = bad5;
  }

  char *bad6 = (char *)realloc(buf, 35);
  /* if (!bad6) { */
  /*   free(buf); */
  /*   return; */
  /* } else { */
  /*   buf = bad6; */
  /* } */
  *bad6 = 'a';

end:
  free(buf);
}

void realloc_func_ng_with_implicitcast(void) {
  char *buf = malloc(5);
  if (buf == NULL)
    return;

  char *bad1 = realloc(buf, 10);
  if (bad1 != NULL) {
    goto end;
  } else {
    buf = bad1;
  }

  char *bad2 = realloc(buf, 15);
  if (NULL != bad2) {
    goto end;
  } else {
    buf = bad2;
  }

  char *bad3 = realloc(buf, 20);
  if (bad3 != 0) {
    goto end;
  } else {
    buf = bad3;
  }

  char *bad4 = realloc(buf, 25);
  if (0 != bad4) {
    goto end;
  } else {
    buf = bad4;
  }

  char *bad5 = realloc(buf, 30);
  if (bad5) {
    goto end;
  } else {
    buf = bad5;
  }

  char *bad6 = realloc(buf, 35);
  /* if (!bad6) { */
  /*   free(buf); */
  /*   return; */
  /* } else { */
  /*   buf = bad6; */
  /* } */
  *bad6 = 'a';

end:
  free(buf);
}
