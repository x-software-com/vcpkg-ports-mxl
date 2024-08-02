vcpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mesa/drm
    REF "libdrm-${VERSION}"
    SHA512 31428ec49476af3bb7acbe088ebb2411f2f69013af63afd0832546df1a45a7f45ebb472dce3f07946b9202e41deba7aae3590c2e721c56b6d64de908704ae308
    HEAD_REF main
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
            -Dtests=false
)
vcpkg_install_meson()
vcpkg_fixup_pkgconfig()

# Handle copyright: See https://gitlab.freedesktop.org/mesa/drm/-/issues/58
# vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
