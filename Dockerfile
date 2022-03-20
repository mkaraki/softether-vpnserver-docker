FROM debian AS build

ARG repo=https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
ARG tag=v4.38-9760-rtm

RUN apt-get update && apt-get -y install  \
    git \
    build-essential \
    libncurses5 \
    libncurses5-dev \
    libreadline8 \
    libreadline-dev \
    libssl1.1 \
    libssl-dev \
    zlib1g \
    zlib1g-dev \
    zip

RUN git clone --depth 1 -b ${tag} ${repo} /src
WORKDIR /src

RUN ./configure && \
    make

FROM debian

RUN apt-get update && apt-get -y install \
    libncurses5 \
    libncurses5-dev \
    libreadline8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=build /src/bin/vpnserver /usr/local/vpnserver/

ENV PATH=/usr/local/vpnserver:$PATH
#ENV LD_LIBRARY_PATH=/usr/local/vpnserver:$LD_LIBRARY_PATH
RUN ldconfig

WORKDIR /etc

COPY entry.sh /bin/entry.sh
RUN chmod +x /bin/entry.sh

STOPSIGNAL SIGINT

EXPOSE 500/udp 4500/udp 1701/tcp 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp

CMD [ "/bin/entry.sh" ]