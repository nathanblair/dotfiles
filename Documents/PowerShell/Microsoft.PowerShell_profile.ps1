# ln-like behavior
# function ln ($target, $destination) {
#     New-Item -ItemType SymbolicLink -Path $target -Name $destination
# }

# env-like behavior
function env { Get-ChildItem env: }

# touch-like behavior
function touch ($item) { New-Item $item }

# which-like behavior
function which ($command) { Get-Command $command }

# File listing
# Some variation of Get-ChildItem
function ll ($dir) { Get-ChildItem -Path $dir }
function l ($dir) { Get-ChildItem -Name -Path $dir }
function la ($dir) { Get-ChildItem -Name -Force -Path $dir }
function lla ($dir) { Get-ChildItem -Force -Path $dir }

# Git function commands
Remove-Item Alias:gc -Force
Remove-Item Alias:gcm -Force
Remove-Item Alias:gl -Force
function gd { git diff }
function ga { git add }
function gb ($options) { git branch $options }
function gba { git branch -a }
function gaa { git add --all }
function gc { git commit }
function gca { git commit --all }
function gcm ($msg) { git commit -m $msg }
function gcam ($msg) { git commit --all -m $msg }
function gfp { git fetch --prune }
function g { git status }
function glg { git log --graph }
function glgs { git log --graph --stat }
function glgp { git log --graph --patch }
function gs ($branch) { git switch $branch }
function gsc ($branch) { git switch -c $branch }
function gpush ($arguments) { git push $arguments }
function gpull { git pull }

# Docker function commands
function disa { docker images -a }
function dcrit ($arguments) { docker run --rm -it $arguments }

# Terraform alias
Set-Alias -Name tf -Value terraform

function Prompt {
    $last_exit_code = 0
    if (Test-Path variable:global:LASTEXITCODE) {
        $last_exit_code = $LASTEXITCODE
    }

    $branch = git branch --show-current

    if ($LASTEXITCODE -eq 0) {
        $formatted_root_path = $(git rev-parse --show-toplevel) -replace '/', '\'
        Write-Host $(
            $(Get-Location) -replace [Regex]::Escape($formatted_root_path),
            $(Get-Item $formatted_root_path).Name
        ) -ForegroundColor Cyan -NoNewline
        Write-Host " (" -ForegroundColor Blue -NoNewline
        Write-Host "$branch" -ForegroundColor Magenta -NoNewline
        Write-Host ")" -ForegroundColor Blue -NoNewline
    }
    else {
        Write-Host $(
            $(Get-Location) -replace [Regex]::Escape($HOME)
        ), '~' -ForegroundColor DarkCyan -NoNewline
    }

    if ($last_exit_code -ne 0) {
        Write-Host " ($last_exit_code)" -ForegroundColor Blue -NoNewline
        Write-Host (' >') -ForegroundColor Red -NoNewline
    }
    else {
        Write-Host (' >') -ForegroundColor Green -NoNewline
    }

    $last_command = Get-History -Count 1
    $right_message = ($last_command.EndExecutionTime - $last_command.StartExecutionTime).Seconds
    $extra_character_length = 2

    $window_host = $(Get-Host)
    $original_position = $window_host.UI.RawUI.CursorPosition
    $new_position = $original_position

    $buffer_size = $window_host.UI.RawUI.BufferSize
    $new_position.X = $buffer_size.Width - ("${right_message}".Length + $extra_character_length)

    $window_host.UI.RawUI.CursorPosition = $new_position
    Write-Host "[" -ForegroundColor Blue -NoNewline
    Write-Host $right_message -ForegroundColor DarkGray -NoNewline
    Write-Host "]" -ForegroundColor Blue -NoNewline
    $window_host.UI.RawUI.CursorPosition = $original_position

    $LASTEXITCODE = $last_exit_code
    return " "
}

$PSReadLineOptions = @{
    BellStyle                     = 'Visual'
    HistoryNoDuplicates           = $true
    HistorySaveStyle              = 'SaveNothing'
    HistorySearchCursorMovesToEnd = $true
    PromptText                    = ' > '
}

Set-PSReadLineOption @PSReadLineOptions

# Key bindings
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Pathing stuff
$env:PATH = "$env:HOMEPATH/.local/bin; $env:PATH"

# Source token variables
. ~/repos/personal/keys/tokens.ps1 | Out-Null
if (-Not (Test-Path env:PIPENV_VENV_IN_PROJECT)) {
    New-Item -Name PIPENV_VENV_IN_PROJECT -Path env: -ItemType Variable -Value 1 | Out-Null
}

# Import-Module posh-git
