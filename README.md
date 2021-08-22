# Debian Base System

Build a Debian base system with systemd and sshd using Podman/Buildah.


## Run the image build

To build a Debian 10 Bullseye base image run

```bash
./build-container.sh
```

To build a Debian base with another version run e.g.

```bash
./build-container.sh buster
```

## Run the container

Run the container with SSHD listening on port 10022 for remote connections.

```bash
podman run --rm --detach --cap-add audit_write,audit_control -p=10022:22 localhost/debian-systemd-bullseye
```

Connect per SSH (host keys are regenerated at each container start).

```bash
ssh -p 10022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@host.example.org 
```


## Safety

Do not run `setup.sh` in your host system.

