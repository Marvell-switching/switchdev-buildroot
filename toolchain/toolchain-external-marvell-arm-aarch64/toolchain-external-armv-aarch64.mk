################################################################################
#
# toolchain-external-marvell-arm-aarch64
#
################################################################################

TOOLCHAIN_EXTERNAL_MARVELL_ARM_AARCH64_VERSION = f979ee739dea
TOOLCHAIN_EXTERNAL_MARVELL_ARM_AARCH64_SITE_METHOD = git
TOOLCHAIN_EXTERNAL_MARVELL_ARM_AARCH64_SITE = $(PRESTERA_REPO_SITE)/toolchain-marvell-arm-aarch64

$(eval $(toolchain-external-package))
