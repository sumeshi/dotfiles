#!/usr/bin/env fish

set -l mode session

if test (count $argv) -ge 1
    set mode $argv[1]
end

switch $mode
    case session
        set -l selection (
            tmux list-sessions \
                -F '#{session_id}\t#{session_name}\t#{session_windows} windows\t#{?session_attached,attached,detached}' |
            fzf \
                --delimiter=\t \
                --with-nth=2.. \
                --layout=reverse \
                --border=rounded \
                --prompt='session> ' \
                --header='Enter: switch / Esc: close' \
                --preview='tmux capture-pane -ep -t {1}: -S -100 2>/dev/null' \
                --preview-window='right,60%,border-left'
        )

    case window
        set -l selection (
            tmux list-windows \
                -a \
                -F '#{session_id}:#{window_index}\t#{session_name}:#{window_index}\t#{window_name}\t#{pane_current_command}\t#{pane_current_path}' |
            fzf \
                --delimiter=\t \
                --with-nth=2.. \
                --layout=reverse \
                --border=rounded \
                --prompt='window> ' \
                --header='Enter: switch / Esc: close' \
                --preview='tmux capture-pane -ep -t {1} -S -100 2>/dev/null' \
                --preview-window='right,60%,border-left'
        )

    case pane
        set -l selection (
            tmux list-panes \
                -a \
                -F '#{session_id}:#{window_index}.#{pane_index}\t#{session_name}:#{window_index}.#{pane_index}\t#{window_name}\t#{pane_current_command}\t#{pane_current_path}' |
            fzf \
                --delimiter=\t \
                --with-nth=2.. \
                --layout=reverse \
                --border=rounded \
                --prompt='pane> ' \
                --header='Enter: switch / Esc: close' \
                --preview='tmux capture-pane -ep -t {1} -S -100 2>/dev/null' \
                --preview-window='right,60%,border-left'
        )

    case '*'
        echo "Usage: "(status filename)" {session|window|pane}" >&2
        exit 2
end

or exit 0

test -n "$selection"
or exit 0

set -l target (string split -m 1 \t -- "$selection")[1]

tmux switch-client -t "$target"