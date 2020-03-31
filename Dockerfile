FROM xales/byond:512-latest


ENV PATH=/root/cargo/bin:/root/rustup/bin:$PATH\
	CARGO_HOME=/root/cargo\
	RUSTUP_HOME=/root/rustup

RUN apt-get update && apt-get install -y curl git gcc-multilib;\
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init; \
	chmod +x rustup-init; \
	./rustup-init -y --no-modify-path;\
	rm rustup-init;\
	rustup default stable;\
	rustup target add i686-unknown-linux-gnu

RUN git clone https://github.com/Lohikar/byhttp.git /byhttp || true
WORKDIR /byhttp
RUN mkdir to_copy;\
	cargo build --release --target i686-unknown-linux-gnu;\
	mv -t to_copy target/i686-unknown-linux-gnu/release/libbyhttp.so || true

RUN git clone https://github.com/mloc/fluey.git /fluey || true
WORKDIR /fluey
RUN mkdir to_copy;\
	cargo build --release --target i686-unknown-linux-gnu;\
	mv -t to_copy target/i686-unknown-linux-gnu/release/libfluey.so || true

FROM xales/byond:512-latest

ARG BUILD_ARGS
ENV RUNAS=root

RUN apt-get update && apt-get install -y gosu

COPY --from=0 /byhttp/to_copy /bs12/lib
COPY --from=0 /fluey/to_copy /bs12/lib
COPY . /bs12

WORKDIR /bs12
RUN scripts/dm.sh $BUILD_ARGS -DUSE_STRUCTURED_LOGGING baystation12.dme

EXPOSE 8000
VOLUME /bs12/data
VOLUME /bs12/config

ENTRYPOINT ["./docker-entrypoint.sh"]
