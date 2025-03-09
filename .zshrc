# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Automatically setup zinit.
# Store in xdg data home if available.
# Else, store in ~/.local/share
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if not ready
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone git@github.com:zdharma-continuum/zinit.git $ZINIT_HOME
fi

source "${ZINIT_HOME}/zinit.zsh"

# install p10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# All the plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybinds
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Shared history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completions styles
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
 
# Various autocomplete and program setup.
autoload -Uz compinit && compinit
zinit cdreplay -q
if [ -x "$(command -v /opt/homebrew/bin/brew)" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [ -x "$(command -v direnv)" ]; then
  eval "$(direnv hook zsh)"
fi
if [ -x "$(command -v jj)" ]; then
  source <(jj util completion zsh)
fi
if [ -x "$(command -v fzf)" ]; then
  eval "$(fzf --zsh)"
fi
if [ -x "$(command -v zoxide)" ]; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# Default programs
if [ -x "$(command -v hx)" ]; then
  export EDITOR='hx'
elif [ -x "$(command -v nvim)" ]; then
  export EDITOR='nvim'
elif [ -x "$(command -v vim)" ]; then
  export EDITOR='vim'
elif [ -x "$(command -v vi)" ]; then
  export EDITOR='vi'
fi
export PAGER="less"
export LESS="-Rc"

# Aliases
alias ls='ls --color'
alias hx="hx --log /dev/null"

# Path updates
export PATH="~/go/bin:$PATH"
export PATH="~/.local/bin:$PATH"
export PATH="~/Projects/roc/target/release:$PATH"
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

# Misc config
export CMAKE_GENERATOR=Ninja
export AFL_AUTORESUME=1

