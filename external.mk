PRESTERA_REPO_SITE ?= https://github.com/Marvell-switching

include $(sort $(wildcard $(BR2_EXTERNAL_PRESTERA_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_PRESTERA_PATH)/toolchain/*/*.mk))

TFTP_BOOT_IP ?= 192.168.1.1

define PRESTERA_SHELL_SETUP
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_PRESTERA_PATH)/system/profile.sh \
		$(TARGET_DIR)/etc/profile.d/profile.sh
endef

world: prestera-pre-target
prestera-pre-target:
	$(PRESTERA_SHELL_SETUP)

%-deploy: DEST_DIR = ~/$(subst _defconfig",,$(notdir $(BR2_DEFCONFIG)))
%-deploy: TMP_DEPLOY := $(shell mktemp -d -t deploy-XXXXXX)
%-deploy: %-rebuild
	@echo $(TMP_DEPLOY)
	@echo "Deploying $* to $(TFTP_BOOT_IP):$(DEST_DIR)/rootfs ..."
	@for f in `cat $(BUILD_DIR)/$*/.files-list.txt | awk -F ',.' '{print $$2 }'`; do \
	    mkdir -p $(TMP_DEPLOY)/`dirname $$f`; \
	    cp $(TARGET_DIR)/$$f $(TMP_DEPLOY)/`dirname $$f`; \
	done;
	rsync -avz $(TMP_DEPLOY)/ $(TFTP_BOOT_IP):$(DEST_DIR)/rootfs
	rm -rf $(TMP_DEPLOY)

deploy:	DEST_DIR = ~/$(subst _defconfig",,$(notdir $(BR2_DEFCONFIG)))
deploy:	world
	@echo "Deploying to $(TFTP_BOOT_IP):$(DEST_DIR) ..."
	@rm -rf $(BINARIES_DIR)/deploy
	@mkdir -p $(BINARIES_DIR)/deploy/rootfs
	tar -xf $(BINARIES_DIR)/rootfs.tar -C $(BINARIES_DIR)/deploy/rootfs
	cp $(BR2_EXTERNAL_PRESTERA_PATH)/support/install.sh $(BINARIES_DIR)/deploy
	ln -sf /sbin/init $(BINARIES_DIR)/deploy/rootfs/init
	cp $(BINARIES_DIR)/rootfs.tar $(BINARIES_DIR)/deploy
	-cp $(BINARIES_DIR)/*.img $(BINARIES_DIR)/deploy
	@for f in `ls $(BINARIES_DIR)/*Image*`; do \
	    if [ ! -f $(BINARIES_DIR)/linux ]; then \
	        ln -sf `basename $$f` $(BINARIES_DIR)/deploy/linux ; \
	    fi; \
	    cp $$f $(BINARIES_DIR)/deploy/ ; \
	done;
	@for f in `ls $(BINARIES_DIR)/*.dtb`; do \
	    if [ ! -f $(BINARIES_DIR)/dtb ]; then \
	        ln -sf `basename $$f` $(BINARIES_DIR)/deploy/dtb ; \
	    fi; \
	    cp $$f $(BINARIES_DIR)/deploy/ ; \
	done;
	rsync -avz --delete $(BINARIES_DIR)/deploy/ $(TFTP_BOOT_IP):$(DEST_DIR)
