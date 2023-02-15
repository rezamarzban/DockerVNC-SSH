#!/bin/bash

echo "starting VNC and SSH server ..."
export USER=root
vncserver :1 -geometry 1024x768 -depth 16 && /usr/sbin/sshd -D