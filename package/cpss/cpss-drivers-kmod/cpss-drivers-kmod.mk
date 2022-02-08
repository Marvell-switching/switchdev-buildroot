################################################################################
#
# cpss-drivers-kmod
#
################################################################################

CPSS_DRIVERS_KMOD_VERSION ?= 08640e64c8eaa9985823084989d4dcfec8ee99a2
CPSS_DRIVERS_KMOD_SITE ?= $(CPSS_SITE)/mrvl-prestera
CPSS_DRIVERS_KMOD_SITE_METHOD ?= $(CPSS_SITE_METHOD)

CPSS_DRIVERS_KMOD_MODULE_MAKE_OPTS = environment_mode=customer \
				     CPSS_PATH=$(@D) \
				     CPU_FAMILY=CPU_ARM \
				     LSP_KERNEL_TYPE=$(if $(BR2_aarch64),Image,zImage)

CPSS_DRIVERS_KMOD_MODULE_SUBDIRS = cpssEnabler/linuxNoKernelModule/drivers

# apply it manualy in case we fetch sources localy
ifeq ($(CPSS_DRIVERS_KMOD_SITE_METHOD),local)
define CPSS_DRIVERS_KMOD_CONFIGURE_CMDS
	$(APPLY_PATCHES) $(@D) $(CPSS_DRIVERS_KMOD_PKGDIR) \*.patch \*.patch.$(ARCH) || exit 1;
endef
endif

define CPSS_DRIVERS_KMOD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(CPSS_DRIVERS_KMOD_PKGDIR)/S69cpss-drivers \
		$(TARGET_DIR)/etc/init.d/S69cpss-drivers
endef

$(eval $(kernel-module))

$(eval $(generic-package))
