#!/bin/bash

if [ -z "$1" ]; then
   exit 0
fi

windows=$(tmux list-windows -a -F '#{window_id}' -f "#{==:#{@wrangler-sibling-window-id},$1}")

if [ -n "$windows" ]; then
    for sibling in "$windows"; do
        tmux set-option -uw -t "$sibling" '@wrangler-sibling-window-id'
    done
fi

windows=$(tmux list-windows -a -F '#{window_id}' -f "#{==:#{@parent-window-id},$1}")

if [ -z "$windows" ]; then
   exit 0
fi

for child in "$windows"; do
    tmux kill-window -t "$child"
done

tmux display -d '500' "Killed child windows."

exit 0
