VERSION=v17
REPO=raintank
all: build

build:
	docker build -t ${REPO}/snap_k8s:${VERSION} .

push: build
	docker push ${REPO}/snap_k8s:${VERSION}

.PHONY: all build push
