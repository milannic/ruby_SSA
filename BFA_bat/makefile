CC = /usr/bin/gcc
CFLAGS = -g -O4 -I.. 

all:	main blank exe

clean:
	-rm *.o
	-rm trace
	-rm empty

.c.o:
	${CC} ${CFLAGS} -c $<

trace_v7.o : trace_v7.c
trace_blank_v7.o : trace_blank_v7.c

main:  trace_v7.o
	${CC} ${CFLAGS}  trace_v7.o  -o	trace 
blank:  trace_blank_v7.o
	${CC} ${CFLAGS}  trace_blank_v7.o  -o  empty

exe:
	-chmod a+x trace
	-chmod a+x empty
