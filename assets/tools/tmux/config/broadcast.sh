#!/bin/bash

retval=`tmux show -sv '@retval'`

windows=$(tmux list-windows -F '#{window_id}' -f "#{!=:#{@nobroadcast},1}")

if [ -n "$windows" ]; then
    for sibling in $windows; do
        tmux run -C "send -t '$sibling' $retval"
    done
fi

exit 0
