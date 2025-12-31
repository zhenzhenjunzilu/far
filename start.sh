#!/bin/sh

set -e

if [ ! -f ./config.env ]; then
  echo "❌ 未找到 config.env，请先运行 ./install.sh"
  exit 1
fi

. ./config.env

export DISPLAY=$DISPLAY_NUM

echo "[1/6] 启动 Xvfb..."
Xvfb $DISPLAY_NUM -screen 0 $SCREEN_RES >/tmp/xvfb.log 2>&1 &

sleep 2

echo "[2/6] 启动 D-Bus..."
dbus-daemon --system >/tmp/dbus.log 2>&1 &

sleep 1

echo "[3/6] 启动 Fluxbox..."
fluxbox >/tmp/fluxbox.log 2>&1 &

sleep 2

echo "[4/6] 启动 Firefox..."
firefox >/tmp/firefox.log 2>&1 &

sleep 2

echo "[5/6] 启动 VNC (端口 $VNC_PORT)..."
x11vnc \
  -display $DISPLAY_NUM \
  -nopw \
  -forever \
  -shared \
  -rfbport $VNC_PORT \
  >/tmp/x11vnc.log 2>&1 &

sleep 1

echo "[6/6] 启动 noVNC (端口 $NOVNC_PORT)..."
websockify \
  --web=/usr/share/novnc/ \
  $NOVNC_PORT localhost:$VNC_PORT \
  >/tmp/novnc.log 2>&1 &

echo
echo "======================================"
echo "✅ noVNC 桌面已启动"
echo "🌐 访问地址:"
echo "   http://<你的IP>:$NOVNC_PORT/vnc.html"
echo "📺 分辨率: $SCREEN_RES"
echo "======================================"
