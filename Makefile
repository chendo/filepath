CFLAGS=-std=c99
LDFLAGS=-lobjc -framework Cocoa
OBJS=filepath.o DocumentPath.o CopyLaunchedApplicationsInFrontToBackOrder.o

.PHONY: clean install

filepath: $(OBJS)

install: filepath
	cp $< /usr/local/bin/

clean:
	rm -f *.o filepath
