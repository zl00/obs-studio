# Make sure ccache is found
export PATH=/usr/local/opt/ccache/libexec:$PATH

#git fetch --tags

#./formatcode.sh
#if ! ./CI/check-format.sh; then
#	exit 1
#fi

mkdir build
cd build
cmake -S . -B build -G Xcode \
-DCMAKE_FIND_DEBUG_MODE=ON \
-DENABLE_SPARKLE_UPDATER=ON \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.11 \
-DQTDIR=/usr/local/Cellar/qt@5/5.15.5 \
-DCMAKE_PREFIX_PATH=$PWD/../cef_binary_4638_macos_x86_64 \
-DDepsPath=$PWD/../cef_binary_4638_macos_x86_64/obsdeps \
-DCMAKE_OSX_ARCHITECTURES="x86_64"
