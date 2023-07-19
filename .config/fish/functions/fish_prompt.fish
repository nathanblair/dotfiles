function _git_status
    printf " %s %s " (set_color brmagenta) (git branch --show-current 2>/dev/null || return)

    set -f _git_porcelain "$(git status --porcelain --branch --ahead-behind)"

    set -f _ahead (printf "$_git_porcelain" | awk '/ahead/ {print substr($4,1,length($4)-1)}')
    set -f _behind (printf "$_git_porcelain" | awk '/behind/ {print substr($4,1,length($4)-1)}')

    if test $_ahead || test $_behind
        printf "%s" (set_color blue)
        if [ $_ahead ] && [ $_ahead -gt 0 ]
            printf "%s↑ " $_ahead
        end
        if [ $_behind ] && [ $_behind -gt 0 ]
            printf "%s↓ " $_behind
        end
    end

    set -f _staged_added (printf $_git_porcelain | grep -c '^A')
    set -f _staged_renamed (printf $_git_porcelain | grep -c '^R')
    set -f _staged_modified (printf $_git_porcelain | grep -c '^M')
    set -f _staged_deleted (printf $_git_porcelain | grep -c '^D')
    set -f _unstaged_modified (printf $_git_porcelain | grep -c '^.M')
    set -f _unstaged_deleted (printf $_git_porcelain | grep -c '^.D')
    set -f _unstaged_untracked (printf $_git_porcelain | grep -c '^??')

    printf "%s%s• %s+ %s~ %s- %s%s• %s- %s?" \
        (set_color white) $_staged_modified $_staged_added $_staged_renamed $_staged_deleted \
        (set_color brblack) $_unstaged_modified $_unstaged_deleted $_unstaged_untracked

    set -f _git_stash_count (git stash list | grep "" -c 2>/dev/null)
    if test $_git_stash_count -gt 0
        printf " %s%s✗" (set_color blue) $_git_stash_count
    end
end

function _get_duration
    set -f _raw_duration (echo "$CMD_DURATION 1000" | awk '{printf "%.1f", $1 / $2}')
    if test $_raw_duration -gt 2
        set -g _duration (printf " %s%ss" (set_color $fish_color_comment) $_raw_duration)
    else
        set -e _duration
    end
end

function fish_prompt
    set -g _exit_code $status
    set -g _exit_status
    if test $_exit_code -ne 0
        set -g _exit_status (printf "%s[%s]" (set_color red) $_exit_code)
    end

    _get_duration

    printf "%s%s%s > " $_exit_status $_duration (set_color normal)
end

function fish_right_prompt
    set -g _pwd (printf " %s%s" (set_color $fish_color_cwd) (prompt_pwd))
    set -g _git_prompt (printf "%s%s" (set_color $fish_color_keyword) (_git_status))

    printf "%s%s %s%s" $_pwd $_git_prompt (set_color normal) (date +%I:%M)
end
