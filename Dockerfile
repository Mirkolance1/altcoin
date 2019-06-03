FROM ubuntu:latest
COPY ./altcoin.conf /root/.altcoin/altcoin.conf
COPY . /altcoin
WORKDIR /altcoin
#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libevent-dev python3
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev
#upnp
RUN apt-get install -y libminiupnpc-dev
#ZMQ
RUN apt-get install -y libzmq3-dev
#build altcoin source
RUN make clean
RUN ./autogen.sh
RUN ./configure --disable-wallet --without-gui
RUN make
RUN make install
#open service port
EXPOSE 9999 19999
CMD ["altcoind", "--printtoconsole"]
