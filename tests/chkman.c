#include <pipeline.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define EXPECTED "MAN(1)"
#define EXPECTED_LEN (sizeof(EXPECTED)-1)

int main(int argc, char* argv[]) {
  pipeline *p;
  int status;
  int found = 0;
  const char* line;
  int cols;
  char* file;

  if (argc != 3) {
    fprintf(stderr, "Expected 2 parms <cols> <manfile>\n");
    return 4;
  }
  cols = atoi(argv[1]);
  file = argv[2];

  p = pipeline_new ();
  pipeline_want_out(p, -1); 
  pipeline_want_infile (p, file);
  pipeline_command_args (p, "zsoelim", NULL);
  pipeline_command_args (p, "manconv", "-f", "UTF-8:ISO-8859-1", "-t", "UTF-8//IGNORE", NULL);
  pipeline_command_args (p, "preconv", "-e", "UTF-8", NULL);
  pipeline_command_args (p, "tbl", NULL);
  pipeline_command_args (p, "nroff", "-mandoc", "-rLL=80n", "-rLT=80n", "-Tutf8", NULL);
  pipeline_start (p);
  while ((line = pipeline_readline (p))) {
    fprintf(stderr, "%s", line);
    if (strlen(line) >= EXPECTED_LEN && !memcmp(line, EXPECTED, EXPECTED_LEN)) {
      found=1;
    } 
  }
  pipeline_free (p);
  if (found)  {
    puts("ok");
    return 0;
  } else {
    puts("Failed");
    return 4;
  }
}

