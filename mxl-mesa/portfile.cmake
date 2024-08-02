vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mesa/mesa
    REF "mesa-${VERSION}"
    SHA512 39bd1a7ce618c95709594ab8c8ac72c38d24ea582ffe618d4746cc2c3ceafbc99019412289612f7d21be6851b8d8061649759e96096fedbec1e837ffa1136c18
    HEAD_REF master
)

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dplatforms=x11,wayland
        -Dglx=dri
        -Dgles1=enabled
        -Dgles2=enabled
        -Dopengl=true
        -Dgbm=enabled
        -Degl=enabled
        -Dgallium-drivers=swrast
        -Dllvm=disabled
        -Dvulkan-drivers=
)
vcpkg_install_meson()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    # installed by egl-registry
    "${CURRENT_PACKAGES_DIR}/include/KHR"
    "${CURRENT_PACKAGES_DIR}/include/EGL"
    # installed by opengl-registry
    # "${CURRENT_PACKAGES_DIR}/include/GL"
    # "${CURRENT_PACKAGES_DIR}/include/GLES"
    # "${CURRENT_PACKAGES_DIR}/include/GLES2"
    # "${CURRENT_PACKAGES_DIR}/include/GLES3"
)
file(GLOB remaining "${CURRENT_PACKAGES_DIR}/include/*")
if(NOT remaining)
    # All headers to be provided by egl-registry and/or opengl-registry
    set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/docs/license.rst")
