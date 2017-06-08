FROM ubuntu:16.04

# Libraries
RUN apt-get update
RUN set -x && \
  apt-get -y install \
  wget \
  curl \
  libudns-dev \
  libglib2.0-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  libreadline-dev \
  libsqlite3-dev \
  python-dev \
  libtool \
  automake \
  autoconf \
  build-essential \
  subversion \
  git-core \
  flex \
  bison \
  pkg-config \
  libnl-3-dev \
  libnl-genl-3-dev \
  libnl-nf-3-dev \
  libnl-route-3-dev \
  sqlite3

# Clone Dionaea
RUN cd /opt/ && git clone https://github.com/rep/dionaea.git dionaea

# Install Liblcfg
RUN set -x && \
  cd /usr/local/src && \
  git clone https://github.com/pb-/liblcfg.git liblcfg && \
  cd liblcfg/code && \
  autoreconf -vi && \
  ./configure -prefix=/opt/dionaea && \
  make install

# Install Libemu
RUN set -x && \
  cd /usr/local/src && \
  git clone https://github.com/cperdana/libemu.git libemu && \
  cd libemu && \
  autoreconf -vi && \
  find ./ -type f | xargs sed -i "s/-Werror//g" && \
  ./configure -prefix=/opt/dionaea && \
  make && \
  make install

# Install LibEv
RUN set -x && \
  cd /usr/local/src &&  \
  wget http://dist.schmorp.de/libev/Attic/libev-4.20.tar.gz && \
  tar xzf libev-4.20.tar.gz && \
  cd libev-4.20 && \
  ./configure -prefix=/opt/dionaea && \
  make install

# Install Libpcap
RUN set -x && \
  cd /usr/local/src && \
  wget http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz && \
  tar xzf libpcap-1.8.1.tar.gz && \
  cd libpcap-1.8.1 && \
  ./configure -prefix=/opt/dionaea && \
  make install

# Install Python
RUN set -x && \
  cd /usr/local/src && \
  wget http://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz && \
  tar xzf Python-3.6.1.tgz && \
  cd Python-3.6.1 && \
  ./configure --enable-shared -prefix=/opt/dionaea --with-computed-gotos -enable-ipv6 LDFLAGS="-Wl,-rpath=/opt/dionaea/lib -L/usr/lib/x86_64-linux-gnu/" && \
  make && \
  make install

# Install Cython
RUN set -x && \
  cd /usr/local/src && \
  wget https://pypi.python.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz && \
  tar xzf Cython-0.24.1.tar.gz && \
  cd Cython-0.24.1 && \
  /opt/dionaea/bin/python3 setup.py install

# Install Openssl
RUN set -x && \
  cd /usr/local/src && \
  wget https://github.com/openssl/openssl/archive/OpenSSL_1_0_1p.tar.gz && \
  tar xzf OpenSSL_1_0_1p.tar.gz && \
  cd openssl-OpenSSL_1_0_1p && \
  ./Configure shared --prefix=/opt/dionaea linux-x86_64 && \
  make && \
  make install

# Install Dionaea
RUN set -x && \
  cd /opt/dionaea && \
  autoreconf -vi && \
  find ./ -type f -print0 | xargs -0 sed -i "s/-Werror//g" && \
  rm -rf /opt/dionaea/modules/python/util/gnuplotsql && \
  ./configure --with-lcfg-include=/opt/dionaea/include/ \
      --with-lcfg-lib=/opt/dionaea/lib/ \
      --with-python=/opt/dionaea/bin/python3.6 \
      --with-cython-dir=/opt/dionaea/bin \
      --with-udns-include=/opt/dionaea/include/ \
      --with-udns-lib=/opt/dionaea/lib/ \
      --with-emu-include=/opt/dionaea/include/ \
      --with-emu-lib=/opt/dionaea/lib/ \
      --with-gc-include=/usr/include/gc \
      --with-ev-include=/opt/dionaea/include \
      --with-ev-lib=/opt/dionaea/lib \
      --with-nl-include=/opt/dionaea/include \
      --with-nl-lib=/opt/dionaea/lib/ \
      --with-curl-config=/usr/bin/ \
      --with-pcap-include=/opt/dionaea/include \
      --with-pcap-lib=/opt/dionaea/lib/ \
      --with-ssl-include=/opt/dionaea/include/ \
      --with-ssl-lib=/opt/dionaea/lib/ && \
  make && \
  make install

# Setup Dionaea
ADD config /opt/dionaea/etc/dionaea/config
RUN /bin/bash /opt/dionaea/etc/dionaea/config/setup.sh

# Add User
RUN groupadd --gid 1000 dionaea && \
  useradd -m --uid 1000 --gid 1000 dionaea && \
  chown -R dionaea:dionaea /opt/dionaea/var

# EXPOSE 21 42 69/udp 80 135 443 445 1433 1723 1883 1900/udp 3306 5060 5060/udp 5061 11211
# CMD ["/opt/dionaea/bin/dionaea", "-D"]
