#!/bin/bash

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]; then 
  echo "Vui lòng chạy script với quyền root (sudo)."
  exit
fi

echo "--- Đang bắt đầu quá trình cài đặt Ant Media Server ---"

# 1. Cập nhật hệ thống và cài đặt các phụ trợ
apt-get update && apt-get install -y wget curl network-manager

# 2. Tải bản cài đặt Ant Media Server (Bản Community)
# Lưu ý: Nếu bạn có bản Enterprise, hãy thay link tải bằng link bạn nhận được.
AMS_VERSION="ant-media-server-community-2.10.0-20240910_1549.zip"
DOWNLOAD_URL="https://github.com/ant-media/Ant-Media-Server/releases/download/v2.10.0/$AMS_VERSION"

if [ ! -f "$AMS_VERSION" ]; then
    echo "Đang tải $AMS_VERSION..."
    wget $DOWNLOAD_URL
fi

# 3. Tải script cài đặt chính thức của Ant Media
wget https://raw.githubusercontent.com/ant-media/Ant-Media-Server/master/src/main/server/install_ant-media-server.sh
chmod +x install_ant-media-server.sh

# 4. Thực thi cài đặt
# -i: file zip đã tải
# -r: cài đặt các dependency (như Java) tự động
./install_ant-media-server.sh -i $AMS_VERSION -r true

# 5. Mở các Port quan trọng trên UFW (nếu có dùng firewall)
if command -v ufw > /dev/null; then
    echo "Đang mở các port cần thiết trên firewall..."
    ufw allow 1935/tcp # RTMP
    ufw allow 5080/tcp # HTTP (Dashboard)
    ufw allow 5443/tcp # HTTPS
    ufw allow 5000-65000/udp # WebRTC
    ufw reload
fi

echo "--- Cài đặt hoàn tất! ---"
echo "Truy cập Dashboard tại: http://$(hostname -I | awk '{print $1}'):5080"