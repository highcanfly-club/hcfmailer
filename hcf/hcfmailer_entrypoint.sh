#!/bin/bash
PORT_SSH=${PORT_SSH:-'3022'}
SSH_PUBKEY=${SSH_PUBKEY:-'ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLIHfyW0g6kUxa4hn1fWzrIY/98HVWEymk8liFRadW2bCknHdLyNnzYGOQvcHlg+mLhFhSJwiA5DaHAEwwHbRQE= key@mailtrain'}
if [ -n "$CA_CERTIFICATE" ] ; then
    echo $CA_CERTIFICATE | sed 's/|/\n/g' > /etc/ssl/certs/ca-cert.pem
    /usr/sbin/update-ca-certificates
fi
#wait for db
echo 'Info: Waiting for DB Server'
while ! nc -z $LISTMONK_db__host $LISTMONK_db__port; do sleep 1; done
cd /listmonk
echo "listening at $LISTMONK_app__address"
export LISTMONK_app__address
export LISTMONK_app__admin_username
export LISTMONK_app__admin_password
export LISTMONK_db__host
export LISTMONK_db__port
export LISTMONK_db__user
export LISTMONK_db__password
export LISTMONK_db__database
export LISTMONK_db__ssl_mode
if [ -n $LISTMONK_app__address ] && [ -n $LISTMONK_app__admin_username ] &&\
         [ -n $LISTMONK_app__admin_password ] && [ -n $LISTMONK_db__host ] && [ -n $LISTMONK_db__port ] &&\
         [ -n $LISTMONK_db__user ] && [ -n $LISTMONK_db__password ] && [ -n $LISTMONK_db__database ] && [ -n $LISTMONK_db__ssl_mode ] ;then
    echo "Build config.toml"
cat > /listmonk/config.toml <<EOF
[app]
address = "$LISTMONK_app__address"
admin_username = "$LISTMONK_app__admin_username"
admin_password = "$LISTMONK_app__admin_password"
[db]
host = "$LISTMONK_db__host"
port = $LISTMONK_db__port
user = "$LISTMONK_db__user"
password = "$LISTMONK_db__password"
database = "$LISTMONK_db__database"
ssl_mode = "$LISTMONK_db__ssl_mode"
max_open = 25
max_idle = 25
max_lifetime = "300s"
EOF
fi
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