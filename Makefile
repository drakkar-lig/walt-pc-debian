
IMAGE_NAME ?= walt-platform/walt-node:pc-x86-64-debian-stretch

build:
	docker build --pull=true --tag=$(IMAGE_NAME) .

publish:
	docker push $(IMAGE_NAME)

all: build
