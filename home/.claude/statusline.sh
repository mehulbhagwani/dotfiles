#!/usr/bin/env bash
# Claude Code status line: starship-style directory + git, then model, context
# LEFT, 5-hour limit LEFT and 7-day limit LEFT (subscription plan - no $ cost).
input=$(cat)
j() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }

cwd=$(j '.workspace.current_dir // .cwd // empty'); [ -n "$cwd" ] || cwd=$PWD
dir=${cwd/#$HOME/\~}; case "$dir" in */*/*/*) dir="…/${dir##*/}";; esac
model=$(j '.model.display_name // empty')
ctx_left=$(j '.context_window.remaining_percentage // empty'); ctx_left=${ctx_left%.*}
h5_used=$(j '.rate_limits.five_hour.used_percentage // empty'); h5_reset=$(j '.rate_limits.five_hour.resets_at // empty')
d7_used=$(j '.rate_limits.seven_day.used_percentage // empty'); d7_reset=$(j '.rate_limits.seven_day.resets_at // empty')

c_dir=$'\033[1;36m'; c_git=$'\033[1;35m'; c_st=$'\033[31m'; c_dim=$'\033[2m'; c_model=$'\033[1;34m'; r=$'\033[0m'
tone() { # colour by percent LEFT
  local p=${1%.*}; if [ "$p" -gt 50 ] 2>/dev/null; then printf '\033[32m'; elif [ "$p" -gt 20 ] 2>/dev/null; then printf '\033[33m'; else printf '\033[31m'; fi; }
when() { # epoch -> HH:MM today, else weekday HH:MM
  local e=$1; [ -n "$e" ] || return; if [ "$(date -r "$e" +%j)" = "$(date +%j)" ]; then date -r "$e" +%H:%M; else date -r "$e" '+%a %H:%M'; fi; }

out="${c_dir}${dir}${r}"
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  br=$(git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  st=""; read -r ahead behind < <(git -C "$cwd" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null || echo "0 0")
  [ "${ahead:-0}" -gt 0 ] && st+="⇡"; [ "${behind:-0}" -gt 0 ] && st+="⇣"
  porc=$(git -C "$cwd" status --porcelain 2>/dev/null)
  printf '%s' "$porc" | grep -q '^.M\|^M' && st+="!"; printf '%s' "$porc" | grep -q '^A\|^M ' && st+="+"; printf '%s' "$porc" | grep -q '^??' && st+="?"
  git -C "$cwd" rev-parse -q --verify refs/stash >/dev/null 2>&1 && st+="\$"
  out+=" ${c_git}on  ${br}${r}"; [ -n "$st" ] && out+=" ${c_st}[${st}]${r}"
fi
[ -n "$model" ] && out+="  ${c_model}${model}${r}"
[ -n "$ctx_left" ] && out+=" $(tone "$ctx_left")ctx ${ctx_left}% left${r}"
if [ -n "$h5_used" ]; then l=$((100 - ${h5_used%.*})); out+=" $(tone "$l")5h ${l}% left${r}${c_dim}$( [ -n "$h5_reset" ] && printf ' ↻%s' "$(when "$h5_reset")")${r}"; fi
if [ -n "$d7_used" ]; then l=$((100 - ${d7_used%.*})); out+=" $(tone "$l")7d ${l}% left${r}${c_dim}$( [ -n "$d7_reset" ] && printf ' ↻%s' "$(when "$d7_reset")")${r}"; fi
printf '%s\n' "$out"
