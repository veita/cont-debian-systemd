# Debian Base System

Build a Debian base system container image with Systemd and SSH remote access
using Podman/Buildah.

Containers based on this image can be used as lightweight replacements for
virtual machines.


## Run the image build

To build a Debian 10 Bullseye image run

```bash
./build-container.sh
```

To build an image with a specific Debian version
(`buster`, `bullseye`, `bookworm`) run

```bash
./build-container.sh buster
```

Without placing a `root/.ssh/authorized_keys` file in the project directory
the build script configures the SSH daemon for root access with the password
`admin`.  Otherwise SSH root login using a password is prohibited and restriced
to the given SSH keys.


## Run the container

Run the container with sshd listening on port 10022 for remote connections.

```bash
podman run --rm --detach --cap-add audit_write,audit_control -p=10022:22 localhost/debian-systemd-bullseye
```

Connect per SSH (host keys are regenerated at each container start).

```bash
ssh -p 10022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@host.example.org 
```


## Safety

Do not run `setup.sh` in your host system.

