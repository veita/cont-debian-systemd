#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update -qy
apt-get upgrade -qy
apt-get install -qy systemd systemd-sysv sudo locales lsb-release wget curl \
                    gnupg2 less vim screen ripgrep tree unzip htop

# cleanup Systemd configuration
rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

# install SSH
apt-get install -y openssh-server

# configure sshd
if [ -f /root/.ssh/authorized_keys ]; then
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
else
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

    # set the root password to admin
    echo 'root:admin' | chpasswd
fi

sed -i 's/#MaxAuthTries [0-9]\+/MaxAuthTries 32/g' /etc/ssh/sshd_config

# regenerate host key on container startup
mkdir /etc/systemd/system/sshd.service.d

cat << EOF > /etc/systemd/system/sshd.service.d/regenerate-host-keys.conf
[Service]
ExecStartPre=/bin/bash -c '/bin/rm /etc/ssh/ssh_host_* || :'
ExecStartPre=/usr/sbin/dpkg-reconfigure --frontend=noninteractive openssh-server
ExecStartPre=/bin/rm -rf /etc/systemd/system/sshd.service.d
EOF

chmod 644 /etc/systemd/system/sshd.service.d/regenerate-host-keys.conf

# system configuration: locales
echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
/usr/sbin/locale-gen

# global shell configuration
sed -i 's/# "\\e\[5~": history-search-backward/"\\e\[5~": history-search-backward/g' /etc/inputrc
sed -i 's/# "\\e\[6~": history-search-forward/"\\e\[6~": history-search-forward/g' /etc/inputrc

sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd

sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /etc/skel/.bashrc

# global vim configuration
sed -i 's/"syntax on/syntax on/g' /etc/vim/vimrc
sed -i 's/"set background=dark/set background=dark/g' /etc/vim/vimrc

# global screen configuration
sed -i 's/#startup_message off/startup_message off/g' /etc/screenrc

# shell settings for root
cat << EOF >> /root/.bashrc
PS1='\[\033[01;33m\](container) \u@\h\[\033[01;34m\] \w \$\[\033[00m\] '

alias l="ls --time-style=long-iso --color=always -laF"
alias ll="ls --time-style=long-iso --color=auto -laF"
alias ls="ls --time-style=long-iso --color=auto"
alias dt="date --utc '+%Y-%m-%d %H:%M:%S UTC'"
alias g="grep --exclude-dir .git --exclude-dir .svn --color=always"
alias o="less -r"
alias s="screen"
alias t="screen -dr || screen"
alias v="vim"
alias ..="cd .."
alias ...="cd ../.."

alias halt="systemctl poweroff"
alias sc=systemctl
alias jc=journalctl
EOF

# services
systemctl enable ssh.service

# cleanup
apt-get autoremove -qy
apt-get clean -qy

rm -rf /tmp/* /var/tmp/*

