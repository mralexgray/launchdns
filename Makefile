CC = cc
CFLAGS = -Wall
INSTALL = /usr/bin/install
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
BATS = test/bats/bin/bats
SOURCES = main.c
EXECUTABLE = launchdns
LAUNCH_H := $(shell echo "\#include <launch.h>" | cc -E - &>/dev/null; echo $$?)

ifeq ($(LAUNCH_H),0)
	CFLAGS+=-DHAVE_LAUNCH_H
endif

all: $(EXECUTABLE)

$(EXECUTABLE): main.c
	$(CC) $(CFLAGS) -o $@ $<

install: $(EXECUTABLE)
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) $(EXECUTABLE) $(BINDIR)/$(EXECUTABLE)

$(BATS):
	git submodule init
	git submodule update

clean:
	rm -f $(EXECUTABLE)

test: all $(BATS)
ifdef $CI
		$(BATS) --taps ./test
else
		$(BATS) ./test
endif

.PHONY: install clean test
