
# override keybind settings.
fish_vi_key_bindings
function fish_user_key_bindings
  bind -M insert -m default \cr 'peco_select_history (commandline -b)'
  bind -M insert -m default \cx\ck peco_kill
  bind -M insert -m default \cx\cr peco_recentd
  bind -M insert -m default jj force-repaint
  bind -M insert -m default \cf end-of-line
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
    echo (set_color blue)"["(prompt_pwd)"]"(set_color brblack)(git_branch)
end

# aliases
alias ls='exa'
alias ll='exa -l'
alias la='exa -la'
alias llg='exa -l --git'
alias llt='exa -l --tree'

set PATH $PATH '/home/linuxbrew/.linuxbrew/bin' '/home/linuxbrew/.linuxbrew/sbin'
set PATH $PATH $HOME/.pyenv/shims 
eval (pyenv init - | source)
