#!/bin/sh

set -e

BOARD="${2}-"
FLASH_IMAGE_VERSION="${3}"
BOARD_DIR="$(dirname $0)"
BOARD_FLASH_CFG_FILE="${BOARD_DIR}/flash-cfg.ini"
LINUX_ZIMAGE_FILE="${BINARIES_DIR}/linux-zimage.bin"

IMAGE_NAME=${BOARD}swdev-fw-ldr-nand.img

cp ${BINARIES_DIR}/uboot-nand.bin ${BINARIES_DIR}/nand0-uboot.img

# In case if repeated build, link would exist already
if ! [ -f ${LINUX_ZIMAGE_FILE} ] ; then
    ln -s ${BINARIES_DIR}/zImage* ${LINUX_ZIMAGE_FILE}
fi

truncate -s $((0xa00000)) ${BINARIES_DIR}/nand0-uboot.img
cat ${BINARIES_DIR}/nand0-uboot.img ${LINUX_ZIMAGE_FILE} > ${BINARIES_DIR}/${IMAGE_NAME}
rm -f ${BINARIES_DIR}/nand0-uboot.img

cd ${BINARIES_DIR}/
${HOST_DIR}/usr/bin/fw_flash_gen -i ${BOARD_FLASH_CFG_FILE} \
-o ${BINARIES_DIR}/${BOARD}prestera-fw-flash-image-v${FLASH_IMAGE_VERSION}.img \
-v ${FLASH_IMAGE_VERSION}
cd -
