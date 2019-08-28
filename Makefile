.PHONY: build clean

build:
	jbuilder build

clean:
	jbuilder clean

deb:
	bash make-deb.sh
