#!/bin/bash

if [ `tmux display -p '#{session_name}'` = 'wrangler' ]; then
    tmux switch-client -t 'main'
else
    window_name=`tmux display -p '#{window_name}'`
    window_pwd=`tmux display -p '#{pane_current_path}'`
    tmux switch-client -t 'wrangler'
    wrangler_window_id=`tmux list-windows -F '#{window_id}' -f "#{==:#{window_name},$window_name}"`
    if [ -n "$wrangler_window_id" ]; then
        tmux select-window -t "$wrangler_window_id"
    else
        tmux neww -n "$window_name" -c "$window_pwd"
        tmux send C-l 'wrangler pages dev public' Enter
    fi
fi
