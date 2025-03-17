#!/bin/bash

echo "Starting Coturn setup script..."

# Create config directory with proper permissions
mkdir -p /etc/coturn
chmod 755 /etc/coturn

# Get configuration from environment variables
password=${TURN_PASSWORD}
host=${TURN_REALM}
ip_int=${TURN_INTERNAL_IP}
ip_ext=${TURN_EXTERNAL_IP}

echo "Using configuration:"
echo "- Realm: $host"
echo "- Internal IP: $ip_int"
echo "- External IP: $ip_ext"

# Create new configuration file
echo "Creating configuration file..."
cat > /etc/coturn/turnserver.conf << EOF
listening-port=3478
listening-ip=$ip_int
external-ip=$ip_ext
relay-ip=$ip_ext/$ip_int
fingerprint
lt-cred-mech
use-auth-secret
static-auth-secret=$password
realm=$host
no-tls
no-dtls
syslog
no-multicast-peers
no-tcp-relay
denied-peer-ip=10.0.0.0-10.255.255.255
denied-peer-ip=192.168.0.0-192.168.255.255
denied-peer-ip=172.16.0.0-172.31.255.255
denied-peer-ip=0.0.0.0-0.255.255.255
denied-peer-ip=100.64.0.0-100.127.255.255
denied-peer-ip=127.0.0.0-127.255.255.255
denied-peer-ip=169.254.0.0-169.254.255.255
denied-peer-ip=192.0.0.0-192.0.0.255
denied-peer-ip=192.0.2.0-192.0.2.255
denied-peer-ip=192.88.99.0-192.88.99.255
denied-peer-ip=198.18.0.0-198.19.255.255
denied-peer-ip=198.51.100.0-198.51.100.255
denied-peer-ip=203.0.113.0-203.0.113.255
denied-peer-ip=240.0.0.0-255.255.255.255
allowed-peer-ip=$ip_int
EOF

echo "Configuration file created at /etc/coturn/turnserver.conf"

# Check if turnserver executable exists
if [ ! -f /usr/bin/turnserver ]; then
    if [ -f /usr/local/bin/turnserver ]; then
        echo "turnserver found at /usr/local/bin/turnserver"
        TURNSERVER_PATH="/usr/local/bin/turnserver"
    else
        echo "ERROR: turnserver executable not found!"
        echo "Checking potential locations..."
        find / -name turnserver -type f 2>/dev/null
        exit 1
    fi
else
    TURNSERVER_PATH="/usr/bin/turnserver"
    echo "turnserver found at $TURNSERVER_PATH"
fi

# Make sure configuration file is readable
chmod 644 /etc/coturn/turnserver.conf

echo "Starting Coturn server..."
echo "Command: $TURNSERVER_PATH -c /etc/coturn/turnserver.conf --syslog -v"

# Start the coturn service in foreground mode
exec $TURNSERVER_PATH -c /etc/coturn/turnserver.conf --syslog -v
