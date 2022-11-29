reg import C:\Classfiles\DC\ie.reg
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\ServerManager' -name "DoNotOpenServerManagerAtLogon" -Value 1 -Confirm:$False

#   Configure Windows Explorer Settings
$VarWindowsExplorer = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $VarWindowsExplorer AlwaysShowMenus 1 -Force
Set-ItemProperty $VarWindowsExplorer FolderContentsInfoTip 1 -Force
Set-ItemProperty $VarWindowsExplorer Hidden 1 -Force
Set-ItemProperty $VarWindowsExplorer HideDrivesWithNoMedia 0 -Force
Set-ItemProperty $VarWindowsExplorer HideFileExt 0 -Force
Set-ItemProperty $VarWindowsExplorer IconsOnly 0 -Force
Set-ItemProperty $VarWindowsExplorer ShowSuperHidden 0 -Force
Set-ItemProperty $VarWindowsExplorer ShowStatusBar 1 -Force

#   Disable IE ESC
$VarAdministratorKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$VarUserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $VarAdministratorKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $VarUserKey -Name "IsInstalled" -Value 0

#   Configure Desktop Settings
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$shell = New-Object -ComObject WScript.Shell
$Location = [System.Environment]::GetFolderPath('Desktop')
$Computer = $shell.CreateShortcut("$Location\ $env:ComputerName.lnk")
$Computer.TargetPath = "Explorer.exe"
$Computer.IconLocation = "imageres.dll,104"
$Computer.HotKey = "CTRL+ALT+E"
$Computer.Save()
$PowerShell = $shell.CreateShortcut("$Location\ PowerShell.lnk")
$PowerShell.TargetPath = "PowerShell.exe"
$PowerShell.IconLocation = "PowerShell.exe"
$PowerShell.HotKey = "CTRL+ALT+P"
$PowerShell.Save()
$PowerShell_ISE = $shell.CreateShortcut("$Location\ PowerShell_ISE.lnk")
$PowerShell_ISE.TargetPath = "PowerShell_ise.exe"
$PowerShell_ISE.IconLocation = "powershell_ise.exe"
$PowerShell_ISE.HotKey = "CTRL+ALT+I"
$PowerShell_ISE.Save()
$CMD = $shell.CreateShortcut("$Location\Command Prompt.lnk")
$CMD.TargetPath = "cmd.exe"
$CMD.IconLocation = "cmd.exe"
$CMD.HotKey = "CTRL+ALT+C"
$CMD.Save()
$CMD = $shell.CreateShortcut("$Location\Internet Explorer.lnk")
$CMD.TargetPath = "C:\Program Files\Internet Explorer\iexplore.exe"
$CMD.IconLocation = "C:\Program Files\Internet Explorer\iexplore.exe"
$CMD.HotKey = "CTRL+ALT+W"
$CMD.Save()
$CMD = $shell.CreateShortcut("$Location\SQL Server Management Studio.lnk")
$CMD.TargetPath = "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe"
$CMD.IconLocation = "C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\Ssms.exe"
$CMD.HotKey = "CTRL+ALT+S"
$CMD.Save()

