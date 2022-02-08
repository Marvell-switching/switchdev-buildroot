################################################################################
#
# prestera-driver
#
################################################################################

PRESTERA_DRIVER_VERSION = $(LINUX_VERSION)
PRESTERA_DRIVER_SITE = $(LINUX_DIR)/drivers/net/ethernet/marvell/prestera
PRESTERA_DRIVER_SITE_METHOD = local

PRESTERA_DRIVER_MODULE_MAKE_OPTS = \
	CONFIG_PRESTERA=m \
	CONFIG_PRESTERA_PCI=m \
	KVER=$(LINUX_VERSION) \
	KSRC=$(LINUX_DIR)

ifeq ($(PRESTERA_DRIVER_SPARSE),y)
PRESTERA_DRIVER_MODULE_MAKE_OPTS += C=2 CHECK="sparse -Wsparse-error"
endif

ifeq ($(BR2_PACKAGE_PRESTERA_DRIVER_IPC_TRAMPOLINE),y)
PRESTERA_DRIVER_MODULE_MAKE_OPTS += CONFIG_PRESTERA_SHM=m
endif

ifeq ($(CONFIG_MRVL_PRESTERA_DEBUG),y)
PRESTERA_DRIVER_MODULE_MAKE_OPTS += CONFIG_MRVL_PRESTERA_DEBUG=y
endif

define PRESTERA_DRIVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(PRESTERA_DRIVER_PKGDIR)/S70prestera-swdev-drivers \
		$(TARGET_DIR)/etc/init.d/S70prestera-swdev-drivers
endef

$(eval $(kernel-module))
$(eval $(generic-package))
