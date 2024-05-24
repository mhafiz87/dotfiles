# Reference:
# 1. https://github.com/ChrisTitusTech/powershell-profile/blob/main/Microsoft.PowerShell_profile.ps1
# 2. https://github.com/johnthebrit/RandomStuff/blob/master/PowerShellStuff/psreadlinedemo.ps1

# New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
# New-PSDrive -PSProvider registry -Root HKEY_USERS -Name HKU
# New-PSDrive -PSProvider registry -Root HKEY_CURRENT_CONFIG -Name HKCC

# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
foreach ($module in @("PSReadLine", "Terminal-Icons", "7Zip4Powershell", "posh-git")) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Scope CurrentUser -Force -SkipPublisherCheck
    }
}

Import-Module PSReadLine
Import-Module Terminal-Icons
Import-Module 7Zip4Powershell
Import-Module posh-git

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command with elevated rights.
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

$versionMinimum = [Version]'7.1.999'
if (($host.name -eq 'ConsoleHost') -and ($PSVersionTable.PSVersion -ge $versionMinimum)) {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}
else {
    Set-PSReadLineOption -PredictionSource History
}
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key Ctrl+Tab -Function TabCompleteNext
Set-PSReadlineKeyHandler -Key Ctrl+Shift+Tab -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

$env:path += ";$env:localappdata\Notepad++"

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Function prompt {
    if ($isAdmin) { "[" + (Get-Location) + "] # " } else { "[" + (Get-Location) + "] $ " }
}
$adminSuffix = if ($isAdmin) { " [ADMIN]" } else { "" }
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Simple function to start a new elevated process. If arguments are supplied then
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
Function admin {
    if ($args.Count -gt 0) {
        $argList = "& '" + $args + "'"
        Start-Process "$psHome\pwsh.exe" -Verb runAs -ArgumentList $argList
    }
    else {
        Start-Process "$psHome\pwsh.exe" -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights.
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

# Useful shortcuts for traversing directories
Function cd... { Set-Location ..\.. }
Function cd.... { Set-Location ..\..\.. }

# Compute file hashes - useful for checking successful downloads
Function md5 { Get-FileHash -Algorithm MD5 $args }
Function sha1 { Get-FileHash -Algorithm SHA1 $args }
Function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
Function n { notepad $args }

Function np { notepad++ $args }

Function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip ).Content }

Function Uptime {
    #Windows Powershell only
    If ($PSVersionTable.PSVersion.Major -eq 5 ) {
        Get-WmiObject win32_operatingsystem | Select-Object @{EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
    }
    Else {
        net statistics workstation | Select-String "since" | foreach-object { $_.ToString().Replace('Statistics since ', '') }
    }
}

Function Reload-Profile { & $profile }

Function Find-File($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

Function nvims {
    <#
    .DESCRIPTION
    Switch NVIM_APPNAME to the given input. If appName is not given, will print current NVIM_APPNAME.

    .PARAMETER appName
    The name of the NVIM_APPNAME to switch to.
    #>
    param(
        [Parameter(Mandatory = $false)][string]$appName
    )
    $apps = "prod", "dev", "lazy", "chad"
    if ($appName -eq "") {
        Write-Output "Current NVIM_APPNAME environment variable: $env:NVIM_APPNAME"
        $counter = 1
        foreach ($item in $apps) {
            $nvimapp = "nvim_$item"
            if (($item -eq "prod" -and $env:NVIM_APPNAME -eq $null) -or ($nvimapp -eq $env:NVIM_APPNAME)) {
                Write-Output("$counter : $item*")
            }
            else {
                Write-Output("$counter : $item")
            }
            $counter++
        }

    }
    elseif ($appName -notin $apps) {
        Write-Output "$appName is not in available Nvim App. Please edit `$PROFILE to add the $appName."
        Return
    }
    elseif ($appName -eq "prod") {
        Write-Output "Changing NVIM_APPNAME environment variable to $null"
        $env:NVIM_APPNAME = $null
    }
    else {
        Write-Output "Changing NVIM_APPNAME environment variable to: nvim_$appName"
        $env:NVIM_APPNAME = "nvim_$appName"
    }
}

Function Add-Env-Variable {
    <#
    .SYNOPSIS
    Add new Windows environment variable.

    .DESCRIPTION
    Add new Windows environment variable. If environment already exist, will append. Else will create new.

    .PARAMETER envName
    The name of the environment variable.

    .PARAMETER userType
    To add environment variable to user or system(machine).

    .PARAMETER newEnv
    The path of the environment variable.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    None.

    .EXAMPLE
    # To append "C:\swig" to system "path" environment variable.
    PS> Add-Env-Variable -envName path -userType machine -newEnv "C:\swig"

    .EXAMPLE
    # To append "C:\vlc" to user "path" environment variable.
    PS> Add-Env-Variable -envName path -userType user -newEnv "C:\vlc"

    .EXAMPLE
    # To create "WORKON_HOME" environment variable.
    PS> Add-Env-Variable -envName "WORKON_HOME" -userType user -newEnv "$env:userprofile:\.virtualenvs"
    #>
    param(
        [Parameter(Mandatory = $true)][string]$envName,
        [Parameter(Mandatory = $true)][ValidateSet("user", "machine")][string]$userType,
        [Parameter(Mandatory = $true)][string]$newEnv
    )
    if ($userType -eq "user") {
        if ([System.Environment]::GetEnvironmentVariable($envname, [System.EnvironmentVariableTarget]::User).Length -eq 0) {
            [System.Environment]::SetEnvironmentVariable($envname, $newEnv, [System.EnvironmentVariableTarget]::User)
        }
        else {
            [System.Environment]::SetEnvironmentVariable($envName, [System.Environment]::GetEnvironmentVariable($envName, [System.EnvironmentVariableTarget]::User) + ";" + $newEnv, [System.EnvironmentVariableTarget]::User)
        }
    }
    elseif ($userType -eq "machine") {
        if ([System.Environment]::GetEnvironmentVariable($envname, [System.EnvironmentVariableTarget]::Machine).Length -eq 0) {
            [System.Environment]::SetEnvironmentVariable($envname, $newEnv, [System.EnvironmentVariableTarget]::Machine)
        }
        else {
            [System.Environment]::SetEnvironmentVariable($envName, [System.Environment]::GetEnvironmentVariable($envName, [System.EnvironmentVariableTarget]::Machine) + ";" + $newEnv, [System.EnvironmentVariableTarget]::Machine)
        }
    }
}

Function Keep-Awake {
    $TimerSeconds = 60 * 3
    $MyShell = New-Object -ComObject Wscript.Shell
    while (1) {
        $MyShell.SendKeys("+{F15}")
        Write-Output("Keeping awake... $(Get-Date)")
        Start-Sleep -Seconds $TimerSeconds
    }
}

oh-my-posh --init --shell pwsh --config "$env:posh_themes_path/powerlevel10k_rainbow.omp.json" | Invoke-Expression