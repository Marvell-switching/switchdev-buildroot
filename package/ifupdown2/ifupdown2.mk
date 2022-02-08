################################################################################
#
# ifupdown
#
################################################################################

IFUPDOWN2_VERSION = 3.0.0-1
IFUPDOWN2_SITE = https://github.com/CumulusNetworks/ifupdown2
IFUPDOWN2_SITE_METHOD = git
IFUPDOWN2_LICENSE = GPL-2.0+
IFUPDOWN2_LICENSE_FILES = COPYING
IFUPDOWN2_CPE_ID_VENDOR = debian

define IFUPDOWN2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99 -D'IFUPDOWN2_VERSION=\"$(IFUPDOWN_VERSION)\"'" \
		-C $(@D)
endef

# install doesn't overwrite
define IFUPDOWN2_INSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/sbin/{ifdown,ifquery}
	$(TARGET_MAKE_ENV) $(MAKE) BASEDIR=$(TARGET_DIR) -C $(@D) install
endef

# We need to switch from /bin/ip to /sbin/ip
IFUPDOWN2_DEFN_FILES = can inet inet6 ipx link meta
define IFUPDOWN2_MAKE_IP_IN_SBIN
	for f in $(IFUPDOWN2_DEFN_FILES) ; do \
		$(SED) 's,/bin/ip,/sbin/ip,' $(@D)/$$f.defn ; \
	done
endef
IFUPDOWN2_POST_PATCH_HOOKS += IFUPDOWN2_MAKE_IP_IN_SBIN

$(eval $(generic-package))
