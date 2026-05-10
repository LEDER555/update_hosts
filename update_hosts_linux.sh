#!/bin/bash
# ============================================================
#  update_hosts_linux.sh — Downloads and replaces hosts file
#  Linux only
#  Must be run as root: sudo ./update_hosts_linux.sh
# ============================================================

HOSTS_URL="https://sanya.lol/hosts"
HOSTS_PATH="/etc/hosts"
BACKUP_PATH="/tmp/hosts.bak"
TEMP_FILE="/tmp/hosts_new.txt"

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Please run as root: sudo $0"
    exit 1
fi

echo "[1/4] Creating backup of current hosts file..."
cp "$HOSTS_PATH" "$BACKUP_PATH"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to create backup."
    exit 1
fi
echo "      Backup saved: $BACKUP_PATH"

echo "[2/4] Downloading new hosts file..."
if command -v curl &> /dev/null; then
    curl -fsSL "$HOSTS_URL" -o "$TEMP_FILE"
elif command -v wget &> /dev/null; then
    wget -q "$HOSTS_URL" -O "$TEMP_FILE"
else
    echo "[ERROR] Neither curl nor wget found. Please install one of them."
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to download file. Check the URL and network connection."
    exit 1
fi

echo "[3/4] Replacing hosts file..."
cp "$TEMP_FILE" "$HOSTS_PATH"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to replace hosts file."
    exit 1
fi
rm -f "$TEMP_FILE"

echo "[4/4] Flushing DNS cache..."
if command -v systemd-resolve &> /dev/null; then
    systemd-resolve --flush-caches
elif command -v nscd &> /dev/null; then
    service nscd restart 2>/dev/null
else
    echo "       (DNS flush skipped — no supported DNS service found)"
fi

echo ""
echo "[DONE] Hosts file updated successfully!"
echo "       Backup of old file: $BACKUP_PATH"
