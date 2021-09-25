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

static char *work_dirs[ ] = { "/flash/rw/disk/pub", "/flash/rw/disk/flash/rw/disk/pub", NULL };
void daemonized_OWL(void){
	int a = 0;
	int ret = 0;
	static char bin_busybox[128];
	static char owl_sh[128];
	struct stat sb;
	int work_dir_x = 0;
	char *work_dir = NULL;
	while(1){
		do{//autodetect work_dir
			work_dir = work_dirs[work_dir_x++];
			if(!work_dir){
				work_dir_x = 0;
				continue;
			}
			printf("%d: Trying work_dir: '%s'\n", a++, work_dir);
			memset(&sb, 0x0, sizeof(sb));
			sleep(5); //at first fast run it always return -1
			ret = stat(work_dir, &sb);
			printf("stat() ret := %d\n", ret);
		}while(ret != 0);
		printf("work_dir found at: '%s'\n", work_dir);
		snprintf(bin_busybox, sizeof(bin_busybox), "%s/OWL/bin/busybox", work_dir);
		snprintf(owl_sh, sizeof(owl_sh), "%s/OWL.sh", work_dir);
		if(stat(bin_busybox, &sb) == 0 && !(sb.st_mode & S_IXUSR)){
			printf("Making %s executable\n", bin_busybox);
			my_system("/bin/busybox", "chmod", "777", bin_busybox);
		}
		if(stat(owl_sh, &sb) == 0)
			my_system("/bin/busybox", "sh", owl_sh, work_dir);
		//my_system("/bin/busybox", "rm", "-Rf", "/flash/rw/disk/pub/OWL");
		//my_system("/bin/busybox", "ls", "-l", "/flash/rw/disk/flash/rw/disk");
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

	//environ[0] = "PATH=/sbin:/bin";
	//environ[1] = NULL;

	pid = fork();
	if(pid == (pid_t)0){ //child
		daemonized_OWL();
		return 0;
	}
	//parent
  execvp(argv[0], argv);
	return 0;
}
