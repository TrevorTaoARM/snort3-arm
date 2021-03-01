apt-get update && apt-get install -y build-essential python3 autotools-dev libdumbnet-dev libluajit-5.1-dev libpcap-dev \
zlib1g-dev pkg-config libhwloc-dev cmake liblzma-dev openssl libssl-dev cpputest libsqlite3-dev \
libtool uuid-dev git autoconf bison flex libcmocka-dev libnetfilter-queue-dev libunwind-dev \
libmnl-dev ethtool wget net-tools iputils-ping vim

wget https://github.com/rurban/safeclib/releases/download/v02092020/libsafec-02092020.tar.gz && \
tar xzvf libsafec-02092020.tar.gz && \
cd libsafec-02092020.0-g6d921f && \
./configure && \
make && make install && \ 
cd ..

wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz && \
tar xzvf pcre-8.44.tar.gz && \
cd pcre-8.44 && \
./configure && make && make install && \
cd ..

wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.8/gperftools-2.8.tar.gz && \
tar xzvf gperftools-2.8.tar.gz  && \
cd gperftools-2.8/ && \
./configure && make && make install && \
cd ..

wget http://www.colm.net/files/ragel/ragel-6.10.tar.gz && \
tar xzvf ragel-6.10.tar.gz  && \
cd ragel-6.10/ && \
./configure && make && make install && \
cd ..

wget https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz && \
tar xzvf boost_1_74_0.tar.gz  

git clone https://github.com/VectorCamp/vectorscan && \
cd vectorscan && \
git checkout v5.3.2 && \
cd .. && \
mkdir hyperscan-build && \
cd hyperscan-build/ && \
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBOOST_ROOT=/root/snort/boost_1_74_0/ /root/snort/vectorscan && \
make && make install && \
cd ..

wget https://github.com/google/flatbuffers/archive/v1.12.0.tar.gz -O flatbuffers-v1.12.0.tar.gz && \
tar xzvf flatbuffers-v1.12.0.tar.gz  && \
cd flatbuffers-1.12.0/ && \
cmake ../flatbuffers-1.12.0/ && \
make && \
make install && \
cd ..

sudo ldconfig

wget https://www.snort.org/downloads/snortplus/libdaq-3.0.0.tar.gz && \
tar xzvf libdaq-3.0.0.tar.gz  && \
cd libdaq-3.0.0/ && \
./bootstrap  && \
./configure && \
make  && make install && \
cd ..

git clone https://github.com/snort3/snort3.git && \
cd snort3 && \
git checkout 3.1.1.0 && \
./configure_cmake.sh --prefix=/usr/local  && \
cd build/ && \
make -j && make install && \
cd ../..

### Install snort3 registered ruleset
mkdir snortrules-3000 && cd snortrules-3000 && \
tar xvzf ../snort3-rules-3000.tar.gz && \
mv /usr/local/etc /usr/local/etc.orig && \
mkdir /usr/local/etc && \
cp -r * /usr/local/etc && \
cd ..

echo "export PATH=\"/usr/local/snort/bin:$PATH\"" >> $HOME/.bashrc
