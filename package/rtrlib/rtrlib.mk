################################################################################
#
# rtrlib
#
################################################################################

RTRLIB_VERSION = 0.7.0
RTRLIB_SITE = $(call github,rtrlib,rtrlib,v$(RTRLIB_VERSION))
RTRLIB_LICENSE = MIT
RTRLIB_LICENSE_FILES = LICENSE
RTRLIB_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBSSH),y)
RTRLIB_CONF_OPTS += -DRTRLIB_TRANSPORT_SSH=Yes
RTRLIB_DEPENDENCIES += libssh
else
RTRLIB_CONF_OPTS += -DRTRLIB_TRANSPORT_SSH=No
endif

$(eval $(cmake-package))
