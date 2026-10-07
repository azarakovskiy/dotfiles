# shellcheck shell=zsh

if [[ -o interactive ]]; then
  # Slash and other punctuation are word boundaries. Default WORDCHARS includes "/".
  autoload -Uz select-word-style
  select-word-style bash
  bindkey "^[[1;9D" backward-word
  bindkey "^[[1;9C" forward-word
fi

alias chrome_no_cors='open -na "Google Chrome" --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'

# Load a project-local .zsh_config on directory change, once per directory.
if ! typeset -f devtools_load_local_zsh_config >/dev/null 2>&1; then
  typeset -g DEVTOOLS_LAST_LOCAL_ZSH_CONFIG=""

  function devtools_load_local_zsh_config() {
    emulate -L zsh

    local config_file="$PWD/.zsh_config"

    if [[ -r "$config_file" ]]; then
      if [[ "$DEVTOOLS_LAST_LOCAL_ZSH_CONFIG" != "$config_file" ]]; then
        DEVTOOLS_LAST_LOCAL_ZSH_CONFIG="$config_file"
        echo "Loaded .zsh_config from $PWD"
        source "$config_file"
      fi
    else
      DEVTOOLS_LAST_LOCAL_ZSH_CONFIG=""
    fi
  }
fi

autoload -Uz add-zsh-hook
if [[ "${DEVTOOLS_CHPWD_HOOK_INSTALLED:-0}" -eq 0 ]]; then
  add-zsh-hook chpwd devtools_load_local_zsh_config
  typeset -g DEVTOOLS_CHPWD_HOOK_INSTALLED=1
fi

devtools_load_local_zsh_config
