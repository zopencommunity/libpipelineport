#include <pipeline.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {

  pipeline* pipeline;

  pipeline = pipeline_new();
  if (pipeline) {
    puts("ok");
    return 0;
  } else {
    puts("Failed");
    return 4;
  }
}

