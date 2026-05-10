# update_hosts
Bypass regional blocks in Russia. 

Get access to AI (Claude, ChatGPT, Gemini), Spotify, Notion and etc. 

Taken from [dns.geohide.ru:8443](https://dns.geohide.ru:8443/). 

> ⚠️ **Run as administrator/root.** The script replaces `/etc/hosts` and flushes DNS cache. A backup is saved automatically before any changes.

## Fast setup (One-Liner)

Copy the command and paste it into the terminal :


**Windows** (PowerShell as administrator):
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/LEDER555/update_hosts/refs/heads/main/update_hosts.bat" -OutFile "$env:TEMP\update_hosts.bat"; Start-Process "$env:TEMP\update_hosts.bat" -Verb RunAs
```

**Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/LEDER555/update_hosts/refs/heads/main/update_hosts_linux.sh | sudo bash
```

**macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/LEDER555/update_hosts/refs/heads/main/update_hosts_macos.sh | sudo bash
```

## Restore backup
 
**Windows:**
```powershell
copy "$env:SystemRoot\System32\drivers\etc\hosts.bak" "$env:SystemRoot\System32\drivers\etc\hosts"
```
 
**Linux / macOS:**
```bash
sudo cp /tmp/hosts.bak /etc/hosts
```

