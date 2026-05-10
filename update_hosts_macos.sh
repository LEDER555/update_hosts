#!/bin/bash
# ============================================================
#  update_hosts_macos.sh — Downloads and replaces hosts file
#  macOS only
#  Must be run as root: sudo ./update_hosts_macos.sh
# ============================================================

HOSTS_URL="https://sanya.lol/hosts"
TEMP_FILE="/tmp/hosts_new.txt"
BACKUP_PATH="/tmp/hosts.bak"

# macOS hosts can be at /etc/hosts or /private/etc/hosts
if [ -f "/private/etc/hosts" ]; then
    HOSTS_PATH="/private/etc/hosts"
else
    HOSTS_PATH="/etc/hosts"
fi

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] Please run as root: sudo $0"
    exit 1
fi

echo "[1/4] Hosts file found at: $HOSTS_PATH"
echo "      Creating backup..."
cp "$HOSTS_PATH" "$BACKUP_PATH"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to create backup."
    exit 1
fi
echo "      Backup saved: $BACKUP_PATH"

echo "[2/4] Downloading new hosts file..."
if command -v curl &> /dev/null; then
    curl -fsSL "$HOSTS_URL" -o "$TEMP_FILE"
else
    echo "[ERROR] curl not found."
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
dscacheutil -flushcache
killall -HUP mDNSResponder 2>/dev/null

echo ""
echo "[DONE] Hosts file updated successfully!"
echo "       Backup of old file: $BACKUP_PATH"
