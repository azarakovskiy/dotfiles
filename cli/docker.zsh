# shellcheck shell=zsh

function docker_stop_all_containers() {
  emulate -L zsh

  if ! command -v docker >/dev/null 2>&1; then
    echo "docker is not installed." >&2
    return 1
  fi

  local -a container_ids
  container_ids=("${(@f)$(docker ps -q)}")

  if (( ${#container_ids[@]} == 0 )); then
    echo "No running containers."
    return 0
  fi

  docker stop "${container_ids[@]}"
}

alias dockstop=docker_stop_all_containers
