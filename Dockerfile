FROM ubuntu:latest

RUN mkdir /bs12

RUN dpkg --add-architecture i386

RUN apt-get update

RUN apt-get install -y unzip make wget libmariadb2:i386

RUN apt-get install -y libc6:i386 libstdc++6:i386

# we are not using ADD here to download it because this file should never change
# and thus, strictly caching it is okay
RUN cd /bs12/ && wget -q https://www.byond.com/download/build/511/511.1385_byond_linux.zip

RUN cd /bs12/ && unzip -q 511.1385_byond_linux.zip

COPY . /bs12/Baystation12

RUN /bin/bash -c '\
cd /bs12/byond; \
make here >/dev/null; \
source bin/byondsetup; \
cd ../Baystation12; \
ln -s /usr/lib/i386-linux-gnu/libmariadb.so.2 libmariadb.so; \
DreamMaker baystation12.dme; \
'

ENTRYPOINT cd /bs12/Baystation12 && . /bs12/byond/bin/byondsetup && DreamDaemon baystation12.dmb 8000 -invisible -trusted