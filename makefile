LDFLAGS = -w
CFLAGS = -O2 -w -framework AppKit

metl: metl.m

clean:
	rm metl
