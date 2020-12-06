FROM xales/byond:512-latest

ARG BUILD_ARGS
ENV RUNAS=root

COPY . /bs12

WORKDIR /bs12

RUN apt-get update && apt-get install -y gosu
RUN scripts/dm.sh $BUILD_ARGS baystation12.dme

EXPOSE 8000
VOLUME /bs12/data
VOLUME /bs12/config

ENTRYPOINT ["./docker-entrypoint.sh"]
