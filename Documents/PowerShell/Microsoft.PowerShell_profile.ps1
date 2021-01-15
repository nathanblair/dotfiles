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
    $branch = git branch --show-current

    if ($LASTEXITCODE -eq 0) {
        if (Test-Path '.git') {
            Write-Host " $((Get-Item $(Get-Location)).Name)" -ForegroundColor DarkCyan -NoNewLine
        } else {
            Write-Host " $($(Get-Location) -replace [Regex]::Escape($HOME), '~')" -ForegroundColor DarkCyan -NoNewLine
        }
        Write-Host " (" -ForegroundColor Blue -NoNewLine
        Write-Host "$branch" -ForegroundColor DarkMagenta -NoNewLine
        Write-Host ")" -ForegroundColor Blue -NoNewLine
    }
    else {
        Write-Host " $($(Get-Location) -replace [Regex]::Escape($HOME), '~')" -ForegroundColor DarkCyan -NoNewLine
    }

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
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Source token variables
# . ~/repos/personal/keys/tokens.ps1 | Out-Null
