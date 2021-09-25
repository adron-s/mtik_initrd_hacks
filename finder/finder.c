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
	void *last_p, *end;
	size_t rest_size;
	size_t total_payload_size = 0;
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
	end = (void*)data + len;
	last_p = data;
	p = (void*)data;
	//p += 0x2F4D;
	do{
		if(*(uint64_t *)p == 0x040A000000010007LLU){ //check for kernel start magic value
			printf("Kernel start magic is found at: 0x%08lx\n", (void*)data - (void*)p);
			last_p = p;
			last_p = p = (void*)p + 15;
		}

		//chunk header(5 bytes)
		//if(p[4] == 0x7F && p[3] == 0xFF && p[2] == 0x80 && p[1] == 0x00 && p[0] == 0x00){
		//if(p[4] == 0x7F && p[3] == 0xFF && p[0] == 0x00){
		if (p[0] == 0 || p[0] == 1) {
			int prev_block_size = p != last_p ? ((void*)p - last_p) - 5 : 0;
			int hdr_chunk_len = p[2] << 8 | p[1];
			total_payload_size += hdr_chunk_len;
			if (prev_block_size != 0x8000 && last_p != p)
				printf("   !!! Unusual chunk size: %d !!!\n", prev_block_size);
			printf("%04d: 0x%08lx: (%d + 5): %02X %02X %02X %02X %02X\n", count++,
				((void*)p - (void*)data),	hdr_chunk_len,
				p[4], p[3], p[2], p[1], p[0]);
			last_p = p;
			rest_size = end - ((void*)p + 5 + hdr_chunk_len);
			if (p[0] == 1)
				break;
			p += 5 + hdr_chunk_len;
		}
		//p = (void *)p + 1;
	}while((void*)p + 4 < end);
	p = end - rest_size;
	//printf("Last tailed chunk size: %d + 5: [ %02x %02x ]\n", p[2] << 8 | p[1], p[1], p[2]);
	printf("Payload total size is: %zd\n", total_payload_size);
	printf("Garbage(tail) size is: %zd\n", rest_size);
	printf("Total blocks is: %d\n", count);
	printf("...search is Ended\n");
	return 0;
}
