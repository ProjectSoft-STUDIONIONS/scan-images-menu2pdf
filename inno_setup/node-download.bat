@echo off
setlocal EnableExtensions

rem ==================================================
rem  node-download.bat
rem  Downloads latest Node.js LTS installer (MSI, x64)
rem  and updates version in Inno Setup script
rem ==================================================

rem Get latest LTS version from official index.json
for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "(Invoke-RestMethod 'https://nodejs.org/dist/index.json').Where{ $_.lts }[0].version"`) do set "VERSION=%%A"

if not defined VERSION (
    echo [ERROR] Could not fetch version list. Check your internet connection.
    exit /b 1
)

set "URL=https://nodejs.org/dist/%VERSION%/node-%VERSION%-x64.msi"
set "OUTFILE=node-x64.msi"

echo Version : %VERSION% (LTS)
echo File    : %OUTFILE%
echo URL     : %URL%
echo.

echo Downloading...
curl -L --fail -o "%OUTFILE%" "%URL%"
if errorlevel 1 (
    echo [ERROR] Download failed.
    echo Check available files: https://nodejs.org/dist/%VERSION%/
    exit /b 1
)

echo Done: %CD%\%OUTFILE%
echo.

rem ==================================================
rem  Update #define NodeVersion in Inno Setup script
rem ==================================================
set "ISSFILE=%~dp0ConvertMenu2pdf_setup.iss"

if not exist "%ISSFILE%" (
    echo [ERROR] File not found: %ISSFILE%
    exit /b 1
)

copy /y "%ISSFILE%" "%ISSFILE%.bak" >nul

powershell -NoProfile -Command "$q = [char]34; $c = Get-Content -Raw '%ISSFILE%'; $c = $c -replace '(#define\s+NodeVersion\s*=?\s*)\x22[^\x22]*\x22', ('$1' + $q + '%VERSION%' + $q); Set-Content -Path '%ISSFILE%' -Value $c -Encoding Default"
if errorlevel 1 (
    echo [ERROR] Failed to update %ISSFILE%
    exit /b 1
)

echo Updated %ISSFILE%:
powershell -NoProfile -Command "Select-String -Path '%ISSFILE%' -Pattern 'NodeVersion' | ForEach-Object { $_.Line }"

exit /b 0
