export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# Lazy load nvm for faster shell startup
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

autoload -U add-zsh-hook

load-nvmrc() {
  # Load nvm if not already loaded
  if ! command -v nvm_find_nvmrc &> /dev/null; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  fi

  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      echo "Node version not installed. Run 'nvm install' to install it."
      return
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use --silent
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    nvm use default --silent
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

eval "$(starship init zsh)"

# Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

aws_sso_login_if_needed() {
    if ! aws sts get-caller-identity &>/dev/null; then
        echo "AWS SSO session expired or not authenticated. Logging in..."
        aws sso login
    else
        echo "Already authenticated with AWS SSO"
    fi
}

alias stripecli='stripe listen --forward-to http://localhost:3001/v3/billing/webhook'
alias cleartsbuildinfo='find . -type f -name "*.tsbuildinfo" -print -delete'
