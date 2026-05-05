
# NOTE: Using GitHub mirror to avoid Anubis check failure on GNOME GitLab
# https://github.com/microsoft/vcpkg/issues/48350
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GNOME/librsvg
    REF refs/tags/${VERSION}
    SHA512 874772963c5f03cfeddae9f4e7394da52fda2c7fc3d91e2b8bc0c3d61d4b0771ccc68b12745e957834e83229017d11cc7de9df1dece105305328fa822a623bc7
    HEAD_REF master
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Ddocs=disabled
        -Drsvg-convert=disabled
        -Dintrospection=disabled
        -Dpixbuf-loader=enabled
        -Dtests=false
        -Dvala=disabled
    ADDITIONAL_BINARIES
        glib-mkenums='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-mkenums'
        glib-genmarshal='${CURRENT_HOST_INSTALLED_DIR}/tools/glib/glib-genmarshal'
)

vcpkg_install_meson()

file(REMOVE "${CURRENT_PACKAGES_DIR}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache")

vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING.LIB")
