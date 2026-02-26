# Reference:
# 1. https://github.com/ChrisTitusTech/powershell-profile/blob/main/Microsoft.PowerShell_profile.ps1
# 2. https://github.com/johnthebrit/RandomStuff/blob/master/PowerShellStuff/psreadlinedemo.ps1

# New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
# New-PSDrive -PSProvider registry -Root HKEY_USERS -Name HKU
# New-PSDrive -PSProvider registry -Root HKEY_CURRENT_CONFIG -Name HKCC

$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
# foreach ($module in @("PSReadLine", "Terminal-Icons", "7Zip4Powershell", "posh-git", "PSFzf", "PSTree", "ps-color-scripts")) {
foreach ($module in @("PSReadLine", "Terminal-Icons", "7Zip4Powershell", "PSFzf", "PSTree", "Fonts", "ps-color-scripts", "PSReadExif")) {
    Write-Host "Checking for module: $module"
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Install-PSResource -Name $module -Scope CurrentUser -Reinstall -TrustRepository
    }
    Write-Host "`e[A`r`e[K`e[A"
}

Import-Module Fonts
Import-Module PSReadLine
Import-Module Terminal-Icons
Import-Module 7Zip4Powershell
# Import-Module posh-git
Import-Module PSFzf
Import-Module PSTree
# Import-Module ps-color-scripts
Import-Module PSReadExif

# Set-Alias -Name colorscript -Value Show-ColorScript

Set-PSReadLineOption -AddToHistoryHandler {
    param($command)
    if ($command -like ' *') {
        return $false
    }
    return $true
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command with elevated rights.
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

Set-Alias -Name whereis -Value where.exe

$versionMinimum = [Version]'7.1.999'
if (($host.name -eq 'ConsoleHost') -and ($PSVersionTable.PSVersion -ge $versionMinimum)) {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}
else {
    Set-PSReadLineOption -PredictionSource History
}
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Ctrl+Tab -Function TabCompleteNext
Set-PSReadlineKeyHandler -Key Ctrl+Shift+Tab -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

$env:FZF_DEFAULT_OPTS = "--height ~100% --layout reverse --border"
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -TabExpansion
# example command - use $Location with a different command:
$commandOverride = [ScriptBlock] { param($Location) Write-Host $Location }
# pass your override to PSFzf:
Set-PsFzfOption -AltCCommand $commandOverride

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = ‘stop’
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host “$command does not exist”; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
} #end function test-CommandExists

# https://stackoverflow.com/questions/2858484/creating-aliases-in-powershell-for-git-commands
function Git-Branch-FZF {
    # git checkout $(git branch -a | Select-String -NotMatch "^\*" | fzf --prompt=" Git Branch Selector" | ForEach-Object { Write-Output($_.trim()) })
    git checkout $(git branch | Select-String -NotMatch "^\*" | fzf --prompt=" Git Branch Selector" | ForEach-Object { Write-Output($_.trim()) })
}

function Get-GitStatus { & git status --short --branch --show-stash $args }

Set-Alias -Name gbf -Value Git-Branch-FZF
Set-Alias -Name gs -Value Get-GitStatus

# https://www.youtube.com/watch?v=fnMajPIe_uU
Function ff {
    nvim $(fzf --preview 'bat --style=numbers --color=always  --line-range :500 {}')
}

$env:path += ";$env:localappdata\Notepad++"

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Function prompt {
    if ($isAdmin) {
        "[" + (Get-Location) + "] # "
    }
    else {
        "[" + (Get-Location) + "] $ "
    }
}
$adminSuffix = if ($isAdmin) {
    " [ADMIN]"
}
else {
    ""
}
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
Function cd... {
    Set-Location ..\..
}
Function cd.... {
    Set-Location ..\..\..
}

# Compute file hashes - useful for checking successful downloads
Function md5 {
    Get-FileHash -Algorithm MD5 $args
}
Function sha1 {
    Get-FileHash -Algorithm SHA1 $args
}
Function sha256 {
    Get-FileHash -Algorithm SHA256 $args
}

# Quick shortcut to start notepad
Function n {
    notepad $args
}

Function np {
    notepad++ $args
}

Function Get-PubIP {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

Function Uptime {
    #Windows Powershell only
    If ($PSVersionTable.PSVersion.Major -eq 5 ) {
        Get-WmiObject win32_operatingsystem | Select-Object @{EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
    }
    Else {
        net statistics workstation | Select-String "since" | foreach-object { $_.ToString().Replace('Statistics since ', '') }
    }
}

Function Reload-Profile {
    & $profile
}

Function Find-File($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}

Function Nvim-Selector {
    $apps = "prod", "dev", "min", "lazy"
    $index = 0
    foreach ($currentItemName in $apps) {
        if ("nvim-$currentItemName" -eq $env:NVIM_APPNAME) {
            $apps[$index] = $currentItemName + "*"
            break
        }
        $index++
        if ($index -eq $apps.Length) {
            $apps[0] = $apps[0] + "*"
        }
    }
    $nvim_app = $(ForEach-Object { Write-Output($apps) } | fzf --prompt=" NVIM Selector" --height ~50% --border --exit-0)
    if ($null -eq $nvim_app) {
        return
    }
    $nvim_app = $nvim_app.Replace("*", "")
    if ($nvim_app -ne "prod") {
        $env:NVIM_APPNAME = "nvim-" + $nvim_app
    }
    else {
        $env:NVIM_APPNAME = $null
    }
}
# https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlinekeyhandler?view=powershell-7.4
# https://github.com/kelleyma49/PSFzf/blob/3f31db0367a4865378cc9f667dd3f679d2590c6f/PSFzf.Base.ps1#L883
Set-PSReadLineKeyHandler -Chord Ctrl+Shift+n -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('Nvim-Selector')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
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

Function get-github-repo-latest-release {
    param(
        [Parameter(Mandatory = $true)][string]$repo
    )
    $url = "https://github.com/" + $repo + "/releases/latest"
    $request = [System.Net.WebRequest]::Create($url)
    $response = $request.GetResponse()
    $realTagUrl = $response.ResponseUri.OriginalString
    $version = $realTagUrl.split('/')[-1].Trim('v')
    return $version
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

# https://github.com/chocolatey/choco/blob/stable/src/chocolatey.resources/helpers/functions/Update-SessionEnvironment.ps1
function Update-SessionEnvironment {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "User") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "Machine")
}

Function Update-PowerShell {
    Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI -Quiet"
}

# https://gist.github.com/Nora-Ballard/11240204
function Set-WindowState {
    param(
        [Parameter()]
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
            'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
            'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        [Alias('Style')]
        [String] $State = 'SHOW',

        [Parameter(ValueFromPipelineByPropertyname = 'True')]
        [System.IntPtr] $MainWindowHandle = (Get-Process -id $pid).MainWindowHandle,

        [Parameter()]
        [switch] $PassThru

    )
    BEGIN {
        Set-Alias -Name 'Set-WindowStyle' -Value 'Set-WindowState'

        $WindowStates = @{
            'FORCEMINIMIZE'   = 11
            'HIDE'            = 0
            'MAXIMIZE'        = 3
            'MINIMIZE'        = 6
            'RESTORE'         = 9
            'SHOW'            = 5
            'SHOWDEFAULT'     = 10
            'SHOWMINIMIZED'   = 2
            'SHOWMINNOACTIVE' = 7
            'SHOWNA'          = 8
            'SHOWNOACTIVATE'  = 4
            'SHOWNORMAL'      = 1
        }

        $Win32ShowWindowAsync = Add-Type -memberDefinition @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

    }
    PROCESS {
        $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$State]) | Out-Null
        Write-Verbose ("Set Window State on '{0}' to '{1}' " -f $MainWindowHandle, $State)

        if ($PassThru) {
            Write-Output $MainWindowHandle
        }

    }
    END {
    }

}

function Start-FileDownload {
    <#
    .SYNOPSIS
        Downloads a file using BITS transfer with progress display.
    
    .DESCRIPTION
        Downloads a file from a URL to a specified path using Start-BitsTransfer
        with asynchronous transfer and progress monitoring.
    
    .PARAMETER DownloadUrl
        The URL of the file to download.
    
    .PARAMETER OutputPath
        The full path where the file will be saved.
    
    .EXAMPLE
        Start-FileDownload -DownloadUrl "https://aka.ms/vs/17/release/vs_community.exe" -OutputPath "C:\Downloads\vs_community.exe"
    
    .EXAMPLE
        Start-FileDownload "https://aka.ms/vs/17/release/vs_community.exe" "$env:USERPROFILE\Downloads\vs_community.exe"
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadUrl,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath
    )

    begin {
        # Extract filename for display
        $fileName = Split-Path -Path $OutputPath -Leaf
        
        # Ensure output directory exists
        $outputDir = Split-Path -Path $OutputPath -Parent
        if (-not (Test-Path -Path $outputDir)) {
            New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
        }
    }

    process {
        try {
            Write-Host "Starting download: $fileName" -ForegroundColor Cyan
            Write-Host "Source: $DownloadUrl" -ForegroundColor Gray
            Write-Host "Destination: $OutputPath" -ForegroundColor Gray
            
            # Start async transfer
            $bitsJob = Start-BitsTransfer -Source $DownloadUrl -Destination $OutputPath -Asynchronous -DisplayName $fileName

            # Monitor progress
            while ($bitsJob.JobState -eq "Transferring" -or $bitsJob.JobState -eq "Connecting") {
                if ($bitsJob.BytesTotal -gt 0) {
                    $percent = [math]::Round(($bitsJob.BytesTransferred / $bitsJob.BytesTotal) * 100, 2)
                    $mbTransferred = [math]::Round($bitsJob.BytesTransferred / 1MB, 2)
                    $mbTotal = [math]::Round($bitsJob.BytesTotal / 1MB, 2)
                    Write-Progress -Activity "Downloading $fileName" -Status "$mbTransferred MB / $mbTotal MB ($percent%)" -PercentComplete $percent
                }
                else {
                    Write-Progress -Activity "Downloading $fileName" -Status "Connecting..."
                }
                Start-Sleep -Milliseconds 500
            }

            # Handle completion
            if ($bitsJob.JobState -eq "Transferred") {
                Complete-BitsTransfer -BitsJob $bitsJob
                Write-Host "`nDownload completed successfully: $OutputPath" -ForegroundColor Green
                return $true
            }
            else {
                Write-Host "`nDownload failed with state: $($bitsJob.JobState)" -ForegroundColor Red
                Remove-BitsTransfer -BitsJob $bitsJob -ErrorAction SilentlyContinue
                return $false
            }
        }
        catch {
            Write-Host "`nError during download: $_" -ForegroundColor Red
            if ($bitsJob) {
                Remove-BitsTransfer -BitsJob $bitsJob -ErrorAction SilentlyContinue
            }
            return $false
        }
        finally {
            Write-Progress -Activity "Downloading $fileName" -Completed
        }
    }
}

# https://stackoverflow.com/questions/65932454/how-to-launch-teams-exe-with-powershell
# https://stackoverflow.com/a/78493765
# https://stackoverflow.com/questions/74147128/how-do-i-send-keys-to-an-active-window-in-powershell
# https://stackoverflow.com/a/19825078
Function Set-Teams-Status {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("available", "away", "offline", "busy")][string]$Status
    )
    $ps = Start-Process -PassThru -FilePath "$env:localappdata\Microsoft\WindowsApps\ms-teams.exe" -WindowStyle Normal
    $wshell = New-Object -ComObject wscript.shell
    Start-Sleep 1
    $wshell.SendKeys('^{e}')
    Start-Sleep 1.00
    $wshell.SendKeys("/$Status")
    Start-Sleep 1.00
    $wshell.SendKeys('{ENTER}')
    Start-Sleep 1.00
    $wshell.SendKeys('%{TAB}')
}
Set-Alias sts Set-Teams-Status

$ehst = "$env:appdata\microsoft\windows\powershell\psreadline\consolehost_history.txt"
$hosts = "$env:systemroot\system32\drivers\etc\hosts"

Set-Alias refreshenv Update-SessionEnvironment
if (Test-CommandExists oh-my-posh) { oh-my-posh --init --shell pwsh --config "$env:userprofile/.config/ohmyposh/zen.toml" | Invoke-Expression }
if (Test-CommandExists uv) { (& uv generate-shell-completion powershell) | Out-String | Invoke-Expression }
#if (Test-CommandExists fastfetch) { fastfetch }
refreshenv

