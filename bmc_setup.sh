sudo apt install -y \
gpg curl tar xz-utils make gcc flex bison \
libssl-dev libelf-dev \
llvm-9 clang-9 \
automake libevent-dev \
linux-headers-$(uname -r)

sudo apt install -y libtool pkg-config build-essential

git clone https://github.com/Orange-OpenSource/bmc-cache.git
cd bmc-cache

./kernel-src-download.sh
./kernel-src-prepare.sh

cd bmc
make

cd ..
./kernel-src-remove.sh

cd memcached-sr
./autogen.sh

CC=clang-9 CFLAGS='-DREUSEPORT_OPT=1 -Wno-deprecated-declarations' ./configure
make

sudo mount -t bpf none /sys/fs/bpf/
cd ..
./bmc/bmc 4
sudo tc qdisc add dev ens2f0 clsact
sudo tc filter add dev ens2f0 egress bpf object-pinned /sys/fs/bpf/bmc_tx_filter


