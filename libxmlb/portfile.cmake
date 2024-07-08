vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hughsie/libxmlb
    REF "${VERSION}"
    SHA512 07db2e99b2f78f6e99cccbf5ca250978955d5a9bf18aaa675b2292d1df438fc3f98a5d0e8ddcfa41e686782f35947fe92b54b520b4e6e278d6e5c871e7491271
    HEAD_REF main
)

set(GLIB_TOOLS_DIR "${CURRENT_HOST_INSTALLED_DIR}/tools/glib")

# vcpkg_add_to_path("${CURRENT_HOST_INSTALLED_DIR}/tools/gperf")

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -Dstemmer=false
        -Dgtkdoc=false
        -Dtests=false
        -Dintrospection=false
        -Dcli=false
    ADDITIONAL_BINARIES
        glib-genmarshal='${GLIB_TOOLS_DIR}/glib-genmarshal'
        glib-mkenums='${GLIB_TOOLS_DIR}/glib-mkenums'
        glib-compile-resources='${GLIB_TOOLS_DIR}/glib-compile-resources${VCPKG_HOST_EXECUTABLE_SUFFIX}'
        glib-compile-schemas='${GLIB_TOOLS_DIR}/glib-compile-schemas${VCPKG_HOST_EXECUTABLE_SUFFIX}'
)

vcpkg_install_meson()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
