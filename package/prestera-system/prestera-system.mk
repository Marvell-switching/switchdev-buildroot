################################################################################
#
# prestera-init
#
################################################################################

PRESTERA_SYSTEM_SITE =
PRESTERA_SYSTEM_SITE_METHOD =

ifeq ($(BR2_PACKAGE_LLDPD),y)
define PRESTERA_SYSTEM_LLDPD_CONF_INSTALL
	$(INSTALL) -D $(PRESTERA_SYSTEM_PKGDIR)/lldpd.conf \
		$(TARGET_DIR)/etc/lldpd.conf
endef
endif

ifeq ($(BR2_PACKAGE_MSTPD),y)
define PRESTERA_SYSTEM_MSTPD_CONF_INSTALL
	$(INSTALL) -D $(PRESTERA_SYSTEM_PKGDIR)/bridge-stp.conf \
		$(TARGET_DIR)/etc/bridge-stp.conf
endef
endif

define PRESTERA_SYSTEM_INSTALL_TARGET_CMDS
	$(PRESTERA_SYSTEM_LLDPD_CONF_INSTALL)
	$(PRESTERA_SYSTEM_MSTPD_CONF_INSTALL)
	$(INSTALL) -m 0600 -D $(PRESTERA_SYSTEM_PKGDIR)/10-marvell-switchdev.rules \
		$(TARGET_DIR)/etc/udev/rules.d/10-marvell-switchdev.rules

	$(INSTALL) -D -m 0755 $(PRESTERA_SYSTEM_PKGDIR)/sysctl.conf \
		$(TARGET_DIR)/etc/sysctl.conf
endef

$(eval $(generic-package))
