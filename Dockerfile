FROM ubuntu:18.04
MAINTAINER Reza Marzban <marzban2030@gmail.com>

# Install packages
RUN apt-get update
RUN apt-get install -y openssh-server wget curl rsync netcat mg vim bzip2 zip unzip libx11-6 libxcb1 libxau6 lxde tightvncserver xvfb dbus-x11 x11-utils xfonts-base xfonts-75dpi xfonts-100dpi python-pip python-dev python-qt4 libssl-dev
RUN mkdir /var/run/sshd

# Change root login password
RUN echo 'root:password' | chpasswd

# Change root login permission in OpenSSH server config file
RUN sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/
RUN chmod a+x /root/.vnc/xstartup
RUN touch /root/.vnc/passwd
RUN /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" > /root/.vnc/passwd
RUN chmod 400 /root/.vnc/passwd
RUN chmod go-rwx /root/.vnc
RUN touch /root/.Xauthority

COPY start.sh /root/
RUN chmod a+x /root/start.sh

EXPOSE 22 5901
ENV USER root
CMD [ "/root/start.sh" ]
