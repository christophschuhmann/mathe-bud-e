@echo off
setlocal
set "BUDE_EXE=%~dp0dist\Windows\mathe_bud_e.exe"
if exist "%BUDE_EXE%" (
  start "Mathe Bud-E" /D "%~dp0dist\Windows" "%BUDE_EXE%"
  exit /b 0
)
set "BUDE_EXE=%~dp0build\windows\x64\runner\Release\mathe_bud_e.exe"
if exist "%BUDE_EXE%" (
  start "Mathe Bud-E" /D "%~dp0build\windows\x64\runner\Release" "%BUDE_EXE%"
  exit /b 0
)
echo Bitte zuerst tools\Build.ps1 ausfuehren.
pause
