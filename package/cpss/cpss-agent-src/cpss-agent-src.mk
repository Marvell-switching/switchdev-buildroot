################################################################################
#
# cpss-agent-src
#
################################################################################

CPSS_AGENT_SRC_VERSION ?= $(CPSS_VERSION)
CPSS_AGENT_SRC_SITE ?= $(CPSS_SITE)
CPSS_AGENT_SRC_SITE_METHOD ?= $(CPSS_SITE_METHOD)
CPSS_AGENT_SRC_DEPENDENCIES = libarchive

ifeq ($(BR2_PACKAGE_CPSS_AGENT_SRC_DEBUG_INFO),y)
	CPSS_AGENT_SRC_DEBUG_INFO=Y
else
	CPSS_AGENT_SRC_DEBUG_INFO=N
endif

ifeq ($(CPSS_AGENT_SRC_SITE),)
CPSS_AGENT_SRC_SITE := unknown
endif

ifeq ($(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_PCI),)
CPSS_AGENT_SRC_DEPENDENCIES += libnl
endif

ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_10),y)
	CPSS_TARGET_CFLAGS="-Wno-error=enum-conversion -Wno-error=cast-function-type"
endif

ifeq ($(BR2_aarch64),y)
    CPSS_TARGET = armv8
else
ifeq ($(BR2_arm),y)
        CPSS_TARGET = armv7
else
    CPSS_TARGET = sim32
endif
endif

ifeq ($(BR2_PACKAGE_CPSS_AGENT_SRC_STATIC),y)
	CPSS_AGENT_SRC_STATIC_BUILD_CMD = \
		$(CPSS_AGENT_SRC_TARGET_ENV) $(TARGET_MAKE_ENV) make -C cpss \
			BUILD_FOLDER=$(CPSS_BIN_DIR) \
			TARGET=$(CPSS_TARGET) FAMILY=DX DEBUG_INFO=$(CPSS_AGENT_SRC_DEBUG_INFO) appDemo_static -s -j12
	CPSS_AGENT_SRC_STATIC_INSTALL_CMD = \
	$(INSTALL) -m 0755 -D $(CPSS_BIN_DIR)/appDemo_static \
		$(TARGET_DIR)/usr/bin/fw_application_static
else
	CPSS_AGENT_SRC_STATIC_BUILD_CMD = true
	CPSS_AGENT_SRC_STATIC_INSTALL_CMD = true
endif

CPSS_BIN_DIR = $(@D)/compilation_root

CPSS_AGENT_SRC_TARGET_ENV = CC="$(TARGET_CC)" \
		LD="$(TARGET_LD)" \
		AR="$(TARGET_AR)" \
		CPSS_PATH="$(@D)/cpss" \
		XCOMP_ROOT_PATH="$(STAGING_DIR)" \
		LINUX_BUILD_KERNEL="NO" \
		DEFAULT_LINUX_CONFIG="none" \
		CROSS_COMPILE=$(TARGET_CROSS) \
		TARGET_SPECIFIC_CFLAGS=$(CPSS_TARGET_CFLAGS) \
		YOCTO_ENV="1" \
		$(if $(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_PCI),CPSS_SWDEV_AGENT_USE_PCI=1) \
		$(if $(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_IPC_ADDR),CPSS_SWDEV_AGENT_IPC_MEM_START=$(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_IPC_ADDR)) \
		$(if $(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_IPC_SIZE),CPSS_SWDEV_AGENT_IPC_MEM_SIZE=$(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_IPC_SIZE)) \
		$(if $(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_FW_VER),CPSS_SWDEV_FW_VER=$(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_FW_VER)) \
		$(if $(BR2_PACKAGE_CPSS_AGENT_SRC_SWDEV_TESTS),CPSS_SWDEV_AGENT_TESTS=1)

define CPSS_AGENT_SRC_BUILD_CMDS
	( echo $(HOST_DIR) $(TARGET_AR); \
		find $(HOST_DIR) -name libc.a; \
		find $(HOST_DIR) -name libc.a -exec $(TARGET_AR) d {} libc-lowlevellock.o \; ; \
		cd $(@D); \
		$(CPSS_AGENT_SRC_TARGET_ENV) $(TARGET_MAKE_ENV) CFLAGS=$(CPSS_TARGET_CFLAGS) make libs; \
		$(CPSS_AGENT_SRC_TARGET_ENV) $(TARGET_MAKE_ENV) make -C cpss \
			BUILD_FOLDER=$(CPSS_BIN_DIR) \
			TARGET=$(CPSS_TARGET) FAMILY=DX DEBUG_INFO=$(CPSS_AGENT_SRC_DEBUG_INFO) appDemo -s -j12 && \
		$(CPSS_AGENT_SRC_STATIC_BUILD_CMD) && \
		echo DEBUG_INFO=$(CPSS_AGENT_SRC_DEBUG_INFO) from $(BR2_PACKAGE_CPSS_AGENT_SRC_DEBUG_INFO); \
		)
endef

define CPSS_AGENT_SRC_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(CPSS_BIN_DIR)/appDemo \
		$(TARGET_DIR)/usr/bin/sw-agentd
	$(CPSS_AGENT_SRC_STATIC_INSTALL_CMD)
	mkdir -p $(TARGET_DIR)/etc/mvsw;
endef

define CPSS_AGENT_SRC_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(CPSS_AGENT_SRC_PKGDIR)/S90agent \
		$(TARGET_DIR)/etc/init.d/S90agent
endef

$(eval $(generic-package))
