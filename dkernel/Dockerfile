FROM debian:latest
RUN apt-get update
RUN apt-get install gcc perl-base make flex bison xz-utils wget libelf-dev bc libssl-dev -y
RUN wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.7.3.tar.xz -O /usr/src/linux-6.7.3.tar.xz
RUN cd /usr/src && tar xf linux-6.7.3.tar.xz
RUN rm /usr/src/linux-6.7.3.tar.xz
COPY ./.config /usr/src/linux-6.7.3/
RUN cd /usr/src/linux-6.7.3 && make -j12

CMD sleep 100000

