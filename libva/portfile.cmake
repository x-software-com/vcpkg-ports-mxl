vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO intel/libva
    REF ${VERSION}
    SHA512 93654bb892e0e269d7682a1344fe6f7298432d1f2b347396c63aa1bd84ac0f707af34950a93098fe86a9bc8986fc9f97f75f0f15d8495ffd2caf8cf0eed9612c
    HEAD_REF master
)

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS
)
vcpkg_install_make()

vcpkg_fixup_pkgconfig()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
