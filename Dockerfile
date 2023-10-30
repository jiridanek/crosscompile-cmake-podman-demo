# $TARGETPLATFORM, ... requires podman 4.2 (https://github.com/containers/podman/issues/14375)
ARG TARGETPLATFORM
ARG BUILDPLATFORM


# buildroot image is aarch64, provides a directory with target system environment
# for the crosscompiler
FROM --platform=$TARGETPLATFORM registry.access.redhat.com/ubi9/ubi-minimal:latest AS buildroot

RUN microdnf install -y glibc-devel



# build image runs natively, installs and runs the crosscompiler binary, and mounts
# the buildroot image
FROM --platform=$BUILDPLATFORM registry.access.redhat.com/ubi9/ubi-minimal:latest as build

RUN curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN rpm -i ./epel-release-latest-9.noarch.rpm
RUN microdnf install -y gcc-aarch64-linux-gnu gcc-c++-aarch64-linux-gnu

RUN microdnf install -y cmake make

COPY . .

RUN --mount=type=bind,from=buildroot,source=/,target=/buildroot \
    pwd \
    && ls /buildroot/usr/lib64 \
    && cat /buildroot/usr/lib64/libc.so \
    && cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake . \
    && make



# the output image is again aarch64, it contains the outputs of the compilation
FROM --platform=$TARGETPLATFORM registry.access.redhat.com/ubi9/ubi-minimal:latest

COPY --from=build /hello /hello
