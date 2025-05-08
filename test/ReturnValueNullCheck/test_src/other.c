#include <stdio.h>

void func_ok(void);
void func_ng(void);

void func_ok(void) {
  FILE *file1;

  if ((((file1 = fopen("a.txt", "w")))))
    return;

  if ((((file1 = (FILE *)fopen("a.txt", "w")))))
    return;

  if ((((file1 = fopen("a.txt", "w")) != NULL)))
    return;

  if (((NULL != (file1 = fopen("a.txt", "w")))))
    return;

  if ((((file1 = fopen("a.txt", "w")) != 0)))
    return;

  if (((0 != (file1 = fopen("a.txt", "w")))))
    return;

  if ((file1 = fopen("a.txt", "w")) && 1 == 1)
    return;

  if (1 == 1 && (file1 = fopen("a.txt", "w")))
    return;

  if (1 == 1 && (file1 = fopen("a.txt", "w")) && 1 == 2)
    return;

  if (1 != 1 || (file1 = fopen("a.txt", "w")) || 1 == 2)
    return;

  if ((((file1 = fopen("a.txt", "w")) && 1 == 1)))
    return;

  if ((((file1 = fopen("a.txt", "w")) || 1 == 1)))
    return;

  if (1 == 1 && ((file1 = fopen("a.txt", "w")) != NULL))
    return;

  if (1 == 1 && ((file1 = fopen("a.txt", "w")) != 0))
    return;

  while ((file1 = fopen("a.txt", "w"))) {
  }

  do {

  } while ((file1 = fopen("a.txt", "w")));

  // and so on...
}

void func_ng(void) {
  FILE *file1;
  if ((file1 = fopen("a.txt", "w")) == NULL)
    return;

  if ((!((file1 = fopen("a.txt", "w")))))
    return;

  while (!(file1 = fopen("a.txt", "w"))) {
  }

  if ((!((file1 = (FILE *)fopen("a.txt", "w")))))
    return;

  while (!(file1 = (FILE *)fopen("a.txt", "w"))) {
  }
}

/* void func_out_of_check_sample(void) { */
/* FILE *file1 = fopen("a.txt", "w"); */
/* FILE *file2 = fopen("b.txt", "w"); */
/* if (file1 && file2) { */
/* } */
/* } */
