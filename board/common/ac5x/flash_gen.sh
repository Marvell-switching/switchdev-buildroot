#!/bin/sh

set -e

BOARD="${2}-"
FLASH_IMAGE_VERSION="${3}"
BOARD_DIR="$(dirname $0)"
BOARD_FLASH_CFG_FILE="${BOARD_DIR}/flash-cfg.ini"

cd ${BINARIES_DIR}/

cp Image linux-image.bin
cp *.dtb linux-dtb.bin

${HOST_DIR}/usr/bin/fw_flash_gen -i ${BOARD_FLASH_CFG_FILE} \
	-o ${BINARIES_DIR}/${BOARD}prestera-fw-flash-image-v${FLASH_IMAGE_VERSION}.img \
	-v ${FLASH_IMAGE_VERSION}
