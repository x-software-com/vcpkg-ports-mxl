vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "force-build" FORCE_BUILD
)

if(NOT X_VCPKG_FORCE_VCPKG_WAYLAND_LIBRARIES AND NOT VCPKG_TARGET_IS_WINDOWS AND NOT FORCE_BUILD)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force vcpkg libraries by setting X_VCPKG_FORCE_VCPKG_WAYLAND_LIBRARIES")
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
else()


# Do NOT require X_VCPKG_FORCE_VCPKG_WAYLAND_LIBRARIES
# if (NOT FORCE_BUILD OR NOT X_VCPKG_FORCE_VCPKG_WAYLAND_LIBRARIES)
#     message(FATAL_ERROR "To build wayland libraries the `force-build` feature must be enabled and the X_VCPKG_FORCE_VCPKG_WAYLAND_LIBRARIES triplet variable must be set.")
# endif()

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wayland/wayland
    REF ${VERSION}
    SHA512 6ea5b22f5c0f7db4ec5d31ff4244285e98f183d6c28195af29f3e10a44f84dff1e1763e6be93722856356d3fc5c0625fb1a4e578f7c718d34025018b1ed8a33a
    HEAD_REF master
)

# VCPKG_CROSSCOMPILING seems to be always true for x64-linux-dynamic but we need the wayland-scanner
# if(VCPKG_CROSSCOMPILING)
#     set(OPTIONS -Dscanner=false)
# else()
#     set(OPTIONS -Dscanner=true)
# endif()

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS -Ddtd_validation=false
            -Ddocumentation=false
            -Dtests=false
            ${OPTIONS}
)
vcpkg_install_meson()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/" AND VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/${VCPKG_TARGET_STATIC_LIBRARY_PREFIX}wayland-private${VCPKG_TARGET_STATIC_LIBRARY_SUFFIX}"
                 DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/${VCPKG_TARGET_STATIC_LIBRARY_PREFIX}wayland-util${VCPKG_TARGET_STATIC_LIBRARY_SUFFIX}"
             DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/" AND VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/${VCPKG_TARGET_STATIC_LIBRARY_PREFIX}wayland-private${VCPKG_TARGET_STATIC_LIBRARY_SUFFIX}"
                 DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/${VCPKG_TARGET_STATIC_LIBRARY_PREFIX}wayland-util${VCPKG_TARGET_STATIC_LIBRARY_SUFFIX}"
                 DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
endif()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin/wayland-scanner${VCPKG_TARGET_EXECUTABLE_SUFFIX}" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/wayland-scanner${VCPKG_TARGET_EXECUTABLE_SUFFIX}")
vcpkg_add_to_path("${CURRENT_PACKAGES_DIR}/tools/${PORT}")
file(MAKE_DIRECTORY  "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/aclocal" "${CURRENT_PACKAGES_DIR}/share/${PORT}/aclocal")
if(VCPKG_LIBRARY_LINKAGE STREQUAL static OR NOT VCPKG_TARGET_IS_WINDOWS)
        file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

set(_file "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/wayland-scanner.pc")
if(EXISTS "${_file}")
    file(READ "${_file}" _contents)
    string(REPLACE "bindir=\${prefix}/bin" "bindir=\${prefix}/tools/${PORT}" _contents "${_contents}")
    file(WRITE "${_file}" "${_contents}")
endif()

set(_file "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/wayland-scanner.pc")
if(EXISTS "${_file}")
    file(READ "${_file}" _contents)
    string(REPLACE "bindir=\${prefix}/bin" "bindir=\${prefix}/../tools/${PORT}" _contents "${_contents}")
    file(WRITE "${_file}" "${_contents}")
endif()
endif()
