#!/bin/bash

# export executables
../godot/bin/godot.linuxbsd.editor.x86_64 --export-debug "Windows Desktop" ../DeepSpaceImmersion.exe
../godot/bin/godot.linuxbsd.editor.x86_64 --export-debug "Linux/X11" ../DeepSpaceImmersion.x86_64

# replace Windows icon
../godot/bin/godot.linuxbsd.editor.x86_64 -s production/ReplaceIcon.gd  image/icon.ico ../DeepSpaceImmersion.exe

# create compressed archives
7z u ../DeepSpaceImmersionWindows.7z ../DeepSpaceImmersion.exe
7z u ../DeepSpaceImmersionLinux.7z ../DeepSpaceImmersion.x86_64 ../DeepSpaceImmersion.sh

