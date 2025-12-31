#!/bin/bash
set -e

echo "======================================"
echo " Debian noVNC + Fluxbox 安装脚本"
echo "======================================"

DEFAULT_VNC_PORT=5901
DEFAULT_NOVNC_PORT=6080
DEFAULT_RES="1280x800x24"

read -p "请输入 VNC 端口 [$DEFAULT_VNC_PORT]: " VNC_PORT
VNC_PORT=${VNC_PORT:-$DEFAULT_VNC_PORT}

read -p "请输入 noVNC 端口 [$DEFAULT_NOVNC_PORT]: " NOVNC_PORT
NOVNC_PORT=${NOVNC_PORT:-$DEFAULT_NOVNC_PORT}

read -p "请输入分辨率 [$DEFAULT_RES]: " SCREEN_RES
SCREEN_RES=${SCREEN_RES:-$DEFAULT_RES}

echo
echo "📦 安装依赖中..."

apt update
apt install -y \
  fluxbox \
  firefox-esr \
  tightvncserver \
  websockify \
  novnc \
  xvfb \
  x11vnc \
  dbus-x11 \
  fonts-dejavu-core

cat > config.env <<EOF
DISPLAY_NUM=:0
VNC_PORT=$VNC_PORT
NOVNC_PORT=$NOVNC_PORT
SCREEN_RES=$SCREEN_RES
EOF

chmod +x start.sh

echo
echo "======================================"
echo "✅ 安装完成"
echo "👉 运行： ./start.sh"
echo "🌐 访问: http://<你的IP>:$NOVNC_PORT/vnc.html"
echo "======================================"
