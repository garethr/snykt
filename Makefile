REPO := snykt
BUILD = docker build -t

NAME=$$(echo $@ | cut -d "-" -f 2)

default: build

check-buildkit:
ifndef DOCKER_BUILDKIT
	$(error You must enable Buildkit for Docker, by setting DOCKER_BUILDKIT=1)
endif

build: base middleware app

snyk-base:
	@snyk container test $(REPO)/$(NAME) --file=$(NAME)/Dockerfile

snyk-%:
	@snyk container test $(REPO)/$(NAME) --file=$(NAME)/Dockerfile --exclude-base-image-vulns

*:
	@$(BUILD) $(REPO)/$@ $@

.PHONY: base middleware app snyk-%
