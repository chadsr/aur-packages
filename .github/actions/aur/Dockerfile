FROM docker.io/library/archlinux:base-devel

RUN pacman-key --init && pacman-key --populate archlinux
RUN pacman -Syu --needed --noconfirm pacman-contrib namcap git sudo && \
  useradd -m -u 1000 builder && \
  echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER 1000
RUN git clone https://aur.archlinux.org/yay.git /home/builder/yay
WORKDIR /home/builder/yay
RUN makepkg -si --noconfirm
WORKDIR /home/builder

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
