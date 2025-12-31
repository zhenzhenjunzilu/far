#!/bin/sh

set -e

echo "======================================"
echo " Alpine noVNC + Fluxbox 安装脚本"
echo "======================================"

# 默认值
DEFAULT_VNC_PORT=5900
DEFAULT_NOVNC_PORT=6080
DEFAULT_RES="1280x800x24"

echo
read -p "请输入 VNC 端口 [$DEFAULT_VNC_PORT]: " VNC_PORT
VNC_PORT=${VNC_PORT:-$DEFAULT_VNC_PORT}

read -p "请输入 noVNC 端口 [$DEFAULT_NOVNC_PORT]: " NOVNC_PORT
NOVNC_PORT=${NOVNC_PORT:-$DEFAULT_NOVNC_PORT}

read -p "请输入分辨率 [$DEFAULT_RES]: " SCREEN_RES
SCREEN_RES=${SCREEN_RES:-$DEFAULT_RES}

echo
echo "📦 安装依赖中..."

apk update
apk add --no-cache \
  fluxbox \
  firefox \
  xorg-server \
  xf86-video-dummy \
  xf86-input-libinput \
  x11vnc \
  xvfb \
  novnc \
  websockify \
  dbus \
  ttf-dejavu

echo
echo "📝 写入配置文件 config.env"

cat > config.env <<EOF
# noVNC 配置
DISPLAY_NUM=:0
VNC_PORT=$VNC_PORT
NOVNC_PORT=$NOVNC_PORT
SCREEN_RES=$SCREEN_RES
EOF

chmod +x start.sh

echo
echo "======================================"
echo "✅ 安装完成"
echo "👉 下一步运行： ./start.sh"
echo "🌐 访问地址: http://<你的IP>:$NOVNC_PORT/vnc.html"
echo "======================================"
