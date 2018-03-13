# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(XVID_VERSION 1.3.5)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/xvidcore)
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.xvid.com/downloads/xvidcore-${XVID_VERSION}.zip"
    FILENAME "xvidcore-${XVID_VERSION}.zip"
    SHA512 4476861c701eda70af5d7d65184e811af056152e6d33c9fe8b58a9f71fc30df3a502467eb91fcf93908b8ca64bcc9eaf870fea631cbe1719733b2808946fddd6
)
vcpkg_extract_source_archive(${ARCHIVE})

if(EXISTS ${SOURCE_PATH}/build/win32/libxvidcore.sln)
    # Upgrade project file
    file(REMOVE ${SOURCE_PATH}/build/win32/libxvidcore.sln)
    vcpkg_execute_required_process(
        COMMAND "devenv.exe"
                "libxvidcore.vcproj"
                /Upgrade
        WORKING_DIRECTORY ${SOURCE_PATH}/build/win32
        LOGNAME upgrade-libxvidcore-${TARGET_TRIPLET}
    )
endif()

vcpkg_find_acquire_program(NASM)
get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${NASM_EXE_PATH}")

# TODO: Split Debug and Release output
# TOOD: Add .lib output
# TODO: Figure how to enable static build 
vcpkg_build_msbuild(
    PROJECT_PATH ${SOURCE_PATH}/build/win32/libxvidcore.vcxproj
)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libxvid RENAME copyright)
