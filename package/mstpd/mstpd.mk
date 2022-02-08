################################################################################
#
# mstpd
#
################################################################################

MSTPD_VERSION = 0.0.8
MSTPD_SOURCE = $(MSTPD_VERSION).tar.gz
MSTPD_SITE = https://github.com/mstpd/mstpd/archive
MSTPD_LICENSE = GPL-2.0
MSTPD_LICENSE_FILES = COPYING
MSTPD_AUTORECONF = YES

# mstpd requires that it is installed into /sbin, not /usr/sbin
MSTPD_CONF_OPTS = \
	--sbindir=/sbin \
	--prefix=/ \
	--exec-prefix=/

$(eval $(autotools-package))
