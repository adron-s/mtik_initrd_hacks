#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

void my_system(char *cmd, char *arg1, char *arg2){
	char *new_argv[] = { cmd, arg1, arg2, NULL };
	pid_t pid;
	pid = fork();
	if(pid == (pid_t)0){ //child
		execvp(new_argv[0], new_argv);
		exit(0);
	}
	//parent
	waitpid(pid, NULL, 0);
}

void daemonized_OWL(void){
	//int a = 0;
	while(1){
		/*if(a++ % 10 == 0){
			printf("OWL is here! %d\n", a);
		}*/
		my_system("/bin/busybox", "sh", "/flash/rw/disk/OWL.sh");
		sleep(1);
	}
}

extern char** environ;
int main(int argc, char *argv[]){
	pid_t pid;
	int a = 0;
  //char *new_argv[] = { "/bin/busybox", "sh", "/etc/rc.d/rc.S", NULL };
  argv[0] = "/oldinit";

	environ[0] = "PATH=/sbin:/bin";
	environ[1] = NULL;

	pid = fork();
	if(pid == (pid_t)0){ //child
		daemonized_OWL();
		return 0;
	}
	//parent

  //execvp(new_argv[0], new_argv);
  execvp(argv[0], argv);
	return 0;
}
