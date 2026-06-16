@echo off
title Cache Cleaner Windows - Installer
echo ============================================
echo Cache Cleaner Windows - Installer
echo ============================================
echo.

:: Check PowerShell version
powershell -Command "$PSVersionTable.PSVersion.Major" > temp.txt
set /p PSVersion=<temp.txt
del temp.txt

if %PSVersion% LSS 5 (
    echo [ERROR] PowerShell 5.0 atau lebih tinggi diperlukan
    echo Silakan update PowerShell Anda
    pause
    exit /b
)

echo [INFO] PowerShell version: %PSVersion% - OK
echo.

:: Create shortcut
set SCRIPT_PATH=%~dp0CleanCache.ps1
set SHORTCUT_PATH=%USERPROFILE%\Desktop\Cache Cleaner.lnk

echo [INFO] Membuat shortcut di desktop...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_PATH%'); $Shortcut.TargetPath = 'powershell.exe'; $Shortcut.Arguments = '-ExecutionPolicy Bypass -File ""%SCRIPT_PATH%""'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.IconLocation = '%~dp0app_icon.ico'; $Shortcut.Save()"

echo [SUCCESS] Shortcut dibuat di desktop
echo.
echo ============================================
echo Instalasi Selesai!
echo Klik "Cache Cleaner" di desktop untuk mulai
echo ============================================
pause
