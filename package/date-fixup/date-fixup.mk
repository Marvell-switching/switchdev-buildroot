################################################################################
#
# date-fixup
#
################################################################################

DATE_FIXUP_SITE =
DATE_FIXUP_SITE_METHOD =

DATE_FIXUP_INSTALL_IMAGES = YES
DATE_FIXUP_SCRIPT = S10dateFixup

define DATE_FIXUP_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0755 $(DATE_FIXUP_PKGDIR)/$(DATE_FIXUP_SCRIPT) \
	$(TARGET_DIR)/etc/init.d/$(DATE_FIXUP_SCRIPT)
endef

$(eval $(generic-package))
