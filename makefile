LDFLAGS = -w
CFLAGS = -O2 -w -framework Metal \
                -framework MetalKit \
                -framework AppKit

metl: metl.m

clean:
	rm metl
