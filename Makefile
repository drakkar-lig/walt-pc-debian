
build.%:
	cd pc-x86-$* && $(MAKE) build

build-all: build.32 build.64

publish.%:
	cd pc-x86-$* && $(MAKE) publish

publish-all: publish.32 publish.64

all: build-all
