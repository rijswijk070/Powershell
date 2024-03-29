If (Get-Module -ListAvailable -Name SQLServer) {Write-Output "SQLServer module already installed" ; Import-Module SQLServer} Else {Install-Module -Name SQLServer -AllowClobber -Force ; Import-Module -Name SQLServer}
Import-Module -Name SQLSERVER -Force
Set-Location SQLServer:\SQL\localhost
Invoke-SQLCMD -Inputfile c:\labfiles.55315\adventureworks_install.sql

Try {
    Import-Module -Name SqlServer -Force
} Catch {
   Write-Output "SQLServer module not installed. Installing..."
   Install-Module -Name SQLServer -AllowClobber -Force
   Import-Module -Name SQLSERVER -Force
}

Set-Location SQLServer:\SQL\localhost
Invoke-SQLCMD -Inputfile c:\labfiles.55315\adventureworks_install.sql



