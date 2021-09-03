function home_path_replace($path) {
    "${path}" -replace [Regex]::Escape("${env:HOMEDRIVE}${env:HOMEPATH}"), "~"
}

function user_path_replace($path) {
    "${path}" -replace [Regex]::Escape("${env:USERNAME}"), "~"
}

function last_command_status($last_exit_code) {
    if ($last_exit_code -ne 0) {
        Write-Host "($last_exit_code) " -ForegroundColor Red -NoNewline
    }
}

function show_git_info($branch) {
    $git_toplevel = (Get-Item $(git rev-parse --show-toplevel)).Parent.FullName
    $git_relative_path = $(Get-Location) -replace [Regex]::Escape("${git_toplevel}\"), ""
    $pretty_path = $(user_path_replace "${git_relative_path}") -replace '/', '\'

    Write-Host "${pretty_path}" -ForegroundColor Cyan -NoNewline
    Write-Host " $branch " -ForegroundColor Magenta -NoNewline

    Write-Host (git status --porcelain | Select-String "^A").Length -ForegroundColor Green -NoNewline
    Write-Host (git status --porcelain | Select-String "^M").Length -ForegroundColor Green -NoNewline
    Write-Host (git status --porcelain | Select-String "^ M").Length -ForegroundColor White -NoNewline
    Write-Host (git status --porcelain | Select-String "^ D").Length -ForegroundColor Red -NoNewline
    Write-Host (git status --porcelain | Select-String "^\?\?").Length -ForegroundColor Blue -NoNewline

    Write-Host " " -NoNewline
}

function current_dir_info() {
    $branch = git branch --show-current
    if ($LASTEXITCODE -eq 0) {
        show_git_info "${branch}"
    }
    else {
        Write-Host "$(home_path_replace $(Get-Location)) " -ForegroundColor DarkCyan -NoNewline
    }
}

function prompt_char() {
    # echo -n "%(!.#.>)"
    # FIXME Detect administrator privileges
    Write-Host ('>') -NoNewline
}

function right_prompt() {
    $right_message = ""
    $extra_character_length = 0

    $last_command = Get-History -Count 1
    $execution_time = ($last_command.EndExecutionTime - $last_command.StartExecutionTime).Seconds

    if ($execution_time -gt 1) {
        $right_message = "${execution_time}s"
        $extra_character_length = 2
    }

    $window_host = $(Get-Host)
    $original_position = $window_host.UI.RawUI.CursorPosition
    $new_position = $original_position

    $buffer_size = $window_host.UI.RawUI.BufferSize
    $new_position.X = $buffer_size.Width - ("${right_message}".Length + $extra_character_length)

    $window_host.UI.RawUI.CursorPosition = $new_position
    if ("${right_message}".Length -gt 0) {
        Write-Host "[" -ForegroundColor Blue -NoNewline
        Write-Host $right_message -ForegroundColor DarkGray -NoNewline
        Write-Host "]" -ForegroundColor Blue -NoNewline
    }
    $window_host.UI.RawUI.CursorPosition = $original_position
}

function my_prompt($last_exit_code) {
    $last_exit_code = 0
    if (Test-Path variable:global:LASTEXITCODE) {
        $last_exit_code = $LASTEXITCODE
    }

    last_command_status $last_exit_code

    current_dir_info

    prompt_char

    right_prompt

    $LASTEXITCODE = $last_exit_code
    return " "
}

