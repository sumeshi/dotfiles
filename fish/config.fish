# fuck you fish
set fish_greeting

# override keybind settings.
fish_vi_key_bindings
function fish_user_key_bindings
  bind -M insert -m default jj force-repaint
end

# functions
function git_branch
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
end

# override prompt
function fish_mode_prompt
end
function fish_prompt
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        switch $fish_bind_mode
            case default
                set_color red white
				echo -n "| " 
            case insert
                set_color cyan white
				echo -n "= " 
            case replace-one
                set_color cyan white
				echo -n "= " 
            case visual
                set_color magenta white
				echo -n "+ " 
            end
        echo (set_color white)(echo $USER) (set_color white)(date "+%H:%M:%S")"> "
    end
end

function fish_right_prompt
    echo "["(prompt_pwd)"]" (git_branch)
end

# aliases
## ls
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias llg='eza -l --git'
alias llt='eza -l --tree'

## file manager
# alias y='yazi'
alias s='spf'

# language code
export LC_ALL="C.UTF-8"

# set path
# set PATH $PATH '/home/linuxbrew/.linuxbrew' '/home/linuxbrew/.linuxbrew/bin' '/home/linuxbrew/.linuxbrew/sbin'

zoxide init fish | source
