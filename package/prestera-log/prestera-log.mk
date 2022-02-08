################################################################################
#
# prestera-fw-loader-log
#
################################################################################

define PRESTERA_LOG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(PRESTERA_LOG_PKGDIR)/logrotate \
		$(TARGET_DIR)/etc/cron.daily/logrotate;
	$(INSTALL) -D -m 0755 $(PRESTERA_LOG_PKGDIR)/app_logrotate.conf \
		$(TARGET_DIR)/etc/logrotate.d/app_logrotate.conf;
endef

$(eval $(generic-package))
