#!/bin/bash
# Script cài đặt Ant Media Server cho CentOS 7/8/9
# Tích hợp: Firewalld, Logrotate (Max 50MB) và Auto-detect IP

set -e # Dừng script ngay nếu có lỗi xảy ra

# --- 0. KIỂM TRA QUYỀN ROOT ---
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Lỗi: Vui lòng chạy script với quyền root (ví dụ: sudo ./install_ams_centos.sh)"
  exit 1
fi

INSTALL_DIR="/usr/local/antmedia"
LOG_DIR="$INSTALL_DIR/log"

echo "🚀 Bắt đầu cập nhật hệ thống và cài đặt công cụ cần thiết..."
yum update -y
yum install -y wget curl unzip jq logrotate firewalld

# --- 1. TẢI VÀ CÀI ĐẶT ANT MEDIA SERVER ---
echo "⬇️ Đang tải script cài đặt chính thức..."
wget https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh -O install_ant-media-server.sh
chmod 755 install_ant-media-server.sh

echo "🔍 Lấy link tải bản Community mới nhất từ GitHub..."
AMS_URL=$(curl -s https://api.github.com/repos/ant-media/Ant-Media-Server/releases/latest | grep browser_download_url | grep 'community' | cut -d '"' -f 4)

if [ -z "$AMS_URL" ]; then
    echo "❌ Lỗi: Không thể lấy được link tải. Vui lòng kiểm tra lại mạng hoặc GitHub API."
    exit 1
fi

echo "⬇️ Đang tải file cài đặt Ant Media Server từ: $AMS_URL"
wget $AMS_URL -O ams_community.zip

echo "⚙️ Bắt đầu cài đặt Ant Media Server..."
./install_ant-media-server.sh -i ams_community.zip

# --- 2. CẤU HÌNH TƯỜNG LỬA (FIREWALLD) ---
if systemctl is-active --quiet firewalld; then
    echo "🛡️ Đang cấu hình mở các port trên Firewalld..."
    firewall-cmd --permanent --add-port=1935/tcp         # RTMP
    firewall-cmd --permanent --add-port=5080/tcp         # HTTP Panel
    firewall-cmd --permanent --add-port=5443/tcp         # HTTPS Panel
    firewall-cmd --permanent --add-port=50000-60000/udp  # WebRTC
    firewall-cmd --reload
    echo "✅ Đã mở Port thành công."
else
    echo "⚠️ Firewalld không chạy, bỏ qua bước cấu hình tường lửa."
fi

# --- 3. CẤU HÌNH LOGROTATE ---
echo "📝 Thiết lập cơ chế tự động dọn Log (Logrotate)..."
cat <<EOF | tee /etc/logrotate.d/antmedia
$LOG_DIR/*.log {
    daily
    maxsize 50M
    missingok
    rotate 2
    compress
    delaycompress
    notifempty
    create 0640 antmedia antmedia
    sharedscripts
    postrotate
        systemctl restart antmedia > /dev/null 2>/dev/null || true
    endscript
}
EOF

# --- 4. DỌN DẸP RÁC ---
echo "🧹 Đang dọn dẹp các file tạm..."
rm -f ams_community.zip install_ant-media-server.sh

# Lấy IP thật của Server
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "====================================================="
echo "✅ CÀI ĐẶT TRÊN CENTOS HOÀN TẤT!"
echo "👉 Truy cập Dashboard: http://$SERVER_IP:5080"
echo "====================================================="
