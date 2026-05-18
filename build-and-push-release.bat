@echo off
setlocal EnableExtensions
chcp 65001 >nul 2>&1

set "RELEASE_DIR=%~dp0"
set "APP_DIR=%RELEASE_DIR%..\v-claw-app"

if "%~1"=="" (
  echo Usage: build-and-push-release.bat VERSION [extra options]
  echo.
  echo Examples:
  echo   build-and-push-release.bat 1.0.0 --latest=false
  echo   build-and-push-release.bat 1.0.1 --latest=true
  echo   build-and-push-release.bat 1.0.1 --no-build --dry-run
  exit /b 1
)

if not exist "%APP_DIR%\scripts\build-and-publish-win-release.js" (
  echo [FAIL] Cannot find app release publisher:
  echo   %APP_DIR%\scripts\build-and-publish-win-release.js
  exit /b 1
)

pushd "%APP_DIR%" >nul
node scripts\build-and-publish-win-release.js %*
set "EXIT_CODE=%ERRORLEVEL%"
popd >nul

exit /b %EXIT_CODE%
