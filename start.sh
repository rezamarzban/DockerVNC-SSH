#!/bin/bash

echo "starting VNC and SSH server ..."
export USER=root
vncserver && /usr/sbin/sshd -D
