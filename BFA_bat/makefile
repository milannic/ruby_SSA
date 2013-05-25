CC = /usr/bin/gcc
CFLAGS = -g -O4 -I.. 

all:	main exe

clean:
	-rm *.o
	-rm trace

.c.o:
	${CC} ${CFLAGS} -c $<

trace.o : trace.c

main:  trace.o
	${CC} ${CFLAGS}  trace.o  -o	trace 

exe:
	-chmod a+x trace
