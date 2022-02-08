################################################################################
#
# platform-drivers
#
################################################################################

PLATFORM_DRIVERS_SITE = $(BR2_EXTERNAL_PRESTERA_PATH)/local_sources/platform_drivers
PLATFORM_DRIVERS_SITE_METHOD = local
PLATFORM_DRIVERS_VERSION = 1.0

# Dirty hack for SDK: since 'SDK' doesn't clone/build linux, 'hide'
# any kernel-module related stuff (especially eval $(kernel-module))

ifeq ($(BR2_PRESTERA_SDK),)

PLATFORM_DRIVERS_MODULE_MAKE_OPTS = \
	KVER=$(LINUX_VERSION) \
	KSRC=$(LINUX_DIR)

ifeq ($(BR2_PACKAGE_PLAT_GPIO_I2C),y)
PLATFORM_DRIVERS_MODULE_MAKE_OPTS += CONFIG_PLAT_GPIO_I2C=m
endif

define PLATFORM_DRIVERS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(PLATFORM_DRIVERS_PKGDIR)/S70platform-drivers \
		$(TARGET_DIR)/etc/init.d/S70platform-drivers
endef

$(eval $(kernel-module))

else # BR2_PRESTERA_SDK

PLATFORM_DRIVERS_DIST_NAME = platform-drivers

define PLATFORM_DRIVERS_BUILD_CMDS
	rm -rf $(@D)/dist;
	mkdir $(@D)/dist;
	( cd $(@D)/dist; \
		rm -rf $(PLATFORM_DRIVERS_DIST_NAME); \
		mkdir $(PLATFORM_DRIVERS_DIST_NAME); \
		cp $(@D)/*.c $(PLATFORM_DRIVERS_DIST_NAME); \
		cp $(@D)/*.h $(PLATFORM_DRIVERS_DIST_NAME); \
		cp $(@D)/Makefile $(PLATFORM_DRIVERS_DIST_NAME); \
		mkdir -p $(BASE_DIR)/dist; \
		tar -zcvf $(BASE_DIR)/dist/$(PLATFORM_DRIVERS_DIST_NAME).tar.gz \
			$(PLATFORM_DRIVERS_DIST_NAME); \
	)
endef

endif # BR2_PRESTERA_SDK

$(eval $(generic-package))
