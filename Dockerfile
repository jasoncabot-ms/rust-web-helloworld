# select build image
FROM rust:1-stretch as build

# create a new empty shell project
RUN USER=root cargo new --bin rust-web-helloworld
WORKDIR /rust-web-helloworld

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/rust_web_helloworld*
RUN cargo build --release

# our final base
FROM debian:stretch-slim

# copy the build artifact from the build stage
COPY --from=build /rust-web-helloworld/target/release/rust-web-helloworld /bin/

# the port the server is listening on
EXPOSE 8000

# set the startup command to run your binary
CMD ["/bin/rust-web-helloworld"]
