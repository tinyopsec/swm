VERSION  = 1.0

PREFIX  ?= /usr/local
DESTDIR ?=

CC      ?= cc
CFLAGS  ?= -std=c99 -pedantic -Wall -Os
CPPFLAGS = -D_POSIX_C_SOURCE=200809L -D_DEFAULT_SOURCE -DVERSION=\"$(VERSION)\"
LDFLAGS ?=
LDLIBS  ?= -lX11

BIN  = swm
OBJS = swm.o

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

swm.o: swm.c swm.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c swm.c

clean:
	rm -f $(BIN) $(OBJS)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	chmod 755 $(DESTDIR)$(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN)

.PHONY: all clean install uninstall
