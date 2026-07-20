# tmux Configuration

A Vim-style tmux configuration with popup selectors for sessions, windows, and panes.

## Requirements

* tmux
* fish
* fzf

## Prefix

| Key       | Action                                |
| --------- | ------------------------------------- |
| `C-a`     | Prefix                                |
| `C-a C-a` | Send `C-a` to the current application |

## Pane Navigation

| Key       | Action                   |
| --------- | ------------------------ |
| `C-a h`   | Move left                |
| `C-a j`   | Move down                |
| `C-a k`   | Move up                  |
| `C-a l`   | Move right               |
| `C-a H`   | Resize left              |
| `C-a J`   | Resize down              |
| `C-a K`   | Resize up                |
| `C-a L`   | Resize right             |
| `C-a Tab` | Select the previous pane |
| `C-a z`   | Toggle pane zoom         |
| `C-a q`   | Show pane numbers        |
| `C-a <`   | Swap pane up             |
| `C-a >`   | Swap pane down           |

## Windows and Sessions

| Key       | Action                    |
| --------- | ------------------------- |
| `C-a c`   | Create a new window       |
| `C-a C-h` | Previous window           |
| `C-a C-l` | Next window               |
| `C-a C-j` | Previous session          |
| `C-a C-k` | Next session              |
| `C-a s`   | Select a session with fzf |
| `C-a w`   | Select a window with fzf  |
| `C-a f`   | Select a pane with fzf    |

## Splits

| Key         | Action                 |
| ----------- | ---------------------- |
| `C-a \|`    | Split horizontally     |
| `C-a -`     | Split vertically       |
| `C-a Space` | Cycle layouts          |
| `C-a t`     | Tiled layout           |
| `C-a m`     | Main vertical layout   |
| `C-a M`     | Main horizontal layout |
| `C-a e`     | Even horizontal layout |
| `C-a E`     | Even vertical layout   |

New windows and panes inherit the current pane directory.

## Popups and Commands

| Key           | Action                   |
| ------------- | ------------------------ |
| `C-a p`       | Open a shell popup       |
| `C-a C-p`     | Open a large shell popup |
| `C-a C-Space` | Open the command menu    |
| `C-a r`       | Reload the configuration |
| `C-a C-e`     | Edit `~/.tmux.conf`      |

## Copy Mode

| Key      | Action                     |
| -------- | -------------------------- |
| `C-a [`  | Enter copy mode            |
| `v`      | Start selection            |
| `V`      | Select line                |
| `C-v`    | Toggle rectangle selection |
| `y`      | Copy selection             |
| `Y`      | Copy line                  |
| `/`      | Search forward             |
| `?`      | Search backward            |
| `n`      | Next search result         |
| `N`      | Previous search result     |
| `C-u`    | Half page up               |
| `C-d`    | Half page down             |
| `g`      | Top of history             |
| `G`      | Bottom of history          |
| `Escape` | Exit copy mode             |
| `C-a ]`  | Paste buffer               |

## Destructive Actions

| Key       | Action                   |
| --------- | ------------------------ |
| `C-a x`   | Kill the current pane    |
| `C-a X`   | Kill the current window  |
| `C-a C-x` | Kill the current session |

Destructive actions require confirmation.
