#include <pipeline.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define EXPECTED "Hello World"
#define EXPECTED_LEN (sizeof(EXPECTED)-1)

int main() {
  pipeline *p;
  int status;
  int found = 0;
  const char* line;

  p = pipeline_new ();
  pipeline_want_out(p, -1); 
  pipeline_want_infile (p, "input-file");
  pipeline_command_args (p, "zsoelim", NULL);
  pipeline_command_args (p, "tbl", NULL);
  pipeline_command_args (p, "nroff", "-mandoc", "-Tutf8", NULL);
  pipeline_start (p);
  while ((line = pipeline_readline (p))) {
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

