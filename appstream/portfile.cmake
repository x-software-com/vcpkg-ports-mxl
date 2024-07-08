vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ximion/appstream
    REF "v${VERSION}"
    SHA512 8438c1c4368d1322a69f88238ded31126cdfa2750cd611d8040245e90b7802c92bb6978ea8aba680fe70c744e4a1bfe3ef9cc10628682e5d2165994183bbd815
    HEAD_REF main
    PATCHES
        fix-docs.patch
        # fix-sysinfo.patch
)

set(GLIB_TOOLS_DIR "${CURRENT_HOST_INSTALLED_DIR}/tools/glib")

vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/tools/gperf")

set(ENV{CFLAGS} "-D_BSD_SOURCE")

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -Dsystemd=false
        -Dstemming=false
        -Ddocs=false
        -Dgir=false
        -Ddocs=false
        -Dapidocs=false
        -Dinstall-docs=false
    ADDITIONAL_BINARIES
        glib-genmarshal='${GLIB_TOOLS_DIR}/glib-genmarshal'
        glib-mkenums='${GLIB_TOOLS_DIR}/glib-mkenums'
        glib-compile-resources='${GLIB_TOOLS_DIR}/glib-compile-resources${VCPKG_HOST_EXECUTABLE_SUFFIX}'
        glib-compile-schemas='${GLIB_TOOLS_DIR}/glib-compile-schemas${VCPKG_HOST_EXECUTABLE_SUFFIX}'
)

vcpkg_install_meson()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
