#!/usr/bin/env bash

HDF5_VERSION=2.0.0
HDF5_INSTALL_DIR=$1
WORK_DIR=$2
MEMORY64_VALUE="${3:-0}"
CURRENT_SCRIPT_DIR=$(dirname "$(realpath $0)")

if [[ ! -d ${WORK_DIR} ]]; then
    mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}

if [[ ! -d "hdf5" ]]; then
    git clone https://github.com/HDFGroup/hdf5.git | exit 1
fi
cd ${WORK_DIR}/hdf5

git checkout ${HDF5_VERSION} | exit 1


HDF5_CFLAGS="-pthread"
HDF5_CXXFLAGS="-pthread"
HDF5_LDFLAGS="-pthread -sNODERAWFS=1 -sFORCE_FILESYSTEM=1 -sSINGLE_FILE=1"
if [ "${MEMORY64_VALUE}" -gt 0 ]; then
    HDF5_CFLAGS="${HDF5_CFLAGS} -s MEMORY64=${MEMORY64_VALUE}"
    HDF5_CXXFLAGS="${HDF5_CXXFLAGS} -s MEMORY64=${MEMORY64_VALUE}"
    HDF5_LDFLAGS="${HDF5_LDFLAGS} -s MEMORY64=${MEMORY64_VALUE}" # -mwasm64
fi

emcmake cmake \
        -C ${CURRENT_SCRIPT_DIR}/hdf5CMake.cmake \
        -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_C_FLAGS="${HDF5_CFLAGS}" \
        -DCMAKE_CXX_FLAGS="${HDF5_CXXFLAGS}" \
        -DCMAKE_EXE_LINKER_FLAGS_INIT="${HDF5_LDFLAGS}" \
        -S . -B build

cmake --build $PWD/build
cmake --install $PWD/build --prefix ${HDF5_INSTALL_DIR}
