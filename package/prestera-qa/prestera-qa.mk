################################################################################
#
# prestera-qa
#
################################################################################

PRESTERA_QA_SITE =
PRESTERA_QA_SITE_METHOD =
PRESTERA_QA_DEPENDENCIES = linux

ifneq ($(BR2_PACKAGE_FRR)$(BR2_PACKAGE_PRESTERA_FRR),)

PRESTERA_QA_FRR_REINSTALL_FILES = frr frrcommon frrinit.sh frr-reload frr-reload.py watchfrr staticd bgpd zebra ospfd ospf6d isisd

PRESTERA_QA_DEPENDENCIES += $(if $(BR2_PACKAGE_FRR),frr)
PRESTERA_QA_DEPENDENCIES += $(if $(BR2_PACKAGE_PRESTERA_FRR),prestera-frr)

define PRESTERA_QA_FRR_FIXUP
	rm -f $(TARGET_DIR)/etc/init.d/S50frr

	$(foreach f,$(PRESTERA_QA_FRR_REINSTALL_FILES), \
		ln -sf /usr/sbin/$(f) $(TARGET_DIR)/usr/lib/frr/$(f)$(sep))
endef
endif # frr

ifeq ($(BR2_PACKAGE_LINUX_TOOLS_SELFTESTS),y)

PRESTERA_QA_DEPENDENCIES += linux-tools

endif # BR2_PACKAGE_LINUX_TOOLS_SELFTESTS

ifeq ($(BR2_PACKAGE_LLDPD),y)

PRESTERA_QA_DEPENDENCIES += lldpd

define PRESTERA_QA_LLDPD_FIXUP
	rm -f $(TARGET_DIR)/etc/init.d/S60lldpd
endef
endif #BR2_PACKAGE_LLDPD

define PRESTERA_QA_FIXUPS
	$(PRESTERA_QA_FRR_FIXUP)
	$(PRESTERA_QA_LLDPD_FIXUP)
endef
PRESTERA_QA_TARGET_FINALIZE_HOOKS += PRESTERA_QA_FIXUPS

# put it here because Buildroot removes
# /usr/include during target finalize but before rootfs
# finalization
define PRESTERA_QA_HEADERS_FIXUP
	$(INSTALL) -D $(STAGING_DIR)/usr/include/linux/ethtool.h $(TARGET_DIR)/usr/include/linux/ethtool.h
endef
PRESTERA_QA_ROOTFS_PRE_CMD_HOOKS += PRESTERA_QA_HEADERS_FIXUP

$(eval $(generic-package))
