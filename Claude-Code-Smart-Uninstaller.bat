@echo off
setlocal enabledelayedexpansion
title Claude Code Smart Uninstaller
color 0A

echo.
echo  ==========================================
echo   Claude Code SMART Uninstaller (Windows)
echo  ==========================================
echo.

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] NOT running as Administrator.
    echo  [!] Relaunching with elevated privileges...
    echo.
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo  [OK] Running as Administrator
echo.

:: ─── STEP 1: Find claude executable ───────────────────────────────────────────
echo  [1/6] Locating 'claude' command...
set CLAUDE_PATH=
for /f "delims=" %%i in ('where claude 2^>nul') do (
    set CLAUDE_PATH=%%i
)

if defined CLAUDE_PATH (
    echo       Found: !CLAUDE_PATH!
) else (
    echo       'claude' not in PATH — scanning known locations...
)

:: ─── STEP 2: npm uninstall ────────────────────────────────────────────────────
echo.
echo  [2/6] Trying npm uninstall...
where npm >nul 2>&1
if %errorlevel%==0 (
    npm uninstall -g @anthropic-ai/claude-code >nul 2>&1
    echo       npm uninstall attempted
) else (
    echo       npm not found, skipping
)

:: ─── STEP 3: WinGet uninstall ─────────────────────────────────────────────────
echo.
echo  [3/6] Trying WinGet uninstall...
winget uninstall --id Anthropic.ClaudeCode --silent >nul 2>&1
echo       WinGet attempted

:: ─── STEP 4: Delete known install locations ───────────────────────────────────
echo.
echo  [4/6] Removing known install folders...

set LOCATIONS[0]=%LOCALAPPDATA%\Programs\claude-code
set LOCATIONS[1]=%LOCALAPPDATA%\Programs\Claude Code
set LOCATIONS[2]=%PROGRAMFILES%\claude-code
set LOCATIONS[3]=%PROGRAMFILES%\Claude Code
set LOCATIONS[4]=%APPDATA%\npm\node_modules\@anthropic-ai\claude-code
set LOCATIONS[5]=%APPDATA%\npm

for /L %%n in (0,1,5) do (
    if exist "!LOCATIONS[%%n]!" (
        echo       Deleting: !LOCATIONS[%%n]!
        rmdir /s /q "!LOCATIONS[%%n]!" >nul 2>&1
    )
)

:: Delete stray claude.cmd / claude files in npm bin
if exist "%APPDATA%\npm\claude.cmd" (
    del /f /q "%APPDATA%\npm\claude.cmd" >nul 2>&1
    echo       Deleted: %APPDATA%\npm\claude.cmd
)
if exist "%APPDATA%\npm\claude" (
    del /f /q "%APPDATA%\npm\claude" >nul 2>&1
    echo       Deleted: %APPDATA%\npm\claude
)

:: Delete the found path directly
if defined CLAUDE_PATH (
    del /f /q "!CLAUDE_PATH!" >nul 2>&1
    echo       Deleted: !CLAUDE_PATH!
)

:: ─── STEP 5: Remove config/data folders ──────────────────────────────────────
echo.
echo  [5/6] Removing config and data folders...

if exist "%USERPROFILE%\.claude" (
    rmdir /s /q "%USERPROFILE%\.claude" >nul 2>&1
    echo       Deleted: %USERPROFILE%\.claude
) else (
    echo       Config folder already gone
)

if exist "%APPDATA%\claude-code" (
    rmdir /s /q "%APPDATA%\claude-code" >nul 2>&1
    echo       Deleted: %APPDATA%\claude-code
)

:: ─── STEP 6: Final verification ──────────────────────────────────────────────
echo.
echo  [6/6] Verifying...
where claude >nul 2>&1
if %errorlevel%==0 (
    for /f "delims=" %%i in ('where claude 2^>nul') do (
        echo       [!] Still found at: %%i
        echo       Attempting final force delete...
        del /f /q "%%i" >nul 2>&1
    )
    where claude >nul 2>&1
    if %errorlevel%==0 (
        echo.
        echo  [!!] Could not fully remove. File may be in use.
        echo       Try restarting PC and running this again.
    ) else (
        echo       SUCCESS after force delete!
    )
) else (
    echo       'claude' command not found.
    echo.
    echo  ==========================================
    echo   UNINSTALL COMPLETE! Claude Code removed.
    echo  ==========================================
)

echo.
pause
endlocal
