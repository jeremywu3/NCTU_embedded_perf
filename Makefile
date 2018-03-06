CC ?= gcc
CFLAGS ?= -Wall -std=gnu99 -g3 -DDEBUG -O0

EXEC = pi matrix
GIT_HOOKS := .git/hooks/applied
.PHONY: all
all: $(GIT_HOOKS) $(EXEC)

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

SRCS_common = main.c

pi: $(SRCS_common) pi.c
	$(CC) $(CFLAGS_common) \
		-o pi.o -DPI -DHEADER="\"$@.h\"" \
		$(SRCS_common) pi.c

matrix: $(SRCS_common) matrix.c
	$(CC) $(CFLAGS_common) \
		-o matrix.o -DMATRIX -DHEADER="\"$@.h\"" \
		$(SRCS_common) matrix.c

cache-test: $(EXEC)
	perf stat --repeat 5 \
		-e cache-misses,cache-references,instructions,cycles \
		./matrix

plot: output.txt
	gnuplot scripts/runtime.gp

.PHONY: clean
clean:
	$(RM) $(EXEC) *.o perf.*
