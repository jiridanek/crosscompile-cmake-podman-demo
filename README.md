# Enable instruction emulation

(Needed both for running the aarch64 result and for building, e.g. running microdnf on the aarch64 image.)

Either install qemu-user-static (on Fedora)

    sudo dnf install -y qemu-user-static

or load this through docker/podman (other Linux)

    sudo podman run --privileged --rm docker.io/tonistiigi/binfmt --install all

# Build image with

## Docker

    docker build --platform=linux/arm64 -t local/hello .

## Podman

    podman build --platform=linux/arm64 -t local/hello .

# Run the result

```shell
% podman run --rm -it local/hello /hello
WARNING: image platform (linux/arm64) does not match the expected platform (linux/amd64)
Hello
```


