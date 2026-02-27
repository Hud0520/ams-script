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

# 2. Kiểm tra nếu Ubuntu hoặc CentOS đã sẵn sàng
Write-Host "⚙️ Đang tiến hành kiểm tra môi trường Linux trong WSL..." -ForegroundColor Cyan

# Kiểm tra OS bên trong WSL
$osFamily = wsl bash -c "if [ -f /etc/debian_version ]; then echo 'debian'; elif [ -f /etc/redhat-release ]; then echo 'rhel'; else echo 'unknown'; fi"

if ($osFamily -eq "debian") {
    Write-Host "Detected Debian/Ubuntu family in WSL. Running Ubuntu script..." -ForegroundColor Green
    wsl -u root bash -c "curl -sSL https://raw.githubusercontent.com/Hud0520/ams-script/main/script/install_ams_ubuntu.sh | bash"
} elseif ($osFamily -eq "rhel") {
    Write-Host "Detected RHEL/CentOS family in WSL. Running CentOS script..." -ForegroundColor Green
    wsl -u root bash -c "curl -sSL https://raw.githubusercontent.com/Hud0520/ams-script/main/script/install_ams_centos.sh | bash"
} else {
    Write-Host "⚠️ Không nhận diện được họ Linux trong WSL hoặc WSL chưa sẵn sàng. Mặc định chạy script Ubuntu..." -ForegroundColor Yellow
    wsl -u root bash -c "curl -sSL https://raw.githubusercontent.com/Hud0520/ams-script/main/script/install_ams_ubuntu.sh | bash"
}

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "✅ QUÁ TRÌNH CÀI ĐẶT QUA WSL HOÀN TẤT!" -ForegroundColor Green
Write-Host "👉 Lưu ý: Bạn có thể truy cập Dashboard tại: http://localhost:5080" -ForegroundColor White
Write-Host "=====================================================" -ForegroundColor Green
