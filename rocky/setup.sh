#!/bin/bash

# No need for service activation file as we're running turnserver directly

# Create turnserver config directory if it doesn't exist
mkdir -p /etc/coturn

# Get configuration from environment variables
password=${TURN_PASSWORD}
host=${TURN_REALM}
ip_int=${TURN_INTERNAL_IP}
ip_ext=${TURN_EXTERNAL_IP}

# Create new configuration file
rm -f /etc/coturn/turnserver.conf
touch /etc/coturn/turnserver.conf

echo "listening-port=3478" >> /etc/coturn/turnserver.conf
echo "listening-ip=$ip_int" >> /etc/coturn/turnserver.conf
echo "external-ip=$ip_ext" >> /etc/coturn/turnserver.conf
echo "relay-ip=$ip_ext/$ip_int" >> /etc/coturn/turnserver.conf
echo "fingerprint" >> /etc/coturn/turnserver.conf
echo "lt-cred-mech" >> /etc/coturn/turnserver.conf
echo "use-auth-secret" >> /etc/coturn/turnserver.conf
echo "static-auth-secret=$password" >> /etc/coturn/turnserver.conf
echo "realm=$host" >> /etc/coturn/turnserver.conf
echo "no-tls" >> /etc/coturn/turnserver.conf
echo "no-dtls" >> /etc/coturn/turnserver.conf
echo "syslog" >> /etc/coturn/turnserver.conf
echo "no-multicast-peers" >> /etc/coturn/turnserver.conf
echo "no-tcp-relay" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=10.0.0.0-10.255.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=192.168.0.0-192.168.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=172.16.0.0-172.31.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=0.0.0.0-0.255.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=100.64.0.0-100.127.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=127.0.0.0-127.255.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=169.254.0.0-169.254.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=192.0.0.0-192.0.0.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=192.0.2.0-192.0.2.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=192.88.99.0-192.88.99.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=198.18.0.0-198.19.255.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=198.51.100.0-198.51.100.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=203.0.113.0-203.0.113.255" >> /etc/coturn/turnserver.conf
echo "denied-peer-ip=240.0.0.0-255.255.255.255" >> /etc/coturn/turnserver.conf
echo "allowed-peer-ip=$ip_int" >> /etc/coturn/turnserver.conf

# Start the coturn service in foreground mode
exec /usr/bin/turnserver -c /etc/coturn/turnserver.conf --syslog -v
