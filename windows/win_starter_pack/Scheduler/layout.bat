start /min "" ssh siikamiika@es.lan -L 9888:localhost:9888 -L 9889:localhost:9889
timeout 2
start "C:\Program Files\AutoHotkey\AutoHotkey.exe" "C:\Users\siikamiika\koodi\scripts\windows\layout.ahk"
cd "C:\Users\siikamiika\koodi\scripts\windows"
start /min "" vfio_hotkeys.bat