#!/usr/bin/env bash


GMP_VERSION=6.2.1 #6.3.0
GMP_INSTALL_DIR=$1
WORK_DIR=$2 #/tmp/gmp

#source /opt/emsdk/emsdk_env.sh
#echo ${BASH_SOURCE[0]}# $( dirname "${BASH_SOURCE[0]}" )
CURRENT_SCRIPT_DIR=$(dirname "$(realpath $0)")
#echo "CURRENT_SCRIPT_DIR=${CURRENT_SCRIPT_DIR}"

if [[ ! -d ${WORK_DIR} ]]; then
    mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}

if [[ ! -f gmp-${GMP_VERSION}.tar.lz ]]; then
    wget https://gmplib.org/download/gmp/gmp-${GMP_VERSION}.tar.lz | exit 1
    tar xf gmp-${GMP_VERSION}.tar.lz | exit 1
fi

if [[ ! -d gmp-${GMP_VERSION}.build ]]; then
    mkdir -p gmp-${GMP_VERSION}.build
fi

cd gmp-${GMP_VERSION}.build
#echo $PWD

if [[ "$OSTYPE" == "darwin"* ]]; then
    # only for macos (see https://swi-prolog.discourse.group/t/swi-prolog-in-the-browser-using-wasm/5650)
    GMP_INSTALL_DIR=${GMP_INSTALL_DIR} emconfigure ${CURRENT_SCRIPT_DIR}/gmp.conf
else
    #else use this cmd
    emconfigure ../gmp-${GMP_VERSION}/configure --disable-assembly --host none --enable-cxx --prefix=${GMP_INSTALL_DIR}
fi

make -j5
make check
make install
