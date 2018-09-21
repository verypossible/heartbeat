FROM elixir:1.7.3

COPY ./ /opt/firmware

RUN wget https://github.com/fhunleth/fwup/releases/download/v1.2.5/fwup_1.2.5_amd64.deb

RUN apt-get update && apt-get install -fy make g++ build-essential automake autoconf git squashfs-tools ssh-askpass libssl-dev libncurses5-dev bc m4 unzip cmake python cpio rsync ./fwup_1.2.5_amd64.deb

RUN mix local.hex --force && mix local.rebar && mix archive.install hex nerves_bootstrap --force

WORKDIR /opt/firmware

ENV MIX_TARGET="rpi3_sudo"

VOLUME ./output

RUN mix deps.get
