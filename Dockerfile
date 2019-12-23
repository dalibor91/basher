FROM debian

RUN apt-get update
RUN apt-get install -y curl wget sudo ssh-client

RUN sudo mkdir /var/lib/bshr
COPY ./basher.sh /bin/bshr

COPY . /test
WORKDIR /test

RUN bash ./scripts/test/_add.sh

RUN useradd -ms /bin/bash test
