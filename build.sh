#!/usr/bin/env bash

# Quirks:
# This repo should be named or symlinked as `sm8750`
# LineageOS/android_kernel_oneplus_sm8750-modules should be placed alongside this repo and it should be named as or symlinked to `sm8750-modules`

set -e -u -o pipefail

OUTPUT_DIR=out
MAKE_VARIABLES=(
    ARCH=arm64
    SUBARCH=arm64
    LLVM=1
    O="$OUTPUT_DIR"
)

DEFCONFIG_FRAGMENTS=(
    arch/arm64/configs/gki_defconfig
    arch/arm64/configs/vendor/sun_perf.config
    arch/arm64/configs/vendor/oplus/sun_perf.config
)

config() {
    mkdir -p "$OUTPUT_DIR"
    ARCH=arm64 LLVM=1 \
        scripts/kconfig/merge_config.sh -O "$OUTPUT_DIR" "${DEFCONFIG_FRAGMENTS[@]}"
}

xconfig() {
    make "${MAKE_VARIABLES[@]}" xconfig
}

menuconfig() {
    make "${MAKE_VARIABLES[@]}" menuconfig
}

build() {
    make "${MAKE_VARIABLES[@]}" -j "$(nproc)"
}

clean() {
    make "${MAKE_VARIABLES[@]}" clean
}

distclean() {
    make "${MAKE_VARIABLES[@]}" distclean
}

case "${1:-}" in
*)
    "$1"
    ;;
esac
