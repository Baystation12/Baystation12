#![feature(try_trait)]
mod error;
#[macro_use]
mod byond;
mod connection;

byond_fn! { version() {
    Some(env!("CARGO_PKG_VERSION"))
} }