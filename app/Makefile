TAG ?= 0.2
REGISTRY_ID ?= 873827770697
REPOSITORY_REGION ?= eu-central-1
APP_NAME ?= telebot
ENV ?= dev
REPO_NAME = $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com/${APP_NAME}-${ENV}

.PHONY: build
build:
		aws ecr get-login-password --region $(REPOSITORY_REGION) | docker login --username AWS --password-stdin $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com
		docker build -t $(REPO_NAME):$(TAG) .
		docker push $(REPO_NAME):$(TAG)