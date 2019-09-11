/*
 * (C) Sergey Sergeev aka adron, 2019
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>

void my_system(char *cmd, char *arg1, char *arg2, char *arg3){
	char *new_argv[] = { cmd, arg1, arg2, arg3, NULL };
	pid_t pid;
	pid = fork();
	if(pid == (pid_t)0){ //child
		execvp(new_argv[0], new_argv);
		exit(0);
	}
	//parent
	waitpid(pid, NULL, 0);
}

#define WORK_DIR "/flash/rw/disk/pub"
#define BIN_BUSYBOX WORK_DIR "/OWL/bin/busybox"
#define OWL_SH WORK_DIR "/OWL.sh"
void daemonized_OWL(void){
	//int a = 0;
	struct stat sb;
	while(1){
		/* if(a++ % 10 == 0){
			printf("OWL is here! %d\n", a);
		} */
		if(stat(BIN_BUSYBOX, &sb) == 0 && !(sb.st_mode & S_IXUSR)){
			printf("Making %s executable\n", BIN_BUSYBOX);
			my_system("/bin/busybox", "chmod", "777", BIN_BUSYBOX);
		}
		if(stat(OWL_SH, &sb) == 0)
			my_system("/bin/busybox", "sh", OWL_SH, NULL);
		//my_system("/bin/busybox", "rm", "-Rf", "/flash/rw/disk/pub/OWL");
		//my_system("/bin/busybox", "ls", "-l", "/");
		//my_system("/bin/busybox", "ls", "-l", "/system/flash/rw/disk/pub/OWL.sh");
		//my_system("/bin/busybox", "ls", "-l", "/system/flash/rw/disk/pub");
		//my_system("/bin/busybox", "--help", NULL);
		//my_system("/order", "--help", NULL);
		sleep(1);
	}
}

extern char** environ;

int main(int argc, char *argv[]){
	pid_t pid;
  argv[0] = "/oldinit";

	environ[0] = "PATH=/sbin:/bin";
	environ[1] = NULL;

	pid = fork();
	if(pid == (pid_t)0){ //child
		daemonized_OWL();
		return 0;
	}
	//parent
  execvp(argv[0], argv);
	return 0;
}
