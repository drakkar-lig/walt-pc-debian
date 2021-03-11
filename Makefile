
DEBIAN_VERSION = buster

build.%:
	docker build -f pc-x86-$*/Dockerfile --pull=true \
			--tag=waltplatform/pc-x86-$*-default .
	docker tag waltplatform/pc-x86-$*-default \
				waltplatform/pc-x86-$*-debian:latest
	docker tag waltplatform/pc-x86-$*-default \
				waltplatform/pc-x86-$*-debian:$(DEBIAN_VERSION)

build-all: build.32 build.64

publish.%:
	docker push waltplatform/pc-x86-$*-default
	docker push waltplatform/pc-x86-$*-debian:latest
	docker push waltplatform/pc-x86-$*-debian:$(DEBIAN_VERSION)

publish-all: publish.32 publish.64

all: build-all
