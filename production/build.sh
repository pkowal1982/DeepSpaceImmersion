#!/bin/bash

# export executables
../godot.linuxbsd.tools.64 --export "Windows Desktop" ../DeepSpaceImmersion.exe
../godot.linuxbsd.tools.64 --export "Linux/X11" ../DeepSpaceImmersion.x86_64

# change windows icon
../godot.linuxbsd.tools.64 -s production/ReplaceIcon.gd image/icon.ico ../DeepSpaceImmersion.exe

# create compressed archives
7z u ../DeepSpaceImmersionWindows.7z ../DeepSpaceImmersion.exe
7z u ../DeepSpaceImmersionLinux.7z ../DeepSpaceImmersion.x86_64

