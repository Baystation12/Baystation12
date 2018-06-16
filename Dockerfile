FROM mloc6/byond:511

ARG BUILD_ARGS

COPY . /bs12

WORKDIR /bs12

RUN scripts/dm.sh $BUILD_ARGS baystation12.dme

EXPOSE 8000
VOLUME /bs12/data
VOLUME /bs12/config

ENTRYPOINT ["DreamDaemon"]
CMD ["baystation12.dmb", "8000", "-invisible", "-trusted"]
