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

set(VREP_VERSION v3.5.0)
include(vcpkg_common_functions)

macro(move_directory srcDir outDir)
    execute_process(COMMAND ${CMAKE_COMMAND}
                    -E copy_directory
                    "${srcDir}" "${outDir}")
endmacro()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CoppeliaRobotics/v_rep
    REF ${VREP_VERSION}
    SHA512 c84ce7235c59b61d92de1e5f2e93d244f37a119024561753091d37ce77ad0520eb6f90548c204b3819fd728ed07fa19aab47c2062b749f7732522b3443b6435e
    HEAD_REF master
)

vcpkg_from_github(
    OUT_SOURCE_PATH VREP_TEMP_PATH
    REPO CoppeliaRobotics/include
    REF vrep-${VREP_VERSION}
    SHA512 98eb8bb587c0a73f33e5bd7fd63dc84366e2bdc9d6468afc5bfdd6bd2a0db4713e7699caf6fb3a2ee22f9547f580557a640e9f2e6777b7366ad9d4ade2d7d549
    HEAD_REF master
)
move_directory(${VREP_TEMP_PATH} ${CURRENT_BUILDTREES_DIR}/src/programming/include)

vcpkg_from_github(
    OUT_SOURCE_PATH VREP_TEMP_PATH
    REPO CoppeliaRobotics/common
    REF vrep-${VREP_VERSION}
    SHA512 36634f3503986bb056754c6484dd3ba5a35421e22131a0b1466dce21cca8a416869fe660500e51bf0071a4221a9317022e9b149fd76f1a58f74ffe33fb8f4790
    HEAD_REF master
)
move_directory(${VREP_TEMP_PATH} ${CURRENT_BUILDTREES_DIR}/src/programming/common)

vcpkg_from_github(
    OUT_SOURCE_PATH VREP_TEMP_PATH
    REPO CoppeliaRobotics/v_repMath
    REF vrep-${VREP_VERSION}
    SHA512 ffdcaf5b2e794deb250dc8768c5a088190291367ace28e4504b89488d8bd1b662415a94cbc7cf2736be1b8aee7b099b800b2fc59fac4f94d356f0bb0fa16e768
    HEAD_REF master
)
move_directory(${VREP_TEMP_PATH} ${CURRENT_BUILDTREES_DIR}/src/programming/v_repMath)

# Patches:
# Make WITH_GUI and WITH_SERIAL optional

vcpkg_configure_qmake(
    SOURCE_PATH ${SOURCE_PATH}
    # OPTIONS
    #     -before ${SOURCE_PATH}/v_rep.pri
    #     CONFIG-=WITH_SERIAL
)

vcpkg_build_qmake()

# Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/vrep RENAME copyright)
