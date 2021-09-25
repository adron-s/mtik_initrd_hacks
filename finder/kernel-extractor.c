#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

void die(int code){
	fprintf(stderr, "Dieing with exit code = %d\n", code);
	exit(code);
}

static inline uint32_t swab32(uint32_t x)
{
	return x << 24 | x >> 24 |
		(x & (uint32_t)0x0000ff00UL)<<8 |
		(x & (uint32_t)0x00ff0000UL)>>8;
}

static unsigned char data[64 * 1024 * 1024];

/* kernel header is 20 bytes:
	   kernel start magic(8 bytes) - 07 00 01 00 00 00 0A 04
	   kernel size(4 bytes) - variable
	   tail magic(3 bytes) - 00 78 01
	   chunks header-splitter(5 bytes) - 00 00 80 FF 7F or something else(for last chunk)
*/
void *do_kernel_start_search(unsigned char *p, void *end){
	uint64_t *k;
	typeof(p) start = p;
	do{
		k = (void*)p;
		if(*k == 0x040A000000010007LLU){ //check for kernel start magic value
			printf("Kernel header(start magic) is found at: 0x%08lx\n", (void *)p - (void*)start);
			//printf("Kernel size: %u bytes\n", swab32(*(uint32_t *)(k + 1))); //TODO: !!!! ??? !!!
			k = (void *)k + 8 + 4; //to tail magic
			/* printf("0x%08lx: %02X %02X %02X, %016lX\n", ((void*)p - (void*)data),
				p[12], p[13], p[14], *k); */
			if(*k == 0x7FFF800000017800LL){ //check for tail and chunk splitter values
				return (void*)p + 15; //return pointer to first chinks splitter
			}
		}
		p = (void *)p + 1;
	}while((void*)p + 20 <= end);
	return NULL;
}

static inline void *do_kernel_extract_OLD(unsigned char *p, void *end, char *file_name){
	int fd;
	fd = open(file_name, O_WRONLY | O_CREAT);
	size_t len;
	int count = 0;
	if(fd < 0)
		die(-11);
	do{
		//usually chunks are 32768 bytes in size
		if(p[4] == 0x7F && p[3] == 0xFF && p[2] == 0x80 && p[1] == 0x00 && p[0] == 0x00){
			//printf("%02X %02X %02X %02X %02X\n", p[4], p[3], p[2], p[1], p[0]);
			p += 5; //skip chinks splitter
			len = write(fd, p, 0x8000);
			//printf("writing chunk %d, len = %zd bytes\n", count, len);
			count++;
			if(len != 0x8000){
				fprintf(stderr, "write to result file '%s' len < 0x8000: %zd\n", file_name, len);
				break;
			}
			p += len;
		}else{ //but the last chunk may be less
			//fprintf(stderr, "UNKNOWN tail is: %zd bytes !!!\n", end - (void*)p);
			printf("%02X %02X %02X %02X %02X\n", p[4], p[3], p[2], p[1], p[0]);
			len = p[2] << 8 | p[1]; //try to extract current chunk len from chunk header
			p += 5; //skip chinks splitter
			if(len > end - (void*)p)
				len = end - (void*)p;
			//last chunk?
			len = write(fd, p, len);
			printf("last chunk len: %zd\n", len);
			count++;
			break;
		}
	}while((void*)p + 5 <= end);
	printf("Successfully writed %d chunks to '%s'\n", count, file_name);
	close(fd);
}

void *do_kernel_extract(unsigned char *p, void *end, char *file_name){
	int fd;
	typeof(p) start = p;
	fd = open(file_name, O_WRONLY | O_CREAT);
	size_t len, chunk_size, total_size = 0;
	int count = 0;
	if(fd < 0)
		die(-11);
	do {
		int is_last_chunk = p[0] == 1;
		chunk_size = p[2] << 8 | p[1]; //extract current chunk len from chunk header(5 bytes)
		printf("%04d: 0x%08lx: (%zd + 5): %02X %02X %02X %02X %02X\n", count,
			(void *)p - (void*)start,	chunk_size, p[4], p[3], p[2], p[1], p[0]);
		p += 5; //skip chunk header(splitter)
		if (chunk_size > (end - (void*)p)) {
			printf("   !!! Current chunk size is bigger that rest data size ! %zd > %zd !\n"
				"   Source file was truncated ???\n", chunk_size, (end - (void*)p));
			break;
		}
		len = write(fd, p, chunk_size);
		//printf("writing chunk %d, len = %zd bytes\n", count, len);
		count++;
		if (len != chunk_size) {
			fprintf(stderr, "write to result file '%s' len %zd != %zd\n", file_name, chunk_size, len);
			break;
		}
		total_size += len;
		p += chunk_size;
		if (is_last_chunk)
			break;
	} while ((void*)p + 5 <= end);
	printf("Successfully writed %d chunks(%zd bytes) to '%s'\n", count,
		total_size, file_name);
	close(fd);
}

int main(int argc, char *argv[]){
	int fd;
	void *start;
	size_t len;
	if(argc !=3)
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
	start = do_kernel_start_search(data, (void*)data + len);
	if(!start){
		fprintf(stderr, "Can't find kernel start magic(64 bits)\n");
		die(-4);
	}
	printf("...search is Ended\n");
	printf("kernel start offset is fount at: 0x%08lx\n", start - (void*)data);
	do_kernel_extract(start, (void*)data + len, argv[2]);
	return 0;
}
