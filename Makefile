PROGS = calc
CC = gcc
CFLAGS = -ggdb3 -Wall -Werror

OBJS = opp.o rdp.o calc.o

.PHONY: clean all

all: $(PROGS)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

calc: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(filter %.o,$^)

clean:
	rm -f $(PROGS)
	rm -f $(OBJS)
	rm -f TAGS

TAGS:
	git ls-files \*.[ch] | xargs etags

#dependencies
opp.o: opp.c parser.h
rdp.o: rdp.c parser.h
calc: parser.h