help:
	@cat Makefile

GPU?=0
DOCKER_FILE=Dockerfile
BACKEND=tensorflow
PYTHON_VERSION?=3.6
SRC?=$(shell dirname `pwd`)

build:
	docker build -t ml_engine --build-arg python_version=$(PYTHON_VERSION) -f $(DOCKER_FILE) .

bash: build
	docker run -it -v $(SRC):/mnist --env KERAS_BACKEND=$(BACKEND) ml_engine bash
