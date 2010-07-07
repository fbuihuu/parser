#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.h"

#define DEFAULT_PARSER	"opp"
#define MAXLINE		1024

static void usage(void)
{
	fprintf(stderr, "calc [--parser=<parser>] [--repeat=<count>]\n");
	exit(254);
}

int main(int argc, char **argv)
{
	const char *parser = DEFAULT_PARSER;
	char expr[MAXLINE];
	int (*parse)(const char *, int *);
	int ret = 0, i;
	int repeat = 1, result;

	for (i = 1; i < argc; i++) {
		const char *arg = argv[i];

		if (!strncmp(arg, "--parser=", 9)) {
			parser = arg + 9;
			continue;
		}
		if (!strncmp(arg, "--repeat=", 9)) {
			repeat = atoi(arg + 9);
			continue;
		}
		if (arg[0] == '-')
			usage();
		break;
	}

	if (i != argc)
		usage();

	if (!strcmp(parser, "rdp"))
		parse = rdp_parse_expression;
	else if (!strcmp(parser, "opp"))
		parse = opp_parse_expression;
	else {
		fprintf(stderr, "unknown parser '%s'\n", parser);
		return -1;
	}

	while (fgets(expr, MAXLINE, stdin)) {
		for (i = 0; i < repeat; i++) {
			ret = parse(expr, &result);
			if (ret)
				break;
		}
		if (ret) {
			static const char *msg[] = {
				[ERR_TOK]	= "Unknown token",
				[ERR_EOL]	= "Prematurated EOL",
				[ERR_BRACE]	= "Unbalanced brace",
				[ERR_OP]	= "Invalid operator",
			};
			fprintf(stderr, "Invalid expression, %s\n", msg[ret]);
		} else
			printf("%d\n", result);
	}
	return ret;
}
