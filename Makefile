PROJECTDIR := $(shell pwd)

CHARTDIR    := $(PROJECTDIR)/charts
CHARTS      := $(shell find $(CHARTDIR) -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
MANIFESTDIR := $(PROJECTDIR)/replicated
MANIFESTS   := $(shell find $(MANIFESTDIR) -name '*.yaml' -o -name '*.yml')

VERSION     ?= $(shell yq .version $(CHARTDIR)/app/Chart.yaml)
CHANNEL     ?= $(shell git branch --show-current)
ifeq ($(CHANNEL), main)
	CHANNEL=Unstable
endif

BUILDDIR      := $(PROJECTDIR)/build
RELEASE_FILES :=

define make-manifest-target
$(BUILDDIR)/$(notdir $1): $1 | $$(BUILDDIR)
	cp $1 $$(BUILDDIR)/$$(notdir $1)
RELEASE_FILES := $(RELEASE_FILES) $(BUILDDIR)/$(notdir $1)
manifests:: $(BUILDDIR)/$(notdir $1)
endef
$(foreach element,$(MANIFESTS),$(eval $(call make-manifest-target,$(element))))

define make-chart-target
$(eval VER := $(shell yq .version $(CHARTDIR)/$1/Chart.yaml))
$(BUILDDIR)/$1-$(VER).tgz : $(CHARTDIR)/$1 $(shell find $(CHARTDIR)/$1 -name '*.yaml' -o -name '*.yml' -o -name "*.tpl" -o -name "NOTES.txt" -o -name "values.schema.json") | $$(BUILDDIR)
	helm package -u $(CHARTDIR)/$1 -d $(BUILDDIR)/
RELEASE_FILES := $(RELEASE_FILES) $(BUILDDIR)/$1-$(VER).tgz
charts:: $(BUILDDIR)/$1-$(VER).tgz
endef
$(foreach element,$(CHARTS),$(eval $(call make-chart-target,$(element))))

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

.PHONY: build
build: $(BUILDDIR)

.PHONY: lint
lint: lint-helm lint-replicated

.PHONY: lint-helm
lint-helm:
	helm lint $(CHARTDIR)/app

.PHONY: lint-replicated
lint-replicated: $(RELEASE_FILES)
	@test -n "$(REPLICATED_APP)" || { echo "Error: REPLICATED_APP is not set"; exit 1; }
	replicated release lint --app $(REPLICATED_APP) --yaml-dir $(BUILDDIR)

.PHONY: release
release: $(RELEASE_FILES)
	@test -n "$(REPLICATED_APP)" || { echo "Error: REPLICATED_APP is not set"; exit 1; }
	replicated release create \
		--app $(REPLICATED_APP) \
		--version $(VERSION) \
		--yaml-dir $(BUILDDIR) \
		--ensure-channel \
		--promote $(CHANNEL)

.PHONY: hooks
hooks:
	git config core.hooksPath .githooks

.PHONY: changelog
changelog:
	docker run --rm --platform linux/amd64 -v "$(PROJECTDIR):/data" mogensen/helm-changelog:latest

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)
