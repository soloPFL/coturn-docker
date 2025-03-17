#!/bin/bash

# We don't need to configure the service activation file
# since we're running coturn directly, not as a service

# Get configuration from environment variables
password=${TURN_PASSWORD}
host=${TURN_REALM}
ip_int=${TURN_INTERNAL_IP}
ip_ext=${TURN_EXTERNAL_IP}

# Create new configuration file
rm -f /etc/turnserver.conf
touch /etc/turnserver.conf

echo "listening-port=3478" >> /etc/turnserver.conf
echo "listening-ip=$ip_int" >> /etc/turnserver.conf
echo "external-ip=$ip_ext" >> /etc/turnserver.conf
echo "relay-ip=$ip_ext/$ip_int" >> /etc/turnserver.conf
echo "fingerprint" >> /etc/turnserver.conf
echo "lt-cred-mech" >> /etc/turnserver.conf
echo "use-auth-secret" >> /etc/turnserver.conf
echo "static-auth-secret=$password" >> /etc/turnserver.conf
echo "realm=$host" >> /etc/turnserver.conf
echo "no-tls" >> /etc/turnserver.conf
echo "no-dtls" >> /etc/turnserver.conf
echo "syslog" >> /etc/turnserver.conf
echo "no-multicast-peers" >> /etc/turnserver.conf
echo "no-tcp-relay" >> /etc/turnserver.conf
echo "denied-peer-ip=10.0.0.0-10.255.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=192.168.0.0-192.168.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=172.16.0.0-172.31.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=0.0.0.0-0.255.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=100.64.0.0-100.127.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=127.0.0.0-127.255.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=169.254.0.0-169.254.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=192.0.0.0-192.0.0.255" >> /etc/turnserver.conf
echo "denied-peer-ip=192.0.2.0-192.0.2.255" >> /etc/turnserver.conf
echo "denied-peer-ip=192.88.99.0-192.88.99.255" >> /etc/turnserver.conf
echo "denied-peer-ip=198.18.0.0-198.19.255.255" >> /etc/turnserver.conf
echo "denied-peer-ip=198.51.100.0-198.51.100.255" >> /etc/turnserver.conf
echo "denied-peer-ip=203.0.113.0-203.0.113.255" >> /etc/turnserver.conf
echo "denied-peer-ip=240.0.0.0-255.255.255.255" >> /etc/turnserver.conf
echo "allowed-peer-ip=$ip_int" >> /etc/turnserver.conf

# Start the coturn service in foreground mode
exec /usr/bin/turnserver -c /etc/turnserver.conf --syslog -v
