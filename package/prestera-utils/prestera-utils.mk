################################################################################
#
# prestera-utils
#
################################################################################

PRESTERA_UTILS_SITE =
PRESTERA_UTILS_SITE_METHOD =

define PRESTERA_UTILS_INSTALL_TARGET_CMDS
	cp -v $(PRESTERA_UTILS_PKGDIR)/scripts/* $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
