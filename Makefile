BR2_PATH ?= $(CURDIR)/dl/buildroot
SED = sed -i

-include $(CURDIR)/.local.mk

$(if $(BR2_PATH),, $(error Please specify the main Buildroot path via BR2_PATH var))

ifndef BR2_DL_DIR
export BR2_DL_DIR="~/br2-dl"
endif

special_target := %_defconfig dist-vendor dist-public

.PHONY: br2_check $(special_target) $(all)

all := $(filter-out $(special_target),$(MAKECMDGOALS))

define CONFIG_ENABLE_OPT # (option)
	$(SED) "/\\<$(1)\\>/d" $(TMP_CFG)
	echo '$(1)=y' >> $(TMP_CFG)
endef

ifeq ($(CCACHE),y)
define add_ccache_opt
	$(call CONFIG_ENABLE_OPT,BR2_CCACHE)
	$(call CONFIG_ENABLE_OPT,BR2_CCACHE_USE_BASEDIR)
endef
endif

define gen_custom_cfg
	$(add_ccache_opt)
endef

%_defconfig: TMP_CFG := $(shell mktemp -t br2-cfg-XXXXXX)
%_defconfig: br2_check
	$(MAKE) -C $(BR2_PATH) BR2_EXTERNAL=$(CURDIR) \
		BR2_DEFCONFIG=$(CURDIR)/configs/$@ \
		O=$(CURDIR)/output/$* defconfig
	$(gen_custom_cfg)
	$(BR2_PATH)/support/kconfig/merge_config.sh -m -O $(CURDIR)/output/$* \
		$(CURDIR)/output/$*/.config $(TMP_CFG)
	$(MAKE) -C $(CURDIR)/output/$* olddefconfig
	rm $(TMP_CFG)

_all: br2_check
	$(MAKE) $(MAKEARGS) -C $(O) $(all)

br2_check:
	$(CURDIR)/scripts/br2_check.sh

$(all): _all
	@:
