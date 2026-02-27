# Script tự động cài đặt Ant Media Server trên Windows qua WSL2
# Yêu cầu quyền Administrator

Write-Host "🚀 Đang kiểm tra môi trường WSL2..." -ForegroundColor Cyan

# 1. Kiểm tra WSL đã được cài đặt chưa
if (!(Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ WSL chưa được cài đặt. Đang tiến hành cài đặt..." -ForegroundColor Yellow
    wsl --install
    Write-Host "✅ Đã kích hoạt cài đặt WSL. VUI LÒNG KHỞI ĐỘNG LẠI MÁY và chạy lại script này." -ForegroundColor Green
    exit
}

# 2. Kiểm tra nếu Ubuntu đã sẵn sàng
Write-Host "⚙️ Đang tiến hành cài đặt Ant Media Server vào môi trường Linux (Ubuntu)..." -ForegroundColor Cyan

# Gọi script Ubuntu trực tiếp từ GitHub chạy trong WSL
wsl -u root bash -c "curl -sSL https://raw.githubusercontent.com/Hud0520/ams-script/main/script/install_ams_linux_ubuntu.sh | bash"

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "✅ QUÁ TRÌNH CÀI ĐẶT QUA WSL HOÀN TẤT!" -ForegroundColor Green
Write-Host "👉 Lưu ý: Bạn có thể truy cập Dashboard tại: http://localhost:5080" -ForegroundColor White
Write-Host "=====================================================" -ForegroundColor Green
