LDFLAGS = -w
CFLAGS = -O2 -w -framework Foundation -framework AppKit

metl: metl.m

clean:
	rm metl
