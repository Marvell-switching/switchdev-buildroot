################################################################################
#
# prestera-ssh
#
################################################################################

PRESTERA_SSH_SITE =
PRESTERA_SSH_SITE_METHOD =

ifeq ($(BR2_PACKAGE_OPENSSH),y)
PRESTERA_SSH_DEPENDENCIES += openssh
define PRESTERA_SSH_SSHD_ACCESS
	$(INSTALL) -D $(PRESTERA_SSH_PKGDIR)/sshd_config \
		$(TARGET_DIR)/etc/ssh/sshd_config
endef
endif

define PRESTERA_SSH_INSTALL_TARGET_CMDS
	$(PRESTERA_SSH_SSHD_ACCESS)
endef

$(eval $(generic-package))
