#!/bin/sh
# herdr fuzzy switcher (tmux-fzf style).
# Lists every workspace and tab, lets you fuzzy-pick one with fzf, and jumps to it.
# Wired to a key via [[keys.command]] in ~/.config/herdr/config.toml.
#
# Granularity is workspace + tab (≈ tmux session + window); panes within a tab
# are reached with prefix+h/j/k/l. herdr exposes no focus-pane-by-id over the CLI.

rows=$(
  # Workspaces
  herdr workspace list | jq -r '
    .result.workspaces[]
    | "ws\t\(.workspace_id)\t \(.label)  ·  [\(.agent_status)]  (workspace)"'
  # Tabs, grouped under each workspace
  herdr workspace list | jq -r '.result.workspaces[].workspace_id' \
  | while IFS= read -r wid; do
      herdr tab list --workspace "$wid" | jq -r --arg w "$wid" '
        .result.tabs[]?
        | "tab\t\(.tab_id)\t   ↳ \(.label)  ·  [\(.agent_status)]  (\($w))"'
    done
)

[ -n "$rows" ] || exit 0

sel=$(printf '%s\n' "$rows" \
  | fzf --delimiter='\t' --with-nth=3.. \
        --prompt='herdr > ' --reverse --height='100%' \
        --header='Enter: jump to workspace/tab   Esc: cancel') || exit 0

kind=$(printf '%s' "$sel" | cut -f1)
id=$(printf '%s' "$sel" | cut -f2)
[ -n "$id" ] || exit 0

case "$kind" in
  ws)  herdr workspace focus "$id" ;;
  tab) herdr tab focus "$id" ;;
esac
