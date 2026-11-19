@echo off
setlocal EnableExtensions
chcp 65001 >nul
pushd "%~dp0"
set "SOLUTION=%~dp0SmzdmRemind.sln"
set "MSBUILD="
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"

if exist "%VSWHERE%" (
  for /f "usebackq delims=" %%I in (`"%VSWHERE%" -latest -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do (
    if not defined MSBUILD set "MSBUILD=%%I"
  )
)
if not defined MSBUILD (
  for /f "delims=" %%I in ('where msbuild 2^>nul') do if not defined MSBUILD set "MSBUILD=%%I"
)
if not defined MSBUILD (
  echo.
  echo 未检测到 Visual Studio C++ 编译工具。
  echo 电脑需要安装 Visual Studio 2022，并勾选“使用 C++ 的桌面开发”和 Windows 10 SDK。
  echo.
  echo 也可以使用源码包内 .github\workflows\build-windows.yml 的 GitHub 云端编译方式。
  echo 正在打开 Visual Studio C++ 构建工具下载页面……
  start "" "https://visualstudio.microsoft.com/visual-cpp-build-tools/"
  pause
  popd
  exit /b 1
)

echo 正在编译 SmzdmRemind（Release x64）……
"%MSBUILD%" "%SOLUTION%" /m /t:Build /p:Configuration=Release /p:Platform=x64 /p:WindowsTargetPlatformVersion=10.0 /v:minimal
if errorlevel 1 goto BUILD_FAILED

set "OUT=%~dp0编译完成"
if not exist "%OUT%" mkdir "%OUT%"
set "APP="
set "DLL="
for /r "%~dp0" %%F in (SmzdmRemind.exe) do if not defined APP set "APP=%%F"
for /r "%~dp0" %%F in (WinToast.dll) do if not defined DLL set "DLL=%%F"
if not defined APP (
  echo 编译命令完成，但没有找到 SmzdmRemind.exe。
  goto BUILD_FAILED
)
if not defined DLL (
  echo 编译命令完成，但没有找到 WinToast.dll。
  goto BUILD_FAILED
)
copy /y "%APP%" "%OUT%\SmzdmRemind.exe" >nul
copy /y "%DLL%" "%OUT%\WinToast.dll" >nul
(
  echo 请将 SmzdmRemind.exe 和 WinToast.dll 保持在同一文件夹中。
  echo 双击 SmzdmRemind.exe 启动程序。
) > "%OUT%\使用说明.txt"
echo.
echo 编译成功！成品已放在：
echo %OUT%
start "" "%OUT%"
pause
popd
exit /b 0

:BUILD_FAILED
echo.
echo 编译没有成功。请把上方完整错误信息截图发给我，我继续修复。
pause
popd
exit /b 1
