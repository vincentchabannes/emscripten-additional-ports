BOOST_VERSION=1.86.0
BOOST_VERSION_FILE=1_86_0
BOOST_INSTALL_DIR=$1
WORK_DIR=$2
MEMORY64_VALUE="${3:-0}"


#source /opt/emsdk/emsdk_env.sh

if [[ ! -d ${WORK_DIR} ]]; then
    mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}

if [[ ! -f boost_${BOOST_VERSION_FILE}.tar.gz ]]; then
    wget https://archives.boost.io/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_FILE}.tar.gz | exit 1
fi

if [[ ! -d boost_${BOOST_VERSION_FILE} ]]; then
    tar zxf boost_${BOOST_VERSION_FILE}.tar.gz | exit 1
fi
cd boost_${BOOST_VERSION_FILE}

#FLAG_MEMORY64=0
#ADRESS_MODEL=32
if [ "${MEMORY64_VALUE}" -gt 0 ]; then
    ADRESS_MODEL=64
else
    ADRESS_MODEL=32
fi

./bootstrap.sh --with-icu=$EMSDK/upstream/emscripten/cache/ports/icu/icu
#printf "using clang : emscripten : emcc -s USE_ZLIB=1 -s USE_ICU=1 : <archiver>emar <ranlib>emranlib <linker>emlink <cxxflags>\"-std=c++17 -pthread -fPIC -s USE_ICU=1\" ;" | tee -a ./project-config.jam >/dev/null
cat >> ./project-config.jam << EOF
using clang : emscripten
    : emcc
    : <archiver>emar
      <ranlib>emranlib
      <cxxflags>"-std=c++17 -pthread -fPIC -s MEMORY64=${MEMORY64_VALUE} -s USE_ICU=1 -s USE_ZLIB=1"
      <linkflags>" -s MEMORY64=${MEMORY64_VALUE} -s USE_ICU=1 -s USE_ZLIB=1"
    ;
EOF

#-fwasm-exceptions

./b2 \
    -q \
    -d+2 \
    link=static \
    toolset=clang-emscripten \
    address-model=${ADRESS_MODEL} \
    variant=release \
    threading=multi \
    --layout=tagged \
    --with-program_options \
    install --prefix=${BOOST_INSTALL_DIR}

#    address-model=32,64 \

# threading: single or multi
