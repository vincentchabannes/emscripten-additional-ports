MPFR_VERSION=4.2.2 #4.2.1 #4.0.2
MPFR_INSTALL_DIR=$1 #/opt/emsdk-additional-ports/mpfr
WORK_DIR=$2 #/tmp/mpfr
MEMORY64_VALUE="${3:-0}"

GMP_DIR=${GMP_DIR:-${MPFR_INSTALL_DIR}}

if [[ ! -d ${WORK_DIR} ]]; then
    mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}

if [[ ! -f mpfr-${MPFR_VERSION}.tar.xz ]]; then
    wget --no-check-certificate https://www.mpfr.org/mpfr-current/mpfr-${MPFR_VERSION}.tar.xz
    tar xf mpfr-${MPFR_VERSION}.tar.xz
fi

if [[ ! -d mpfr-${MPFR_VERSION}.build ]]; then
    mkdir -p mpfr-${MPFR_VERSION}.build
fi
cd mpfr-${MPFR_VERSION}.build

MPFR_CFLAGS="-pthread"
MPFR_CXXFLAGS="-pthread"
MPFR_LDFLAGS="-pthread"
if [ "${MEMORY64_VALUE}" -gt 0 ]; then
    # needed for macos builds
    MPFR_CFLAGS="${MPFR_CFLAGS} -s MEMORY64=1"
    MPFR_CXXFLAGS="${MPFR_CXXFLAGS} -s MEMORY64=1"
    MPFR_LDFLAGS="${GMP_LDFLAGS} -s MEMORY64=1" # -mwasm64
fi

CFLAGS=${MPFR_CFLAGS} CXXFLAGS=${MPFR_CXXFLAGS} LDFLAGS=${MPFR_LDFLAGS}  emconfigure ../mpfr-${MPFR_VERSION}/configure  --host none --prefix=${MPFR_INSTALL_DIR} --with-gmp=${GMP_DIR}
#--enable-thread-safe
make
make install
