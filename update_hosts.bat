@echo off
:: ============================================================
::  update_hosts.bat — Downloads and replaces Windows hosts file
::  Must be run as Administrator!
:: ============================================================

set "HOSTS_URL=https://sanya.lol/hosts"

set "HOSTS_PATH=%SystemRoot%\System32\drivers\etc\hosts"
set "BACKUP_PATH=%SystemRoot%\System32\drivers\etc\hosts.bak"
set "TEMP_FILE=%TEMP%\hosts_new.txt"

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    pause
    exit /b 1
)

echo [1/4] Creating backup of current hosts file...
copy /Y "%HOSTS_PATH%" "%BACKUP_PATH%" >nul
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create backup.
    pause
    exit /b 1
)
echo        Backup saved: %BACKUP_PATH%

echo [2/4] Downloading new hosts file...
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri '%HOSTS_URL%' -OutFile '%TEMP_FILE%' -UseBasicParsing -ErrorAction Stop; exit 0 } catch { Write-Host $_.Exception.Message; exit 1 }"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to download file. Check the URL and network connection.
    pause
    exit /b 1
)

echo [3/4] Replacing hosts file...
copy /Y "%TEMP_FILE%" "%HOSTS_PATH%" >nul
if %errorlevel% neq 0 (
    echo [ERROR] Failed to replace hosts file. Check file permissions.
    pause
    exit /b 1
)
del "%TEMP_FILE%" >nul 2>&1

echo [4/4] Flushing DNS cache...
ipconfig /flushdns >nul

echo.
echo [DONE] Hosts file updated successfully!
echo        Backup of old file: %BACKUP_PATH%
echo.
pause
