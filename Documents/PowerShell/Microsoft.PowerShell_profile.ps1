# Directory Manipulation
# function ln ($target, $destination) {
#     # Check if path or name is empty and exit if they are
#     New-Item -ItemType SymbolicLink -Path $target -Name $destination
# }

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
function gaa { git add --all }
function gc { git commit }
function gca { git commit --all }
function gcm ($msg) { git commit -m $msg }
function gcam { git commit --all -m $msg }
function gst { git status }
function glg { git log --graph }
function glgs { git log --graph --stat }
function glgp { git log --graph --patch }

function Prompt {
    Write-Host ' ' -NoNewline
    $path = $(Get-Location) -replace [Regex]::Escape($HOME), '~'
    $path = $path -replace '\w{1}:', ''
    $path = $path -replace '\\', '/'
    Write-Host $path -ForegroundColor DarkCyan -NoNewLine
    Write-Host (' >') -ForegroundColor Green -NoNewLine
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
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Source token variables
. ~/repos/personal/keys/tokens.ps1 | Out-Null
