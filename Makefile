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

ignores:
	mkdir -f ignores

ignore-%: ignores
	@snyk container test $(REPO)/$(NAME) --file=$(NAME)/Dockerfile --json | jq  '[.vulnerabilities[] | .id] | unique | .[]' | xargs -L1 -I'{}' snyk ignore --id='{}' --reason="Base image vulnerability from $(REPO)/$(NAME)"
	@mv .snyk ignores/$(NAME).snyk
	@sed -i '' '/expires/d' ignores/$(NAME).snyk

ignore: ignore-base ignore-middleware

monitor: monitor-base monitor-middleware monitor-app

monitor-base:
	@snyk container monitor $(REPO)/$(NAME) --file=$(NAME)/Dockerfile --project-name=$(REPO)/$(NAME)

monitor-middleware:
	@snyk container monitor $(REPO)/$(NAME) --file=$(NAME)/Dockerfile --policy-path=ignores/base.snyk --project-name=$(REPO)/$(NAME)

monitor-app:
	@snyk container monitor $(REPO)/$(NAME) --file=$(NAME)/Dockerfile --policy-path=ignores/middleware.snyk --project-name=$(REPO)/$(NAME)

base middleware app: check-buildkit
	@$(BUILD) $(REPO)/$@ $@

.PHONY: build base middleware app monitor monitor-% snyk-% ignore-% ignore
