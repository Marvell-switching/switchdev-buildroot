#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage-trampoline.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Pass an empty rootpath. genimage makes a full copy of the given rootpath to
# ${GENIMAGE_TMP}/root so passing TARGET_DIR would be a waste of time and disk
# space. We don't rely on genimage to build the rootfs image, just to insert a
# pre-built one in the disk image.

trap 'rm -rf "${ROOTPATH_TMP}"' EXIT
ROOTPATH_TMP="$(mktemp -d)"

rm -rf "${GENIMAGE_TMP}"

genimage \
	--rootpath "${ROOTPATH_TMP}"   \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

PART_TMP="$(mktemp -d)"
mkdir $PART_TMP/etc
cp -r ${TARGET_DIR}/etc/mvsw $PART_TMP/etc
md5sum $PART_TMP/etc/mvsw/mvsw_platform.xml | awk '{print $1}' > $PART_TMP/etc/mvsw/mvsw_platform.md5
${BOARD_DIR}/make-part.sh ${BINARIES_DIR}/part.bin ${PART_TMP} ${BINARIES_DIR}/emmc.bin
rm -rf "${PART_TMP}"

exit $?
