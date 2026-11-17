@echo off
rem ==============================================================
rem  SKANKINSTALLER  ver. 1.0-Alpha
rem  Created By mUxa (u/Motor-Statement-8615)
rem  Launcher - runs SkankInstaller.ps1 (Windows PowerShell 5.1+)
rem ==============================================================
chcp 65001 >nul
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0SkankInstaller.ps1" %*
if errorlevel 1 (
    echo.
    pause
)
