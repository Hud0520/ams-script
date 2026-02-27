FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    iproute2 \
    cron \
    logrotate \
    dnsutils \
    iptables \
    jq \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home

# Get latest AMS Community download URL and download it
RUN AMS_URL=$(curl -s https://api.github.com/repos/ant-media/Ant-Media-Server/releases/latest | grep browser_download_url | grep 'community' | cut -d '"' -f 4) \
    && wget "$AMS_URL" -O ams.zip

# Download and run the official installation script
RUN wget https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh -O install_ant-media-server.sh \
    && chmod 755 install_ant-media-server.sh \
    && ./install_ant-media-server.sh -i ams.zip -s false \
    && rm ams.zip install_ant-media-server.sh

# Expose ports (for reference, net=host is recommended)
EXPOSE 1935 5080 5443 50000-60000/udp

ENTRYPOINT ["/usr/local/antmedia/start.sh"]
