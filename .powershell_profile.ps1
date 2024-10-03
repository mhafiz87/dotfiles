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
foreach ($module in @("PSReadLine", "Terminal-Icons", "7Zip4Powershell", "posh-git", "PSFzf", "PSTree"))
{
	if (-not (Get-Module -ListAvailable -Name $module))
	{
		Install-Module -Name $module -Scope CurrentUser -Force -SkipPublisherCheck
	}
}

Import-Module PSReadLine
Import-Module Terminal-Icons
Import-Module 7Zip4Powershell
Import-Module posh-git
Import-Module PSFzf
Import-Module PSTree

Set-PSReadLineOption -AddToHistoryHandler {
	param($command)
	if ($command -like ' *')
	{
		return $false
	}
	return $true
} 


$ehst = "$env:appdata\microsoft\windows\powershell\psreadline\consolehost_history.txt"
$hosts = "$env:systemroot\system32\drivers\etc\hosts"

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command with elevated rights.
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

$versionMinimum = [Version]'7.1.999'
if (($host.name -eq 'ConsoleHost') -and ($PSVersionTable.PSVersion -ge $versionMinimum))
{
	Set-PSReadLineOption -PredictionSource HistoryAndPlugin
} else
{
	Set-PSReadLineOption -PredictionSource History
}
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Ctrl+Tab -Function TabCompleteNext
Set-PSReadlineKeyHandler -Key Ctrl+Shift+Tab -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

$env:FZF_DEFAULT_OPTS = "--height 70% --layout=reverse --border"

function Git-Branch-FZF
{
	git checkout $(git branch -a | Select-String -NotMatch "^\*" | fzf | ForEach-Object { Write-Output($_.trim()) })
}

Set-Alias -Name gbf -Value Git-Branch-FZF

# https://www.youtube.com/watch?v=fnMajPIe_uU
Function ff
{
	nvim $(fzf --preview 'bat --style=numbers --color=always  --line-range :500 {}')	 
}

$env:path += ";$env:localappdata\Notepad++"

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Function prompt
{
	if ($isAdmin)
	{ "[" + (Get-Location) + "] # " 
	} else
	{ "[" + (Get-Location) + "] $ " 
	}
}
$adminSuffix = if ($isAdmin)
{ " [ADMIN]" 
} else
{ "" 
}
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Simple function to start a new elevated process. If arguments are supplied then
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
Function admin
{
	if ($args.Count -gt 0)
	{
		$argList = "& '" + $args + "'"
		Start-Process "$psHome\pwsh.exe" -Verb runAs -ArgumentList $argList
	} else
	{
		Start-Process "$psHome\pwsh.exe" -Verb runAs
	}
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights.
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

# Useful shortcuts for traversing directories
Function cd...
{ Set-Location ..\.. 
}
Function cd....
{ Set-Location ..\..\.. 
}

# Compute file hashes - useful for checking successful downloads
Function md5
{ Get-FileHash -Algorithm MD5 $args 
}
Function sha1
{ Get-FileHash -Algorithm SHA1 $args 
}
Function sha256
{ Get-FileHash -Algorithm SHA256 $args 
}

# Quick shortcut to start notepad
Function n
{ notepad $args 
}

Function np
{ notepad++ $args 
}

Function Get-PubIP
{ (Invoke-WebRequest http://ifconfig.me/ip ).Content 
}

Function Uptime
{
	#Windows Powershell only
	If ($PSVersionTable.PSVersion.Major -eq 5 )
	{
		Get-WmiObject win32_operatingsystem | Select-Object @{EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) } } | Format-Table -HideTableHeaders
	} Else
	{
		net statistics workstation | Select-String "since" | foreach-object { $_.ToString().Replace('Statistics since ', '') }
	}
}

Function Reload-Profile
{ & $profile 
}

Function Find-File($name)
{
	Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
		$place_path = $_.directory
		Write-Output "${place_path}\${_}"
	}
}

Function nvims
{
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
	if ($appName -eq "")
	{
		Write-Output "Current NVIM_APPNAME environment variable: $env:NVIM_APPNAME"
		$counter = 1
		foreach ($item in $apps)
		{
			$nvimapp = "nvim_$item"
			if (($item -eq "prod" -and $env:NVIM_APPNAME -eq $null) -or ($nvimapp -eq $env:NVIM_APPNAME))
			{
				Write-Output("$counter : $item*")
			} else
			{
				Write-Output("$counter : $item")
			}
			$counter++
		}

	} elseif ($appName -notin $apps)
	{
		Write-Output "$appName is not in available Nvim App. Please edit `$PROFILE to add the $appName."
		Return
	} elseif ($appName -eq "prod")
	{
		Write-Output "Changing NVIM_APPNAME environment variable to $null"
		$env:NVIM_APPNAME = $null
	} else
	{
		Write-Output "Changing NVIM_APPNAME environment variable to: nvim_$appName"
		$env:NVIM_APPNAME = "nvim_$appName"
	}
}

Function get-github-repo-latest-release
{
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


Function Add-Env-Variable
{
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
	if ($userType -eq "user")
	{
		if ([System.Environment]::GetEnvironmentVariable($envname, [System.EnvironmentVariableTarget]::User).Length -eq 0)
		{
			[System.Environment]::SetEnvironmentVariable($envname, $newEnv, [System.EnvironmentVariableTarget]::User)
		} else
		{
			[System.Environment]::SetEnvironmentVariable($envName, [System.Environment]::GetEnvironmentVariable($envName, [System.EnvironmentVariableTarget]::User) + ";" + $newEnv, [System.EnvironmentVariableTarget]::User)
		}
	} elseif ($userType -eq "machine")
	{
		if ([System.Environment]::GetEnvironmentVariable($envname, [System.EnvironmentVariableTarget]::Machine).Length -eq 0)
		{
			[System.Environment]::SetEnvironmentVariable($envname, $newEnv, [System.EnvironmentVariableTarget]::Machine)
		} else
		{
			[System.Environment]::SetEnvironmentVariable($envName, [System.Environment]::GetEnvironmentVariable($envName, [System.EnvironmentVariableTarget]::Machine) + ";" + $newEnv, [System.EnvironmentVariableTarget]::Machine)
		}
	}
}

Function Keep-Awake
{
	$TimerSeconds = 60 * 3
	$MyShell = New-Object -ComObject Wscript.Shell
	while (1)
	{
		$MyShell.SendKeys("+{F15}")
		Write-Output("Keeping awake... $(Get-Date)")
		Start-Sleep -Seconds $TimerSeconds
	}
}

# https://github.com/chocolatey/choco/blob/stable/src/chocolatey.resources/helpers/functions/Update-SessionEnvironment.ps1
function Update-SessionEnvironment {
<#
.SYNOPSIS
Updates the environment variables of the current powershell session with
any environment variable changes that may have occured during a
Chocolatey package install.

.DESCRIPTION
When Chocolatey installs a package, the package author may add or change
certain environment variables that will affect how the application runs
or how it is accessed. Often, these changes are not visible to the
current PowerShell session. This means the user needs to open a new
PowerShell session before these settings take effect which can render
the installed application nonfunctional until that time.

Use the Update-SessionEnvironment command to refresh the current
PowerShell session with all environment settings possibly performed by
Chocolatey package installs.

.NOTES
This method is also added to the user's PowerShell profile as
`refreshenv`. When called as `refreshenv`, the method will provide
additional output.

Preserves `PSModulePath` as set by the process starting in 0.9.10.

.INPUTS
None

.OUTPUTS
None
#>

  Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

  $refreshEnv = $false
  $invocation = $MyInvocation
  if ($invocation.InvocationName -eq 'refreshenv') {
    $refreshEnv = $true
  }

  if ($refreshEnv) {
    Write-Output 'Refreshing environment variables from the registry for powershell.exe. Please wait...'
  } else {
    Write-Verbose 'Refreshing environment variables from the registry.'
  }

  $userName = $env:USERNAME
  $architecture = $env:PROCESSOR_ARCHITECTURE
  $psModulePath = $env:PSModulePath

  #ordering is important here, $user should override $machine...
  $ScopeList = 'Process', 'Machine'
  if ($userName -notin 'SYSTEM', "${env:COMPUTERNAME}`$") {
    # but only if not running as the SYSTEM/machine in which case user can be ignored.
    $ScopeList += 'User'
  }
  foreach ($Scope in $ScopeList) {
    Get-EnvironmentVariableNames -Scope $Scope |
        ForEach-Object {
          Set-Item "Env:$_" -Value (Get-EnvironmentVariable -Scope $Scope -Name $_)
        }
  }

  #Path gets special treatment b/c it munges the two together
  $paths = 'Machine', 'User' |
    ForEach-Object {
      (Get-EnvironmentVariable -Name 'PATH' -Scope $_) -split ';'
    } |
    Select-Object -Unique
  $Env:PATH = $paths -join ';'

  # PSModulePath is almost always updated by process, so we want to preserve it.
  $env:PSModulePath = $psModulePath

  # reset user and architecture
  if ($userName) { $env:USERNAME = $userName; }
  if ($architecture) { $env:PROCESSOR_ARCHITECTURE = $architecture; }

  if ($refreshEnv) {
    Write-Output 'Finished'
  }
}

Set-Alias refreshenv Update-SessionEnvironment

oh-my-posh --init --shell pwsh --config "$env:userprofile/.config/ohmyposh/zen.toml" | Invoke-Expression
