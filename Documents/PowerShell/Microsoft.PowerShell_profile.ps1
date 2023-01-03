function home_path_replace($path) {
    "${path}" -replace [Regex]::Escape("${env:HOMEDRIVE}${env:HOMEPATH}"), "~"
}

function user_path_replace($path) {
    "${path}" -replace [Regex]::Escape("${env:USERNAME}"), "~"
}

function last_command_status($last_exit_code) {
    if ($last_exit_code -ne 0) {
        return "`e[31m($last_exit_code) "
    }
}

function show_git_info($branch) {
    $git_toplevel = (Get-Item $(git rev-parse --show-toplevel)).Parent.FullName
    $git_relative_path = $(Get-Location) -replace [Regex]::Escape("${git_toplevel}\"), ""
    $pretty_path = $(user_path_replace "${git_relative_path}") -replace '/', '\'

    $git_porcelain = git status --porcelain --branch --ahead-behind

    $info = "`e[94m${pretty_path} `e[96m${branch} "
    $info += "`e[32m$(($git_porcelain | Select-String -CaseSensitive "^M").Length)|"
    $info += "`e[32m$(($git_porcelain | Select-String -CaseSensitive "^R").Length)|"
    $info += "`e[32m$(($git_porcelain | Select-String -CaseSensitive "^A").Length)|"
    $info += "`e[31m$(($git_porcelain | Select-String -CaseSensitive "^D").Length)|"
    $info += "`e[97m$(($git_porcelain | Select-String -CaseSensitive "^.M").Length)|"
    $info += "`e[34m$(($git_porcelain | Select-String -CaseSensitive "^\?\?").Length)|"
    $info += "`e[31m$(($git_porcelain | Select-String -CaseSensitive "^.D").Length)"

    $ahead = $git_porcelain | Select-String "ahead (\d+)"
    $behind = $git_porcelain | Select-String "behind (\d+)"
    if ($ahead -or $behind) {
        $info += " "
        if ($ahead) {
            $info += "`e[34m$(${ahead}.Matches.Groups[1].Value)↑"
        }
        if ($behind) {
            $info += "`e[34m$(${behind}.Matches.Groups[1].Value)↓"
        }
    }

    $git_stash_list = (git stash list | Measure-Object -Line).Lines
    if ($git_stash_list -gt 0) {
        $info += " `e[34m${git_stash_list}✗"
    }

    return "${info}"
}

function current_dir_info() {
    $branch = git branch --show-current
    if ($LASTEXITCODE -eq 0) {
        return $(show_git_info "${branch}")
    }
    else {
        return "`e[36m$(home_path_replace $(Get-Location))"
    }
}

function prompt_char() {
    # FIXME Detect administrator privileges
    return ">"
}

function right_prompt() {
    $right_message = ""

    $last_command = Get-History -Count 1
    $execution_time = ($last_command.EndExecutionTime - $last_command.StartExecutionTime).Seconds

    if ($execution_time -gt 1) {
        $right_message += "${execution_time}s"
    }

    $window_host = Get-Host
    $original_position = $window_host.UI.RawUI.CursorPosition
    $new_position = $original_position

    $buffer_size = $window_host.UI.RawUI.BufferSize
    $new_position.X = $buffer_size.Width - "${right_message}".Length

    $window_host.UI.RawUI.CursorPosition = $new_position
    if ("${right_message}".Length -gt 0) {
        Write-Host "`e[90m${right_message}" -ForegroundColor DarkGray -NoNewline
    }
    $window_host.UI.RawUI.CursorPosition = $original_position
}

function my_prompt($last_exit_code) {
    $last_exit_code = 0
    if (Test-Path variable:global:LASTEXITCODE) {
        $last_exit_code = $LASTEXITCODE
    }

    right_prompt

    Write-Host "$(last_command_status $last_exit_code)`e[0m$(current_dir_info)`e[0m $(prompt_char)`e[0m" -NoNewline
    $LASTEXITCODE = $last_exit_code
    return " "
}

function Prompt {
    my_prompt $last_exit_code
}

# Source PS resources
. ~/.aliases.ps1 | Out-Null
. ~/.env.ps1 | Out-Null
. ~/repos/personal/keys/tokens.ps1 | Out-Null

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
