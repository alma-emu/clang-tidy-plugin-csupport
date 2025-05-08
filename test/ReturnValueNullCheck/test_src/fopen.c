#include <stdio.h>
#include <stdlib.h>

void fopen_func_ok_with_cstylecast(void);
void fopen_func_ok_with_nocast(void);
void fopen_func_ng_with_cstylecast(void);
void fopen_func_ng_with_nocast(void);

void fopen_func_ok_with_cstylecast(void) {
  const char *filename = "example.txt";

  FILE *file1 = (FILE *)fopen(filename, "w");
  if (file1 == NULL) {
    return;
  }
  fclose(file1);

  FILE *file2 = (FILE *)fopen(filename, "w");
  if (NULL == file2) {
    return;
  }
  fclose(file2);

  FILE *file3 = (FILE *)fopen(filename, "w");
  if (file3 == 0) {
    return;
  }
  fclose(file3);

  FILE *file4 = (FILE *)fopen(filename, "w");
  if (0 == file4) {
    return;
  }
  fclose(file4);

  FILE *file5 = (FILE *)fopen(filename, "w");
  if (!file5) {
    return;
  }
  fclose(file5);
}

void fopen_func_ok_with_nocast(void) {
  const char *filename = "example.txt";

  FILE *file1 = fopen(filename, "w");
  if (file1 == NULL) {
    return;
  }
  fclose(file1);

  FILE *file2 = fopen(filename, "w");
  if (NULL == file2) {
    return;
  }
  fclose(file2);

  FILE *file3 = fopen(filename, "w");
  if (file3 == 0) {
    return;
  }
  fclose(file3);

  FILE *file4 = fopen(filename, "w");
  if (0 == file4) {
    return;
  }
  fclose(file4);

  FILE *file5 = fopen(filename, "w");
  if (!file5) {
    return;
  }
  fclose(file5);
}

void fopen_func_ng_with_cstylecast(void) {
  const char *filename = "example.txt";

  FILE *badfile1 = (FILE *)fopen(filename, "w");
  if (badfile1 != NULL) {
    return;
  }
  fclose(badfile1);

  FILE *badfile2 = (FILE *)fopen(filename, "w");
  if (NULL != badfile2) {
    return;
  }
  fclose(badfile2);

  FILE *badfile3 = (FILE *)fopen(filename, "w");
  if (badfile3 != 0) {
    return;
  }
  fclose(badfile3);

  FILE *badfile4 = (FILE *)fopen(filename, "w");
  if (0 != badfile4) {
    return;
  }
  fclose(badfile4);

  FILE *badfile5 = (FILE *)fopen(filename, "w");
  if (badfile5) {
    return;
  }
  fclose(badfile5);

  FILE *badfile6 = (FILE *)fopen(filename, "w");
  /* if (!badfile6) { */
  /*   return; */
  /* } */
  fclose(badfile6);
}

void fopen_func_ng_with_nocast(void) {
  const char *filename = "example.txt";

  FILE *badfile1 = fopen(filename, "w");
  if (badfile1 != NULL) {
    return;
  }
  fclose(badfile1);

  FILE *badfile2 = fopen(filename, "w");
  if (NULL != badfile2) {
    return;
  }
  fclose(badfile2);

  FILE *badfile3 = fopen(filename, "w");
  if (badfile3 != 0) {
    return;
  }
  fclose(badfile3);

  FILE *badfile4 = fopen(filename, "w");
  if (0 != badfile4) {
    return;
  }
  fclose(badfile4);

  FILE *badfile5 = fopen(filename, "w");
  if (badfile5) {
    return;
  }
  fclose(badfile5);

  FILE *badfile6 = fopen(filename, "w");
  /* if (!badfile6) { */
  /*   return; */
  /* } */
  fclose(badfile6);
}
