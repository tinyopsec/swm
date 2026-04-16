VERSION = 1.0
PREFIX  = /usr/local
INCS = -I/usr/X11R6/include
LIBS = -L/usr/X11R6/lib -lX11
CPPFLAGS = -D_POSIX_C_SOURCE=200809L -DVERSION=\"${VERSION}\"
CFLAGS   = -std=c99 -pedantic -Wall -Wextra -Wno-unused-parameter -Os ${INCS} ${CPPFLAGS}
LDFLAGS  = ${LIBS}
CC = cc
OBJ = swm.o

all: swm

swm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

swm.o: swm.c swm.h
	${CC} -c ${CFLAGS} swm.c

clean:
	rm -f swm ${OBJ}

dist: clean
	mkdir -p swm-${VERSION}
	cp LICENSE Makefile README swm.h swm.c swm-${VERSION}
	tar -cf swm-${VERSION}.tar swm-${VERSION}
	gzip swm-${VERSION}.tar
	rm -rf swm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f swm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/swm

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/swm
