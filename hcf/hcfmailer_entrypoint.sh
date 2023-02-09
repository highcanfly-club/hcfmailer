#!/bin/bash
PORT_SSH=${PORT_SSH:-'3022'}
SSH_PUBKEY=${SSH_PUBKEY:-'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLIHfyW0g6kUxa4hn1fWzrIY/98HVWEymk8liFRadW2bCknHdLyNnzYGOQvcHlg+mLhFhSJwiA5DaHAEwwHbRQE= key@mailtrain'}
if [ -n "$CA_CERTIFICATE" ] ; then
    echo $CA_CERTIFICATE | sed 's/|/\n/g' > /etc/ssl/certs/ca-cert.pem
    /usr/sbin/update-ca-certificates
fi
cd /listmonk
./listmonk --idempotent --install --yes
./listmonk --idempotent --update --yes
./listmonk &
echo 'root:`pwgen -1`'|chpasswd
mkdir -p /root/.ssh
mkdir -p /run/sshd
echo $SSH_PUBKEY > /root/.ssh/authorized_keys
echo "for managing use the private key corresponding to:" 
cat /root/.ssh/authorized_keys
ulimit -c unlimited
chmod u+x /root/.ssh/authorized_keys
mkdir -p /run/openrc/
touch /run/openrc/softlevel
while true ; do /usr/sbin/sshd -D -p $PORT_SSH -d | exit 0; sleep 1; done