#!/bin/bash

set -o pipefail

echo -n $(date +%d_%m_%Y) > ${TARGET_DIR}/etc/ver
echo -n "-buildroot-" >> ${TARGET_DIR}/etc/ver
echo -n $(git rev-parse --short HEAD) >> ${TARGET_DIR}/etc/ver
echo -n "-cpss-" >> ${TARGET_DIR}/etc/ver
if [[ -z "${CPSS_OVERRIDE_SRCDIR}" ]]; then
	if [[ -z "${BR2_PACKAGE_CPSS_CUSTOM_VERSION}" ]]; then
		echo default >> ${TARGET_DIR}/etc/ver
	else
		echo $BR2_PACKAGE_CPSS_CUSTOM_VERSION >> ${TARGET_DIR}/etc/ver
	fi

else
	pushd .
	cd $CPSS_OVERRIDE_SRCDIR
	echo $(git rev-parse --short HEAD) >> ${TARGET_DIR}/etc/ver
	popd
fi
