function _git_status
    printf " %s %s " (set_color cyan) (git branch --show-current 2>/dev/null || return)

    set -f _git_porcelain (git status --porcelain --ahead-behind 2>/dev/null)

    set -f _staged_added (printf "$_git_porcelain" | grep -c '^A')
    set -f _staged_renamed (printf "$_git_porcelain" | grep -c '^R')
    set -f _staged_modified (printf "$_git_porcelain" | grep -c '^M')
    set -f _staged_deleted (printf "$_git_porcelain" | grep -c '^D')
    set -f _unstaged_modified (printf "$_git_porcelain" | grep -c '^.M')
    set -f _unstaged_untracked (printf "$_git_porcelain" | grep -c '^??')
    set -f _unstaged_deleted (printf "$_git_porcelain" | grep -c '^.D')

    printf "%s%s+ %s~ %s• %s%s- %s%s• %s%s- %s%s? " \
        (set_color green) $_staged_added $_staged_renamed $_staged_modified \
        (set_color red) $_staged_deleted \
        (set_color white) $_unstaged_modified \
        (set_color red) $_unstaged_deleted \
        (set_color blue) $_unstaged_untracked

    set -f _ahead (printf "$_git_porcelain" | awk '/ahead/ {print substr($4,1,length($4)-1)}')
    set -f _behind (printf "$_git_porcelain" | awk '/behind/ {print substr($4,1,length($4)-1)}')

    if [ "$_ahead" ] || [ "$_behind" ]
        printf " "
        if [ "$_ahead" -gt 0 ]
            printf "%s%s↑" (set_color blue) $_ahead
        end
        if [ "$_behind" -gt 0 ]
            printf "%s%s↓" (set_color blue) $_behind
        end
    end

    set -f _git_stash_count "(git stash list | grep "" -c)"
    # if [ $_git_stash_count -gt 0 ]
    #     printf " %s%s✗" (set_color blue) $_git_stash_count
    # end
end

function _get_exit_status
    set -g _exit_code $status
    set -g _exit_status
    if test $_exit_code -ne 0
        set -g _exit_status (printf "%s[%s] " (set_color red) $_exit_code)
    end
end

function _get_duration
    set -g _duration (printf "%s%s" (set_color $fish_color_comment) (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}'))
end

function _get_info
    set -g _current_time (printf "%s%s" (set_color normal) (date +%I:%M))
    set -g _git_prompt (printf "%s%s" (set_color $fish_color_keyword) (_git_status))
    set -g _pwd (printf " %s%s" (set_color $fish_color_cwd) (prompt_pwd))
end

function fish_prompt
    _get_exit_status
    _get_duration
    printf "%s%s%s > " $_exit_status $_duration (set_color normal)
end

function fish_right_prompt
    _get_info
    printf "%s%s %s%s" $_pwd $_git_prompt $_current_time (set_color normal)
end
