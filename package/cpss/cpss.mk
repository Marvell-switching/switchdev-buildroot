################################################################################
#
# cpss
#
################################################################################

ifndef CPSS_OVERRIDE_SRCDIR
ifeq ($(BR2_PACKAGE_CPSS_USE_CUSTOM_VERSION),y)
CPSS_VERSION ?= $(call qstrip,$(BR2_PACKAGE_CPSS_CUSTOM_VERSION))
else
CPSS_VERSION ?= master
endif
endif

CPSS_SITE = $(PRESTERA_REPO_SITE)
CPSS_SITE_METHOD = git

include $(sort $(wildcard $(BR2_EXTERNAL_PRESTERA_PATH)/package/cpss/*/*.mk))

cpss-rebuild: $(foreach p,$(filter cpss-%,$(PACKAGES)),$(p)-rebuild)
cpss-dirclean: $(foreach p,$(filter cpss-%,$(PACKAGES)),$(p)-dirclean)
cpss-deploy: $(foreach p,$(filter cpss-%,$(PACKAGES)),$(p)-deploy)
	@:
