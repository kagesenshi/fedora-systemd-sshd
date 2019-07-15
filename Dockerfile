FROM fedora:latest

ENV container docker

RUN dnf -y update \
    && dnf -y install systemd \
    && dnf clean all

#RUN rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service;

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/*

RUN ln -s /usr/lib/systemd/system/systemd-user-sessions.service \
     /lib/systemd/system/multi-user.target.wants/systemd-user-sessions.service

RUN dnf -y install passwd openssh-server hostname \
       initscripts net-tools wget curl which polkit \
       iproute iptables nmap-ncat \
       openssh-clients openssh sudo screen strace vim-common \
    && dnf update -y \
    && dnf clean all

RUN systemctl enable sshd.service \
    && echo 'password' |passwd root --stdin

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]
