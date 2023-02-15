# install AHK
winget install Lexikos.AutoHotkey

# TODO layout AHK

# persist key rate
$obj = New-Object -comObject WScript.Shell
$shortcut = $obj.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\keyrate.lnk")
$shortcut.TargetPath = "python"
$shortcut.Arguments = (Get-Item .).FullName + "\keyrate.py 300 25"
$shortcut.Save()