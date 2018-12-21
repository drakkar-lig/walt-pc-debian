
IMAGE_NAME ?= waltplatform/pc-x86-32-default
ALIAS1 = waltplatform/pc-x86-32-debian:latest
ALIAS2 = waltplatform/pc-x86-32-debian:stretch

build:
	docker build --pull=true --tag=$(IMAGE_NAME) .
	docker tag $(IMAGE_NAME) $(ALIAS1)
	docker tag $(IMAGE_NAME) $(ALIAS2)

publish:
	docker push $(IMAGE_NAME)
	docker push $(ALIAS1)
	docker push $(ALIAS2)

all: build
