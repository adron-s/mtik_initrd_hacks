#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

extern char** environ;

int main(int argc, char *argv[]){
  char *new_argv[] = { "/bin/busybox", "sh", "/etc/rc.d/rc.S", NULL };

	environ[0] = "PATH=/sbin:/bin";
	environ[1] = NULL;

  execvp(new_argv[0], new_argv);
	return 0;
}
