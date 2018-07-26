exec = wi
dest = /usr/local/bin

all: compile

compile:
	swiftc wi.swift -o wi

install:
	install -m 0755 $(exec) $(dest)

link:
	ln -sf $(realpath $(exec)) $(dest)

uninstall:
	rm $(dest)/$(exec)
