#!/bin/bash

wrangler_sibling_window_id=`tmux show -wv '@wrangler-sibling-window-id'`

if [ -n "$wrangler_sibling_window_id" ]; then
    tmux switch-client -t `tmux display -p -t "$wrangler_sibling_window_id" '#{window_id}'`
    tmux select-window -t "$wrangler_sibling_window_id"
else
    window_id=`tmux display -p '#{window_id}'`
    window_name=`tmux display -p '#{window_name}'`
    window_pwd=`tmux display -p '#{pane_current_path}'`
    tmux switch-client -t 'wrangler'
    wrangler_window_id=`tmux neww -P -F '#{window_id}' -n "$window_name" -c "$window_pwd"`
    tmux set-option -wF                           '@parent-window-id' "$window_id"
    tmux set-option -wF                 '@wrangler-sibling-window-id' "$window_id"
    tmux set-option -wF -t "$window_id" '@wrangler-sibling-window-id' "$wrangler_window_id"
    next_port=`tmux show -sv '@wrangler-next-port'`
    tmux set -s '@wrangler-next-port' $(($next_port + 1))
    tmux send C-l "wrangler pages dev public --port $next_port" Enter
fi
