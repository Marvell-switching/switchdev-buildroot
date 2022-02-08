#!/bin/bash

set -u

THIS_SCRIPT_DIR=$(dirname "$(readlink -f $0)")

DEST="${1}"

if [ "$#" -ne 1 ]; then
    echo "Please specify dest path to deploy (i.e. /tftpboot/boardname/host" >&2
    exit 1
fi
if [ ! -d ${DEST} ]; then
    echo "Destination path ${DEST} does not exist"
    exit 1
fi

if [ -f ${THIS_SCRIPT_DIR}/*.dtb ]; then
    ln -sf ${THIS_SCRIPT_DIR}/*.dtb ${DEST}/dtb
fi
if [ -f ${THIS_SCRIPT_DIR}/*Image* ]; then
    ln -sf ${THIS_SCRIPT_DIR}/*Image* ${DEST}/linux
fi
if [ -d ${THIS_SCRIPT_DIR}/rootfs ]; then
    rm -rf ${DEST}/rootfs
    cp -r ${THIS_SCRIPT_DIR}/rootfs ${DEST}
fi
