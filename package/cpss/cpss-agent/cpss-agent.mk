################################################################################
#
# cpss-appdemo
#
################################################################################

CPSS_AGENT_VERSION ?= d0bf37e06866fcbb1a0e80cbca499f4751b75313
CPSS_AGENT_SITE ?= $(CPSS_SITE)/switchdev-binaries
CPSS_AGENT_SITE_METHOD ?= $(CPSS_SITE_METHOD)
CPSS_AGENT_DEPENDENCIES = libarchive

ifeq ($(CPSS_AGENT_SITE),)
CPSS_AGENT_SITE := unknown
endif

define CPSS_AGENT_INSTALL_TARGET_CMDS
	ls -la $(@D)
	find $(@D)
	tar --xz -xvf $(@D)/packages/sw-agentd/sw-agentd-3.2.2.tar.xz -C $(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/etc/mvsw;
endef

define CPSS_AGENT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(CPSS_AGENT_PKGDIR)/S90agent \
		$(TARGET_DIR)/etc/init.d/S90agent
endef

$(eval $(generic-package))
