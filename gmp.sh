GMP_VERSION=6.2.1 #6.3.0
GMP_INSTALL_DIR=$1 #/opt/emsdk-additional-ports/gmp
WORK_DIR=$2 #/tmp/gmp

#source /opt/emsdk/emsdk_env.sh

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

if [ ]; then
    # only for macos (see https://swi-prolog.discourse.group/t/swi-prolog-in-the-browser-using-wasm/5650)
    emconfigure ../gmp.conf
else
    #else use this cmd
    emconfigure ../gmp-${GMP_VERSION}/configure --disable-assembly --host none --enable-cxx --prefix=${GMP_INSTALL_DIR}
fi

make -j5
make check
make install
