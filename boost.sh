BOOST_VERSION=1.86.0
BOOST_VERSION_FILE=1_86_0
BOOST_INSTALL_DIR=$1
WORK_DIR=$2

#source /opt/emsdk/emsdk_env.sh

if [[ ! -d ${WORK_DIR} ]]; then
    mkdir -p ${WORK_DIR}
fi
cd ${WORK_DIR}

if [[ ! -f boost_${BOOST_VERSION_FILE}.tar.gz ]]; then
    wget https://archives.boost.io/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_FILE}.tar.gz | exit 1
    tar zxf boost_${BOOST_VERSION_FILE}.tar.gz | exit 1
fi

cd boost_${BOOST_VERSION_FILE}

./bootstrap.sh --with-icu=$EMSDK/upstream/emscripten/cache/ports/icu/icu
printf "using clang : emscripten : emcc -s USE_ZLIB=1 -s USE_ICU=1 : <archiver>emar <ranlib>emranlib <linker>emlink <cxxflags>\"-std=c++17 -fPIC -s USE_ICU=1\" ;" | tee -a ./project-config.jam >/dev/null

./b2 \
    -q \
    address-model=32,64 \
    link=static \
    toolset=clang-emscripten \
    variant=release \
    threading=multi \
    --layout=tagged \
    --with-program_options \
    install --prefix=${BOOST_INSTALL_DIR}

# threading: single or multi
