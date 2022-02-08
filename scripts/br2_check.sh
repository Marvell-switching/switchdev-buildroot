#!/bin/bash

set -e

if [ -z "${TOPDIR}" ]; then
    TOPDIR=$(dirname "$(readlink -f $0)")/../
fi

source ${TOPDIR}/br2_version

BR2_CUR_DIR="buildroot-${BR2_VERSION}-${BR2_LOCAL_VERSION}"
BR2_ARCHIVE="buildroot-${BR2_VERSION}.tar.gz"

ln -nsf ${BR2_CUR_DIR} ${TOPDIR}/dl/buildroot

if [ -z "$BR2_PATH" ]; then
	if [ ! -d "${TOPDIR}/dl/${BR2_CUR_DIR}" ]; then
		rm -rf "${BR2_PATH}"
		mkdir "${TOPDIR}/dl/${BR2_CUR_DIR}"

		echo -e "Extracting ${BR2_ARCHIVE} ..."
		tar -xf "${TOPDIR}/dl/${BR2_ARCHIVE}" \
			-C "${TOPDIR}/dl/${BR2_CUR_DIR}" \
			--strip-components=1

		BR2_PATH="$(readlink -f ${TOPDIR}/dl/buildroot)"

		if [ -d ${TOPDIR}/patches/buildroot/${BR2_VERSION} ]; then
			for p in ${TOPDIR}/patches/buildroot/${BR2_VERSION}/*.patch; do
				[[ -f $p ]] && patch -p1 -d dl/buildroot -i $p
			done
		else
			for p in ${TOPDIR}/patches/buildroot/*.patch; do
				[[ -f $p ]] && patch -p1 -d dl/buildroot -i $p
			done
		fi
	fi
fi
