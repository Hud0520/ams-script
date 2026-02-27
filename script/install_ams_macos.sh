#!/bin/bash
# Script hỗ trợ cài đặt Ant Media Server cho macOS (Homebrew)
# Lưu ý: AMS chạy tốt nhất trên Docker hoặc Linux. Bản dành cho macOS chủ yếu để test.

set -e

echo "🚀 Kiểm tra Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "❌ Lỗi: Vui lòng cài đặt Homebrew (https://brew.sh/) trước khi chạy script."
    exit 1
fi

echo "📦 Cài đặt các package phụ trợ..."
brew install wget curl jq

echo "🔍 Lấy link tải bản Community mới nhất..."
AMS_URL=$(curl -s https://api.github.com/repos/ant-media/Ant-Media-Server/releases/latest | grep browser_download_url | grep 'community' | cut -d '"' -f 4)

if [ -z "$AMS_URL" ]; then
    echo "❌ Lỗi: Không thể lấy link tải."
    exit 1
fi

INSTALL_DIR="$HOME/ant-media-server"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "⬇️ Đang tải AMS về thư mục: $INSTALL_DIR"
wget $AMS_URL -O ams.zip
unzip -o ams.zip
rm ams.zip

echo "====================================================="
echo "✅ TẢI VÀ GIẢI NÉN HOÀN TẤT!"
echo "👉 Để chạy server, hãy dùng lệnh:"
echo "   cd $INSTALL_DIR && ./start.sh"
echo "👉 Truy cập Dashboard tại: http://localhost:5080"
echo "====================================================="
