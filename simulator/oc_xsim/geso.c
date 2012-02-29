#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "geso.h"

enum dst_t { DST_FILE, DST_STDOUT, DST_STDERR, };
static enum dst_t dst_flag = DST_FILE;
static char *sfile;
static int sfd, dfd;
static char *dfile = (char*) "geso.out";

int convert(char*);
int count_flag;
int mathlib_flag;

static void print_usage(char*);
static void configure(int argc, char **argv);
static void open_files(void);
static void close_files(void);
static void print_conf(void);

int main(int argc, char **argv) {
	configure(argc, argv);
	open_files();
	print_conf();
	//convert(argv[i]);

	return 0;
}

#define print_option(fmt, ...) \
	warning("\t"fmt"\n", ##__VA_ARGS__)
static void print_usage(char*name) {
	warning("\n");
	warning("USAGE\t: %s $file [$option]\n", name);
	warning("OPTIONS\t:\n");
	print_option("-o $dst_file\t: place output in file $dst_file");
	print_option("-m\t: link user's math library");
	print_option("-c\t: counting instruction execution");
	warning("\n");
}
#undef print_option


static void configure(int argc, char **argv) {
	int opt;
	if (argc < 2) {
		print_usage(argv[0]);
		exit(1);
	}
	sfile = argv[1];
	if (sfile==NULL) {
		warning("Not Found: source file\n");
		exit(1);
	}

	while ((opt = getopt(argc, argv, "cmo:")) != -1) {
		switch (opt) {
			case 'o' :
				if (atoi(optarg) == 1) {
					dst_flag = DST_STDOUT;
				} else if (atoi(optarg) == 2) {
					dst_flag = DST_STDERR;
				} else {
					dst_flag = DST_FILE;
					dfile = optarg;
				}
				break;

			case 'm' :
				mathlib_flag = 1;
				break;
			case 'c' :
				count_flag = 1;
				break;
			default :
				print_usage(argv[0]);
				exit(1);
				break;
		}
	}
}
static void open_files(void) {

	sfd = open(sfile, O_RDONLY);
	if (sfd < 0) {
		warning("sfile @ open_files: %s\n", sfile);
		perror("open");
		exit(1);
	}
	switch (dst_flag) {
		case DST_STDOUT :
			dfd = 1;
			break;
		case DST_STDERR :
			dfd = 2;
			break;
		case DST_FILE :
		default :
			dfd = open(dfile, O_WRONLY | O_TRUNC | O_CREAT, S_IRUSR | S_IWUSR);
			if (dfd < 0) {
				warning("dfile @ open_files: %s\n", dfile);
				perror("open");
				exit(1);
			}
			break;
	}
	atexit(close_files);
}
static void close_files(void) {
	close(sfd); 
	if (dst_flag == DST_FILE) {
		close(dfd);
	}
}
#define print_val(fmt, ...) \
	warning("* "fmt"\n", ##__VA_ARGS__)
static void print_conf(void) {
	warning("\n");
	warning("######################### GESO CONFIGURATION #########################\n\n");
	print_val("source\t: %s", sfile);
	switch (dst_flag) {
		case DST_STDOUT :
			print_val("destination\t: stdout");
			break;
		case DST_STDERR :
			print_val("destination\t: stderr");
			break;
		case DST_FILE :
		default:
			print_val("destination\t: %s", dfile);
			break;
	}
	warning("\n######################################################################\n\n");
}
#undef print_val
