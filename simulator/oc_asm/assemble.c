#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include "oc_asm.h"

enum linst_access_t { REL_ACC, ABS_ACC, LINST_SETL };
typedef struct inst_with_label_t {
	int line;
	char lname[COL_MAX];
	enum linst_access_t acc;
} linst_t;

static inline int set_term0(char*,char*);
static inline int is_directive(char*,char*);
static inline int is_label(char*,char*);
static inline int is_comment(char*,char*);
static inline void output_data(uint32_t data);
static inline void register_label(char*, char*);
static inline void encode_and_output(char*, char*);
static inline void register_linst_setl(char *);
static void _register_linst(char *lname, enum linst_access_t acc);
static void exec_directive(char*, char*);
static void resolve_label(void);

static int input_line_cnt;
static int output_cnt;
static int err_cnt;
static linst_t map_lcnt_linst[LINE_MAX];
static int  registered_linst_cnt;
static uint32_t *output_alias;

#define print_asm_line() \
	warning(">>> %s", asm_line)
#define _myerr(fmt, ...) \
	warning("Error %d Line %d : "fmt"\n", ++err_cnt, input_line_cnt, ##__VA_ARGS__)
#define myerr(fmt, ...) \
	do { \
		_myerr(fmt, ##__VA_ARGS__); \
		print_asm_line(); \
	} while(0) 


int assemble(char *asm_buf, uint32_t *out_buf) {
	char asm_line[LINE_MAX];
	char term0[LINE_MAX];
	output_alias = out_buf;

	while (mygets(asm_line, asm_buf, COL_MAX) != NULL) {
		if (set_term0(asm_line, term0) == 1) {
			if (is_comment(asm_line, term0)) {
				// blank(comment)
			} else if (is_directive(asm_line, term0)) {
				exec_directive(asm_line, term0);
			} else if (is_label(asm_line, term0)) {
				register_label(asm_line, term0);
			} else { 
				encode_and_output(asm_line, term0);
			}
		} else {
			// blank(empty line)
		}
		input_line_cnt++;
	}

	resolve_label();

	return output_cnt;
}

#define get_opcode(ir) eff_dig(6, shift_right_a(26, ir))
static void resolve_label(void) {
	int i, label_line;
	label_t label;
	linst_t linst;
	for (i=0; i<registered_linst_cnt; i++) {
		linst = map_lcnt_linst[i];
		strcpy(label.name, linst.lname);
		label.len = strlen(label.name);
		if ((label_line = hash_find(label))<0) {
			_myerr("label not found @ resolve_label.hash_find\n>>> %s", label.name);
		}

		switch (linst.acc) {
			case REL_ACC :
				output_alias[linst.line] |= eff_dig(16,(label_line - linst.line));
				break;
			case ABS_ACC :
				output_alias[linst.line] |= eff_dig(26, (label_line));
				break;
			case LINST_SETL :
				output_alias[linst.line] |= eff_dig(16, (label_line-1)*4);
				break;
			default :
				warning("Unexpected case @ resolve_label.linst.acc\n");
				break;
		}

	}

}

void register_linst_abs(char* lname) { _register_linst(lname, ABS_ACC); }
void register_linst_rel(char* lname) { _register_linst(lname, REL_ACC); }
static void register_linst_setl(char* lname) { _register_linst(lname, LINST_SETL); }
static void _register_linst(char* lname, enum linst_access_t acc) {
	linst_t linst = {
		.line = output_cnt,
		.acc = acc,
	};
	strcpy(linst.lname, lname);
	map_lcnt_linst[registered_linst_cnt] = linst;

	registered_linst_cnt++;
}
static inline void register_label(char *asm_line, char *term0) {
	char *label_name;
	label_t label;
	if ((label_name = strtok(term0, ":")) != NULL) {
		label.len = strlen(label_name);
		strcpy(label.name, label_name);
		label.line = output_cnt;
		if (hash_insert(label)<0) {
			myerr("duplicate label @ register_label.hash_insert");
		}
	} else {
		myerr("register label");
	}
}


static inline void output_data(uint32_t data) {
	output_alias[output_cnt++] = data;
}
static inline void encode_and_output(char*asm_line, char*term0) {
	uint32_t ir = encode_op(asm_line, term0);
	if (ir == 0xffffffff) {
		myerr("Unknown instruction @ encode_op");
	}
	output_data(ir);
}
static inline int _directive_is(char *line, const char* str) {
	return strstr(line, str) != NULL;
}
#define directive_is(str) _directive_is(asm_line, "."str)
static void exec_directive(char *asm_line, char *term0) {
	int heap_size;
	uint32_t data;
	int reg_num;
	char line[COL_MAX], lname[COL_MAX];

	if (directive_is("init")) { // init 
		if ((output_cnt == 0) &&
			(sscanf(asm_line, " .init_heap_size %d", &heap_size) == 1)) {
			output_data((uint32_t)heap_size/8);
		} else {
			myerr("init directive");
		}
	} else if (directive_is("long")) { // data(.long)
	 	if (sscanf(asm_line, " .long 0x%x", &data) == 1) {
			output_data(data);
		} else {
			myerr("long directive");
		}
	} else if (directive_is("setL")) { // setL
		if(sscanf(asm_line, " .setL %%g%d, %s", &reg_num, lname) == 2) {
			register_linst_setl(lname);
			sprintf(line, asm_fmt_iggi, "addi", reg_num, 0, 0);
			encode_and_output(line, "addi");
		} else {
			myerr("setL directive");
		}
	}
}
static inline int set_term0(char *line, char *term0) {
	return sscanf(line, "%s", term0);
}
static inline int is_directive(char*line, char *term0) {
	return term0[0] == '.';
}
static inline int is_label(char*line, char *term0) {
	return strchr(line,':') != NULL;
}
static inline int is_comment(char*line, char *term0) {
	return term0[0] == '!';
}
