# Store env variables in ~/.localrc to prevent any private info from being 
# tracked in git
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

alias ls='eza --classify'
alias tree='eza --tree'

cdj() {
    pushd ~/Documents/*/*/${$1}*
}

# Prompt formatting

autoload -Uz vcs_info
autoload -U colors && colors

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # unstaged changes -> red*
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # staged changes -> yellow+
zstyle ':vcs_info:*' actionformats \
    '%F{5}%F{5}[%F{2}%b%F{3}|%F{1}%a%c%u%F{5}]%f '
zstyle ':vcs_info:*' formats '(%b%c%u%%f) '
zstyle ':vcs_info:*' enable git
theme_precmd () {
    vcs_info
}

# show hostinfo only if we are in an ssh session
hostinfo=''
if [[ -n $SSH_TTY ]]; then
  hostinfo="%B%F{red}$HOST%f%b "
fi

# only show user (in bold red) if it is root
userinfo=''
if [[ $USER == 'root' ]]; then
  userinfo="%B%F{red}${USER}%f%b "
fi
setopt prompt_subst
PROMPT_END="%#"
# show returncode of last command only when <> 0
PROMPT='${hostinfo}${userinfo}%F{yellow}%~%f ${vcs_info_msg_0_}%B%(?..%F{red}[%?] )%b%B${PROMPT_END}%b%f '
autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd

# Path exports
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"
export PATH="$HOME/.ghcup/bin:$PATH"
export PATH="/opt/homebrew/bin/ghcup:$PATH"

# opam configuration
[[ ! -r /Users/jacksonpetty/.opam/opam-init/init.zsh ]] || source /Users/jacksonpetty/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
