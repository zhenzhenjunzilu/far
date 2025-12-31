#!/bin/bash
set -e

if [ ! -f ./config.env ]; then
  echo "❌ 未找到 config.env，请先运行 ./install.sh"
  exit 1
fi

source ./config.env
export DISPLAY=$DISPLAY_NUM

echo "[1/6] 启动 Xvfb..."
Xvfb $DISPLAY_NUM -screen 0 $SCREEN_RES &

sleep 2

echo "[2/6] 启动 D-Bus..."
dbus-launch --exit-with-session >/tmp/dbus.log 2>&1 &

sleep 1

echo "[3/6] 启动 Fluxbox..."
fluxbox >/tmp/fluxbox.log 2>&1 &

sleep 2

echo "[4/6] 启动 Firefox..."
firefox >/tmp/firefox.log 2>&1 &

sleep 2

echo "[5/6] 启动 VNC..."
x11vnc \
  -display $DISPLAY_NUM \
  -nopw \
  -forever \
  -shared \
  -rfbport $VNC_PORT &

sleep 1

echo "[6/6] 启动 noVNC..."
websockify \
  --web=/usr/share/novnc/ \
  $NOVNC_PORT localhost:$VNC_PORT &

echo
echo "======================================"
echo "✅ noVNC 桌面已启动"
echo "🌐 http://<你的IP>:$NOVNC_PORT/vnc.html"
echo "======================================"
