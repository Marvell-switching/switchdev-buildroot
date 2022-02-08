################################################################################
#
# prestera-frr
#
################################################################################

PRESTERA_FRR_VERSION = 7.3
PRESTERA_FRR_SOURCE = frr-$(PRESTERA_FRR_VERSION).tar.gz
PRESTERA_FRR_SITE = https://github.com/FRRouting/frr/archive
PRESTERA_FRR_LICENSE = GPL-2.0
PRESTERA_FRR_LICENSE_FILES = COPYING
PRESTERA_FRR_AUTORECONF = YES

PRESTERA_FRR_DEPENDENCIES = host-prestera-frr readline json-c \
	libyang libnl c-ares

HOST_PRESTERA_FRR_DEPENDENCIES = host-flex host-bison host-python

PRESTERA_FRR_CONF_OPTS = --with-clippy=$(HOST_DIR)/bin/clippy \
	--sysconfdir=/etc/frr \
	--localstatedir=/var/run/frr \
	--with-moduledir=/usr/lib/frr/modules \
	--enable-configfile-mask=0640 \
	--enable-logfile-mask=0640 \
	--enable-multipath=256 \
	--disable-ospfclient \
	--enable-shell-access \
	--enable-user=frr \
	--enable-group=frr \
	--enable-vty-group=frrvty \
	--disable-capabilities \
	--enable-fpm

HOST_PRESTERA_FRR_CONF_OPTS = --enable-clippy-only

define HOST_PRESTERA_FRR_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/lib/clippy $(HOST_DIR)/bin/clippy
endef

define PRESTERA_FRR_INSTALL_CONFIG_FILES
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/frr

	$(foreach f,daemons daemons.conf frr.conf vtysh.conf support_bundle_commands.conf,\
		$(INSTALL) -D -m 0640 $(@D)/tools/etc/frr/$(f) \
		$(TARGET_DIR)/etc/frr/$(f)
	)

	$(RM) $(TARGET_DIR)/etc/frr/*.sample
endef
PRESTERA_FRR_POST_INSTALL_TARGET_HOOKS += PRESTERA_FRR_INSTALL_CONFIG_FILES

define PRESTERA_FRR_PERMISSIONS
	/etc/frr/daemons f 640 frr frr - - - - -
	/etc/frr/daemons.conf f 640 frr frr - - - - -
	/etc/frr/frr.conf f 640 frr frr - - - - -
	/etc/frr/vtysh.conf f 640 frr frrvty - - - - -
	/etc/frr/support_bundle_commands.conf f 640 frr frr
endef

define PRESTERA_FRR_USERS
	frr -1 frr -1 * /var/run/frr - frrvty FRR user priv
endef

define PRESTERA_FRR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(PRESTERA_FRR_PKGDIR)/S50frr \
		$(TARGET_DIR)/etc/init.d/S50frr
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
