IMAGES = base-openjre base-openjre-11 cassandra cassandra-sidecar cassandra-operator
BUILD_IMAGES = circle-build-env

.PHONY: all
all: $(IMAGES)

.PHONY: build
build: $(BUILD_IMAGES)

.PHONY: $(IMAGES)
$(IMAGES):
	$(MAKE) -C $@

.PHONY: $(BUILD_IMAGES)
$(BUILD_IMAGES):
	$(MAKE) -C $@

.PHONY: base-openjre-11
base-openjre-11:
	DEBIAN_RELEASE=buster OPENJRE_BASE_IMAGE=debian:buster OPENJRE_VERSION=11.0.6+10-1~deb10u1 OPENJRE_IMAGE_TAG=11.0.6-10-1-deb10u1 OPENJRE_IMAGE_TAG=buster OPENJDK_PACKAGE=openjdk-11-jre-headless $(MAKE) -C base-openjre

cassandra cassandra-sidecar cassandra-operator: base-openjre

.DEFAULT_GOAL := all
