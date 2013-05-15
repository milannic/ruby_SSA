CC = /usr/bin/gcc
CFLAGS = -g -O4 -I.. 

all:	main blank exe

clean:
	-rm *.o
	-rm dfa_nas*
	-rm cache_empty*

.c.o:
	${CC} ${CFLAGS} -c $*.c 

main.o : main.c
blank.o : blank.c

main:  main.o
	${CC} ${CFLAGS}  main.o  -o dfa_nas 
blank:  blank.o
	${CC} ${CFLAGS}  blank.o  -o  cache_empty

exe:
	-chmod a+x dfa_nas
	-chmod a+x cache_empty
