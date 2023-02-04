#!/bin/bash

if [ -z "$1" ]; then
   exit 0
fi

buffer=$(tmux list-buffers -F '#{buffer_name}' -f "#{==:#{buffer_name},$1}")

if [ -n "$buffer" ]; then
    tmux delete-buffer -b "$buffer"
fi

exit 0
