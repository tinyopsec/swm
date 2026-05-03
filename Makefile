# nwm - Nano window manager
# See LICENSE file for copyright and license details.

VERSION = 1.2

PREFIX  = /usr/local
BINDIR  = ${PREFIX}/bin

X11INC  = /usr/X11R6/include
X11LIB  = /usr/X11R6/lib

# Linux
#X11INC = /usr/include/X11
#X11LIB = /usr/lib

# FreeBSD / DragonFly
#X11INC = /usr/local/include
#X11LIB = /usr/local/lib

# NetBSD (pkgsrc)
#X11INC = /usr/pkg/include
#X11LIB = /usr/pkg/lib

INCS     = -I${X11INC}
LIBS     = -L${X11LIB} -lX11

CPPFLAGS = -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_C_SOURCE=200809L -DVERSION=\"${VERSION}\"
CFLAGS   = -std=c99 -pedantic -Wall -Wextra -Os ${INCS} ${CPPFLAGS}
#CFLAGS  = -g -std=c99 -pedantic -Wall -Wextra -O0 ${INCS} ${CPPFLAGS}
LDFLAGS  = ${LIBS}

# Solaris
#CFLAGS  = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

CC = cc

SRC = nwm.c
OBJ = ${SRC:.c=.o}

all: nwm

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: nwm.h

nwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f nwm ${OBJ}

install: all
	mkdir -p ${DESTDIR}${BINDIR}
	cp -f nwm ${DESTDIR}${BINDIR}/nwm
	chmod 755 ${DESTDIR}${BINDIR}/nwm

uninstall:
	rm -f ${DESTDIR}${BINDIR}/nwm

.PHONY: all clean install uninstall
