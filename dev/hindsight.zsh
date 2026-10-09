# shellcheck shell=zsh

hindsight-up() {
  emulate -L zsh

  local config spec key compose
  config="${XDG_CONFIG_HOME:-$HOME/.config}/devtools/hindsight-openai"
  compose="${${(%):-%x}:A:h}/docker-compose.yaml"

  if [[ ! -f $config ]]; then
    echo "Hindsight key resolver is missing. Run ./install.sh" >&2
    return 1
  fi

  spec="$(<"$config")"

  case $spec in
    op://*)
      key="$(op read "$spec")" || return 1
      ;;
    env)
      key="${OPENAI_API_KEY:-}"
      ;;
    skip)
      echo "Hindsight key resolver was skipped. Delete $config and run ./install.sh to set it." >&2
      return 1
      ;;
    *)
      echo "Hindsight key resolver in $config must be an op:// reference or env." >&2
      return 1
      ;;
  esac

  if [[ -z $key ]]; then
    echo "OPENAI_API_KEY is empty." >&2
    return 1
  fi

  OPENAI_API_KEY="$key" docker compose -f "$compose" up -d
}
