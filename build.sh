#!/bin/bash

set -e

TOPDIR=$(dirname "$(readlink -f $0)")
OUTPUT_DIR="${TOPDIR}/output/"
CONFIG_PATH=""

if [ "$#" -lt 1 ]; then
    echo "Please specify board name (configs/{board}_defconfig) w/o _defconfig suffix," >&2
    echo "or path to config file via -c option" >&2
    exit 1
fi

if [ -f "${TOPDIR}/.config" ]; then
 . "${TOPDIR}/.config"
fi

if [ -z "${BR2_PATH}" ]; then
    BR2_PATH=${TOPDIR}/dl/buildroot
fi
if [ -z "$BR2_DL_DIR" ]; then
    export BR2_DL_DIR="~/br2-dl"
fi

${TOPDIR}/scripts/br2_check.sh

#1 - path to defconfig
#2 - option name
cfg_get_opt() {
    grep -s $2 $1 | awk -F'=' '{ print $2 }' | sed 's/\"//g'
}

#1 - path to defconfig
build_config() {
    local config=$1
    local output=$(basename ${1})
    local external_list="${TOPDIR}"
    local custom_subdir=""
    output=${OUTPUT_DIR}/${output%_defconfig}

    custom_subdir=$(cfg_get_opt $config "BR2_PRESTERA_CUSTOM_SUBDIR")

    if [ -n "${custom_subdir}" ]; then
        external_list="${TOPDIR}/${custom_subdir}:${external_list}"
    fi

    make BR2_DEFCONFIG="${config}" BR2_EXTERNAL="${external_list}" \
         O="${output}" \
	-C "${BR2_PATH}" defconfig

    make -C ${output}
}

if [ "${1}" == "all" ]; then
	for p in $(find ${TOPDIR}/configs/ -maxdepth 1 -type f); do
            build_config "${p}"
	done
	exit 0
fi

if [ "$#" -eq 1 -a -z "${CONFIG_PATH}" ]; then
    CONFIG_PATH="${TOPDIR}/configs/${1}_defconfig"
    shift
fi

while (( $# )); do
    case $1 in
        -c) CONFIG_PATH=$(readlink -f $2)
            shift
            ;;

        --out-dir) OUTPUT_DIR=$(readlink -f $2)
            shift
            ;;
    esac
    shift
done

build_config "${CONFIG_PATH}"
