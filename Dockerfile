FROM mloc6/byond:511

COPY . /bs12
RUN chown -R nobody:nogroup /bs12

USER nobody

WORKDIR /bs12

RUN DreamMaker baystation12.dme

EXPOSE 8000
VOLUME /bs12/data
VOLUME /bs12/config

ENTRYPOINT ["DreamDaemon"]
CMD ["baystation12.dmb", "8000", "-invisible", "-trusted"]
