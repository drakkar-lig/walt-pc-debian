
build.%:
	cd pc-x86-$* && $(MAKE) build

build: build.32 build.64

publish.%:
	cd pc-x86-$* && $(MAKE) publish

publish: publish.32 publish.64

all: build
