#
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh
#

type git >/dev/null 2>&1 || { echo '...skip'; return; }

# Aliases
alias g='git'
compdef g=git
alias gi='git'
compdef gi=git
alias gst='git status'
compdef _git gst=git-status
alias gpl='git pull'
compdef _git gpl=git-pull
alias gup='git fetch && git rebase'
compdef _git gup=git-fetch
alias gp='git push'
compdef _git gp=git-push
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gc='git commit -v'
compdef _git gc=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcm='git checkout master'
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias glg='git log --stat --max-count=5'
compdef _git glg=git-log
alias glgg='git log --graph --max-count=5'
compdef _git glgg=git-log
alias gss='git status -s'
compdef _git gss=git-status
alias ga='git add'
compdef _git ga=git-add
alias gm='git merge'
compdef _git gm=git-merge
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gsr='git svn rebase'
alias gsd='git svn dcommit'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
compdef ggpull=git
alias ggpush='git push origin $(current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef ggpnp=git


## Additional
function is_git_repo() {
    if ! type git > /dev/null 2>&1; then
        echo 'Error: Git is not installed' 2>&1
        return 1
    fi
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" != "true" ]; then
        echo 'Error: Not a git repository' 2>&1
        return 1
    fi
}

function cd_git_toplevel() {
    is_git_repo || return 1
    cd "$(git rev-parse --show-toplevel)" >/dev/null 2>&1
}

function gsmupdate() {
    (
        cd_git_toplevel
        git submodule foreach "git checkout master; git pull"
    )
}

function cdg() {
    is_git_repo || return 1
    cd "./$(git rev-parse --show-cdup)"
    [ -n "$1" ] && cd "$1"
    return 0
}

function gi() {
    curl http://gitignore.io/api/$@
}

# $1: period (e.g. --since=1 hours ago)
# http://qiita.com/yuku_t/items/7c2077e31b2480a2689e
function commits_of_the_day() {
    local  head_branch remote_name url project period
    local -a remote_show
    period=${1:-'--since=12 hours ago'}
    head_branch=$(git symbolic-ref -q --short HEAD) || return 1
    remote_name=$(git config "branch.${head_branch}.remote") || return 1
    url=$(git config "remote.${remote_name}.url") || return 1
    if [[ ! $url =~ 'github.com' ]]; then
        remote_show=($(git remote -v show | command grep 'github\.com' | head -n 1)) || return 1
        url=${remote_show[2]}
    fi
    [[ -z $url ]] && return 1
    project="${${url#*github.com?}%.git}"
    echo "Project: [$project](https://github.com/${project})"
    echo "Author : $(git config user.name) <$(git config user.email)>"
    echo "Date   : $(LANG=C date +"%a %D %H:%M:%S")"
    echo "hash | title"
    echo "-----|------"
    git log --oneline "$period" --author=$(git config user.email) --pretty="format:[%h](https://github.com/${project}/commit/%h) | %s" | perl -nle "\$_ =~ s|#(\\d+)|[#\\1](https://github.com/${project}/pull/\\1)|g; print \$_"
}

alias gs='git status -sb'
compdef _git gs=git-status

alias gsi='git status -b --ignored'
compdef _git gsi=git-status

alias gl='git l'
compdef _git gl=git-log

alias gitsearch='git rev-list --all | xargs git grep -F'

alias gd='git diff'
compdef _git gd=git-diff

alias gd1='git diff HEAD~'
compdef _git gd1=git-diff

alias vg='git-edit'
compdef _git-edit vg
