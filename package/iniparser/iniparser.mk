################################################################################
#
# iniparser
#
################################################################################

INIPARSER_VERSION = f858275f7f307eecba84c2f5429483f9f28007f8
INIPARSER_SITE = $(call github,ndevilla,iniparser,$(INIPARSER_VERSION))
INIPARSER_LICENSE = MIT

define HOST_INIPARSER_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_INIPARSER_INSTALL_CMDS
	$(INSTALL) -m 0640 -D $(@D)/src/iniparser.h $(HOST_DIR)/include/iniparser.h
	$(INSTALL) -m 0640 -D $(@D)/src/dictionary.h $(HOST_DIR)/include/dictionary.h
	$(INSTALL) -m 0755 -D $(@D)/libiniparser.a $(HOST_DIR)/lib/libiniparser.a
	$(INSTALL) -m 0755 -D $(@D)/libiniparser.so.1 $(HOST_DIR)/lib/libiniparser.so.1
	ln -s libiniparser.so.1 $(HOST_DIR)/lib/libiniparser.so
endef

$(eval $(host-generic-package))
