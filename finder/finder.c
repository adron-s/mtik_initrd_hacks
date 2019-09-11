#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

/* kernel-XXX.elf получаемое из npk файла напрямую не может быть распакован. xz ругается на повреждение данных!
	 сравнительный анализ показал что в данных действительно содержится мусор: [ 7F FF 80 00 00 ]
	 и так каждые 0x8000 байт.

	 kernel-XXX.elf that obtained from an npk file cannot be directly decompressed. xz reports about data corruption!
   A comparative analysis showed that the data does contain the garbage: [7F FF 80 00 00]
   and so every 0x8000 bytes.
*/

void die(int code){
	fprintf(stderr, "Dieing with exit code = %d\n", code);
	exit(code);
}

static unsigned char data[64 * 1024 * 1024];
int main(int argc, char *argv[]){
	int fd;
	unsigned char *p;
	void *last_p;
	int count = 0;
	size_t len;
	if(argc !=2)
		die(-1);
	fd = open(argv[1], O_RDONLY);
	if(fd < 0)
		die(-2);
	memset(data, 0x0, sizeof(data));
	len = read(fd, data, sizeof(data));
	close(fd);
	if(len <= 0)
		die(-3);
	printf("Successfully readed %zd bytes\n", len);
	printf("Begin of search...\n");
	last_p = (void*)data;
	p = (void*)data;
	p += 0x2F4D;
	do{
		if(p[4] == 0x7F && p[3] == 0xFF && p[2] == 0x80 && p[1] == 0x00 && p[0] == 0x00){
		//if(1){
			printf("%04d: 0x%08lx: %lu: %02X %02X %02X %02X %02X\n", count++,
				((void*)p - (void*)data),
				(void*)p - last_p, p[4], p[3], p[2], p[1], p[0]);
			last_p = p;
		}
		p = (void *)p + 1;
	}while((void*)p + sizeof(data[0]) - (void*)data < len);
	printf("...search is Ended\n");
	return 0;
}
