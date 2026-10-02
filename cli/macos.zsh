# shellcheck shell=zsh

# Applied on shell startup so these can change without bootstrap.

__devtools_mouse_scaling="$(defaults read -g com.apple.mouse.scaling 2>/dev/null || true)"
if [[ -z "$__devtools_mouse_scaling" ]] || (( __devtools_mouse_scaling != 9.0 )); then
  defaults write -g com.apple.mouse.scaling -float 9.0
fi

__devtools_font_smoothing="$(defaults -currentHost read -g AppleFontSmoothing 2>/dev/null || true)"
if [[ "$__devtools_font_smoothing" != "0" ]]; then
  defaults -currentHost write -g AppleFontSmoothing -int 0
fi

unset __devtools_mouse_scaling __devtools_font_smoothing
