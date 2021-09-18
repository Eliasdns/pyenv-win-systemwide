if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$([string]$Args)`"" -Verb RunAs ; exit }

$context = [System.EnvironmentVariableTarget]::Machine  # To modify the Machine Environment Variables
# $context = [System.EnvironmentVariableTarget]::User  # To modify the User Environment Variables
$pyenv_basedir = $PSScriptRoot

Write-Host "[*] Cloning 'pyenv-win/pyenv-win'..."
git clone https://github.com/pyenv-win/pyenv-win.git "$pyenv_basedir/.pyenv"


Write-Host "`n[*] Setting-up Environment Variables..."
[System.Environment]::SetEnvironmentVariable('PYENV', $pyenv_basedir + "\.pyenv\pyenv-win\", $context)
[System.Environment]::SetEnvironmentVariable('PYENV_HOME', $pyenv_basedir + "\.pyenv\pyenv-win\", $context)

$pyenv_paths = @(
    ($pyenv_basedir + "\.pyenv\pyenv-win\bin"),
    ($pyenv_basedir + "\.pyenv\pyenv-win\shims")
)
$new_path = ([System.Environment]::GetEnvironmentVariable('Path', $context) -split ';') | ?{ $_ -notin $pyenv_paths }
$new_path = ($pyenv_paths + $new_path) -join ';'
[System.Environment]::SetEnvironmentVariable('Path', $new_path, $context)


Write-Host ""
cmd /c 'pause>nul | echo [*] End! Press any key to Exit...'
# !!! Don't forget run 'pyenv rehash' after install a version of the Python !!!
