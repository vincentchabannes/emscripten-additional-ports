MPFR_VERSION=4.2.1 #4.0.2
MPFR_INSTALL_DIR=$1 #/opt/emsdk-additional-ports/mpfr
WORK_DIR=$2 #/tmp/mpfr

if [[ ! -d ${WORK_DIR} ]]; then
    mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}

if [[ ! -f mpfr-${MPFR_VERSION}.tar.xz ]]; then
    wget https://www.mpfr.org/mpfr-current/mpfr-${MPFR_VERSION}.tar.xz
    tar xf mpfr-${MPFR_VERSION}.tar.xz
fi

if [[ ! -d mpfr-${MPFR_VERSION}.build ]]; then
    mkdir -p mpfr-${MPFR_VERSION}.build
fi
cd mpfr-${MPFR_VERSION}.build

emconfigure ../mpfr-${MPFR_VERSION}/configure  --host none --prefix=${MPFR_INSTALL_DIR} --with-gmp=${GMP_DIR}  "CFLAGS=-pthread"  "CPPFLAGS=-pthread" "LDFLAGS=-pthread"
#--enable-thread-safe
make
make install
