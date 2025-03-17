# Dockerized Coturn TURN Server

This repository contains files to build and run a Coturn TURN server in a Docker container.

## Files

- `Dockerfile`: Defines the Docker image for the Coturn server
- `setup.sh`: Script that configures and runs the Coturn server using environment variables
- `docker-compose.yml`: Docker Compose configuration file for easy deployment

## Quick Start

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/coturn-docker.git
   cd coturn-docker
   ```

2. Edit `docker-compose.yml` to set your environment variables:
   - `TURN_PASSWORD`: Your shared secret for authentication
   - `TURN_REALM`: Your domain name or hostname
   - `TURN_INTERNAL_IP`: Container's internal IP (usually keep as 0.0.0.0)
   - `TURN_EXTERNAL_IP`: Your server's public IP address

3. Build and run the container:
   ```
   docker-compose up -d
   ```

## Running with Docker Run

If you prefer not to use Docker Compose, you can use Docker directly:

```bash
docker build -t coturn-server .

docker run -d --name coturn-server \
  -p 3478:3478/tcp \
  -p 3478:3478/udp \
  -p 49152-65535:49152-65535/udp \
  -e TURN_PASSWORD=your_secret_password \
  -e TURN_REALM=your_domain.com \
  -e TURN_INTERNAL_IP=0.0.0.0 \
  -e TURN_EXTERNAL_IP=your_public_ip \
  --restart unless-stopped \
  coturn-server
```

## Checking if the Server is Running

You can check if your Coturn server is running with:

```bash
docker logs coturn-server
```

## Testing Your TURN Server

You can test your TURN server using online WebRTC testing tools like:
- https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/

Enter your configuration:
- TURN URI: `turn:your_domain.com:3478`
- TURN username: Generate using: `echo -n "$(date +%s):username" | openssl dgst -hmac "your_secret_password" -sha1 -binary | openssl base64`
- TURN password: `your_secret_password`

## Configuration Notes

- The server is configured without TLS/DTLS for simplicity
- Private IP ranges are blocked by default for security
- The container doesn't include firewalld as Docker handles port exposure
- If you need additional configuration options, modify the `setup.sh` script

## Security Considerations

For production use, consider:
- Using TLS/DTLS by removing the `no-tls` and `no-dtls` options and configuring certificates
- Reviewing the denied IP ranges to ensure they meet your security requirements
- Using a more secure method to pass the shared secret
