sudo apt install -y build-essential pkg-config curl ca-certificates ccache python3 rsync git procps bison e2fsprogs cmake libevent-dev libboost-dev
cd bitcoin
cmake -B build -DBUILD_GUI=OFF -DWITH_BDB=OFF -DBUILD_BENCH=OFF -DBUILD_FOR_FUZZING=OFF -DBUILD_KERNEL_LIB=OFF -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_TX=OFF -DBUILD_UTIL=OFF -DBUILD_WALLET_TOOL=OFF
cmake --build build -j$(nproc)