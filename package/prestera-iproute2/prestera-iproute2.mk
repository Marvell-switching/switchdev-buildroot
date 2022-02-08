################################################################################
#
# prestera-iproute2
#
################################################################################

PRESTERA_IPROUTE2_VERSION = ade99e208c1843ed3b6eb9d138aa15a6a5eb5219
PRESTERA_IPROUTE2_SITE = $(call github,shemminger,iproute2,$(PRESTERA_IPROUTE2_VERSION))
PRESTERA_IPROUTE2_DEPENDENCIES = host-bison host-flex host-pkgconf \
	$(if $(BR2_PACKAGE_LIBMNL),libmnl)
PRESTERA_IPROUTE2_LICENSE = GPL-2.0+
PRESTERA_IPROUTE2_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
PRESTERA_IPROUTE2_DEPENDENCIES += elfutils
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PRESTERA_IPROUTE2_DEPENDENCIES += libcap
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
PRESTERA_IPROUTE2_DEPENDENCIES += libselinux
endif

ifeq ($(BR2_PACKAGE_IPTABLES)x$(BR2_STATIC_LIBS),yx)
PRESTERA_IPROUTE2_DEPENDENCIES += iptables
else
define PRESTERA_IPROUTE2_DISABLE_IPTABLES
	# m_xt.so is built unconditionally
	echo "TC_CONFIG_XT:=n" >>$(@D)/config.mk
endef
endif

ifeq ($(BR2_PACKAGE_BERKELEYDB_COMPAT185),y)
PRESTERA_IPROUTE2_DEPENDENCIES += berkeleydb
endif

define PRESTERA_IPROUTE2_CONFIGURE_CMDS
	cd $(@D) && $(TARGET_CONFIGURE_OPTS) ./configure
	$(PRESTERA_IPROUTE2_DISABLE_IPTABLES)
endef

define PRESTERA_IPROUTE2_BUILD_CMDS
	$(TARGET_MAKE_ENV) LDFLAGS="$(TARGET_LDFLAGS)" \
		CFLAGS="$(TARGET_CFLAGS) -DXT_LIB_DIR=\\\"/usr/lib/xtables\\\"" \
		CBUILD_CFLAGS="$(HOST_CFLAGS)" $(MAKE) V=1 LIBDB_LIBS=-lpthread \
		DBM_INCLUDE="$(STAGING_DIR)/usr/include" \
		SHARED_LIBS="$(if $(BR2_STATIC_LIBS),n,y)" -C $(@D)
endef

define PRESTERA_IPROUTE2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR="$(TARGET_DIR)" $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
