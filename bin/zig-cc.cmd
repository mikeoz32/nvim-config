@echo off
setlocal enabledelayedexpansion
set "args=%*"
set "args=%args:x86_64-pc-windows-msvc=x86_64-windows-gnu%"
set "args=%args:i686-pc-windows-msvc=x86-windows-gnu%"
set "args=%args:aarch64-pc-windows-msvc=aarch64-windows-gnu%"
zig cc %args%
exit /b %errorlevel%
