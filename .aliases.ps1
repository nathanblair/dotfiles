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
function g { git status -bs -u --ahead-behind }
function gst { git status }
function glsg { git log --oneline --graph }
function glsgs { git log --oneline --graph --stat }
function glg { git log --graph }
function glgs { git log --graph --stat }
function glgp { git log --graph --patch }
function gs ($branch) { git switch $branch }
function gsc ($branch) { git switch -c $branch }
function gpush ($arguments) { git push $arguments }
function gpull { git pull }

# Docker function commands
function disa { docker images -a }
function dpsa { docker ps -a }
function dcrit ($arguments) { docker run --rm -it $arguments }

# Terraform alias
Set-Alias -Name tf -Value terraform
